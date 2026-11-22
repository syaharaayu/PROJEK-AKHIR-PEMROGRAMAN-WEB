
<?php
require_once "../includes/auth.php";
require_once "../config/database.php";

wajibRole("penyewa");

date_default_timezone_set("Asia/Jakarta");

// Pastikan halaman hanya menerima data dari form
if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../penyewa/form_pemesanan.php");
    exit;
}

// Ambil data dari form
$id_user = (int) $_SESSION["id_user"];
$id_sepeda = (int) ($_POST["id_sepeda"] ?? 0);
$jenis_pengambilan = $_POST["jenis_pengambilan"] ?? "";
$tanggal = $_POST["tanggal_pengambilan"] ?? "";
$jam = $_POST["jam_pengambilan"] ?? "";
$durasi = (int) ($_POST["durasi_jam"] ?? 0);

// Validasi input dasar
if (
    $id_sepeda <= 0 ||
    !in_array($jenis_pengambilan, ["sekarang", "nanti"], true) ||
    $durasi < 1 ||
    $tanggal === "" ||
    $jam === ""
) {
    die("Data pemesanan tidak valid.");
}

// Validasi format tanggal dan jam
$waktu_mulai_obj = DateTime::createFromFormat(
    "!Y-m-d H:i",
    $tanggal . " " . $jam
);

if (
    !$waktu_mulai_obj ||
    $waktu_mulai_obj->format("Y-m-d H:i") !== $tanggal . " " . $jam
) {
    die("Format tanggal atau jam tidak valid.");
}

$sekarang = new DateTime();
$waktu_mulai = $waktu_mulai_obj->format("Y-m-d H:i:s");

// Ambil pengaturan maksimal durasi dan pemesanan awal
$query_setting = "
    SELECT nama_setting, nilai_setting
    FROM rental_settings
    WHERE nama_setting IN (
        'maksimal_durasi_sewa',
        'maksimal_pemesanan_awal',
        'batas_pembayaran'
    )
";

$result_setting = mysqli_query($conn, $query_setting);

if (!$result_setting) {
    die("Gagal membaca pengaturan rental.");
}

$settings = [];

while ($row = mysqli_fetch_assoc($result_setting)) {
    $settings[$row["nama_setting"]] = (int) $row["nilai_setting"];
}

$maksimal_durasi = $settings["maksimal_durasi_sewa"] ?? 15;
$maksimal_pemesanan = $settings["maksimal_pemesanan_awal"] ?? 7;
$batas_menit = $settings["batas_pembayaran"] ?? 60;

if ($durasi > $maksimal_durasi) {
    die("Durasi sewa maksimal adalah $maksimal_durasi jam.");
}

// Waktu pengambilan harus di masa depan
if ($waktu_mulai_obj <= $sekarang) {
    die("Waktu pengambilan harus lebih dari waktu sekarang.");
}

// Validasi jenis pengambilan
if ($jenis_pengambilan === "sekarang") {
    if ($tanggal !== $sekarang->format("Y-m-d")) {
        die("Untuk Ambil Sekarang, pilih tanggal hari ini.");
    }
} else {
    $batas_pemesanan = (clone $sekarang)->modify(
        "+$maksimal_pemesanan days"
    );

    if ($waktu_mulai_obj > $batas_pemesanan) {
        die("Pemesanan hanya dapat dilakukan maksimal $maksimal_pemesanan hari sebelumnya.");
    }
}

// Hitung waktu selesai
$waktu_selesai_obj = clone $waktu_mulai_obj;
$waktu_selesai_obj->modify("+$durasi hours");

$waktu_selesai = $waktu_selesai_obj->format("Y-m-d H:i:s");

// Batas pembayaran
$batas_pembayaran = (clone $sekarang)
    ->modify("+$batas_menit minutes")
    ->format("Y-m-d H:i:s");

// Mulai transaksi database
mysqli_begin_transaction($conn);

try {

    // Kunci data sepeda agar tidak dipesan bersamaan
    $query_sepeda = "
        SELECT
            b.id_sepeda,
            b.id_kategori,
            b.status,
            b.kondisi,
            cr.harga_per_jam,
            cr.jumlah_deposit
        FROM bikes b
        INNER JOIN category_rates cr
            ON b.id_kategori = cr.id_kategori
        WHERE b.id_sepeda = ?
          AND b.status = 'tersedia'
          AND b.kondisi = 'baik'
          AND cr.status = 'aktif'
        FOR UPDATE
    ";

    $stmt = mysqli_prepare($conn, $query_sepeda);
    mysqli_stmt_bind_param($stmt, "i", $id_sepeda);
    mysqli_stmt_execute($stmt);

    $result_sepeda = mysqli_stmt_get_result($stmt);
    $sepeda = mysqli_fetch_assoc($result_sepeda);

    if (!$sepeda) {
        throw new Exception("Sepeda tidak tersedia atau tarif belum aktif.");
    }

    $harga_per_jam = (float) $sepeda["harga_per_jam"];
    $deposit = (float) $sepeda["jumlah_deposit"];

    // Periksa apakah sepeda sudah memiliki booking
    // pada rentang waktu yang sama
    $query_bentrok = "
        SELECT COUNT(*) AS jumlah
        FROM booking_items bi
        INNER JOIN bookings b
            ON bi.id_booking = b.id_booking
        WHERE bi.id_sepeda = ?
          AND b.status IN (
              'menunggu_pembayaran',
              'dikonfirmasi',
              'berlangsung'
          )
          AND (
              b.status <> 'menunggu_pembayaran'
              OR b.batas_pembayaran > NOW()
          )
          AND b.waktu_mulai < ?
          AND b.waktu_selesai > ?
    ";

    $stmt = mysqli_prepare($conn, $query_bentrok);

    mysqli_stmt_bind_param(
        $stmt,
        "iss",
        $id_sepeda,
        $waktu_selesai,
        $waktu_mulai
    );

    mysqli_stmt_execute($stmt);

    $result_bentrok = mysqli_stmt_get_result($stmt);
    $bentrok = mysqli_fetch_assoc($result_bentrok);

    if ((int) $bentrok["jumlah"] > 0) {
        throw new Exception("Sepeda sudah dipesan pada waktu tersebut.");
    }

    // Hitung biaya
    $subtotal = $harga_per_jam * $durasi;
    $total_harga = $subtotal;
    $total_deposit = $deposit;

    // Buat kode booking unik
    $kode_booking = "SVR-" . date("YmdHis") . "-" .
        strtoupper(bin2hex(random_bytes(3)));

    // Simpan data booking
    $query_booking = "
        INSERT INTO bookings (
            kode_booking,
            id_user,
            batas_pembayaran,
            waktu_mulai,
            waktu_selesai,
            jenis_pengambilan,
            total_harga,
            total_deposit,
            status
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'menunggu_pembayaran')
    ";

    $stmt = mysqli_prepare($conn, $query_booking);

    mysqli_stmt_bind_param(
        $stmt,
        "sissssdd",
        $kode_booking,
        $id_user,
        $batas_pembayaran,
        $waktu_mulai,
        $waktu_selesai,
        $jenis_pengambilan,
        $total_harga,
        $total_deposit
    );

    mysqli_stmt_execute($stmt);

    $id_booking = mysqli_insert_id($conn);

    // Simpan detail sepeda yang dipesan
    $query_item = "
        INSERT INTO booking_items (
            id_booking,
            id_sepeda,
            durasi_jam,
            harga_sewa,
            subtotal,
            deposit
        ) VALUES (?, ?, ?, ?, ?, ?)
    ";

    $stmt = mysqli_prepare($conn, $query_item);

    mysqli_stmt_bind_param(
        $stmt,
        "iiiddd",
        $id_booking,
        $id_sepeda,
        $durasi,
        $harga_per_jam,
        $subtotal,
        $deposit
    );

    mysqli_stmt_execute($stmt);

    // Catat aktivitas penyewa
    $aktivitas = "Membuat pemesanan sepeda";
    $detail = "Booking: " . $kode_booking;

    $query_log = "
        INSERT INTO activity_logs (
            id_user,
            aktivitas,
            detail
        ) VALUES (?, ?, ?)
    ";

    $stmt = mysqli_prepare($conn, $query_log);

    mysqli_stmt_bind_param(
        $stmt,
        "iss",
        $id_user,
        $aktivitas,
        $detail
    );

    mysqli_stmt_execute($stmt);

    // Jika semua berhasil, simpan transaksi
    mysqli_commit($conn);

    // Arahkan ke halaman hasil booking
    header(
        "Location: ../penyewa/detail_booking.php?id=" . $id_booking
    );
    exit;

} catch (Throwable $e) {

    mysqli_rollback($conn);

    die("Pemesanan gagal: " . htmlspecialchars($e->getMessage()));
}
?>
