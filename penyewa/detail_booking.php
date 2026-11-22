<?php
require_once "../includes/auth.php";
require_once "../config/database.php";

wajibRole("penyewa");

date_default_timezone_set("Asia/Jakarta");

$id_user = $_SESSION["id_user"];
$id_booking = isset($_GET["id"]) ? (int) $_GET["id"] : 0;

if ($id_booking <= 0) {
    die("ID booking tidak valid.");
}

// Ambil data booking milik penyewa yang sedang login
$query = "
    SELECT
        b.id_booking,
        b.kode_booking,
        b.waktu_mulai,
        b.waktu_selesai,
        b.batas_pembayaran,
        b.total_harga,
        b.total_deposit,
        b.status,
        bi.durasi_jam,
        bi.harga_sewa,
        bi.subtotal,
        bi.deposit,
        s.kode_sepeda,
        s.nama_sepeda,
        k.nama_kategori
    FROM bookings b
    JOIN booking_items bi ON b.id_booking = bi.id_booking
    JOIN bikes s ON bi.id_sepeda = s.id_sepeda
    JOIN bike_categories k ON s.id_kategori = k.id_kategori
    WHERE b.id_booking = ?
      AND b.id_user = ?
";

$stmt = mysqli_prepare($conn, $query);
mysqli_stmt_bind_param($stmt, "ii", $id_booking, $id_user);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);

if (mysqli_num_rows($result) === 0) {
    die("Data booking tidak ditemukan.");
}

$booking = mysqli_fetch_assoc($result);

function rupiah($angka) {
    return "Rp " . number_format($angka, 0, ",", ".");
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Detail Booking - SaVi Ride</title>
</head>
<body>

    <h1>Detail Pemesanan</h1>

    <p>Booking berhasil dibuat. Silakan periksa detail pemesanan berikut.</p>

    <hr>

    <h2>Informasi Booking</h2>

    <p>
        <strong>Kode Booking:</strong>
        <?php echo htmlspecialchars($booking["kode_booking"]); ?>
    </p>

    <p>
        <strong>Status:</strong>
        <?php echo htmlspecialchars($booking["status"]); ?>
    </p>

    <p>
        <strong>Sepeda:</strong>
        <?php echo htmlspecialchars($booking["nama_sepeda"]); ?>
    </p>

    <p>
        <strong>Kode Sepeda:</strong>
        <?php echo htmlspecialchars($booking["kode_sepeda"]); ?>
    </p>

    <p>
        <strong>Kategori:</strong>
        <?php echo htmlspecialchars($booking["nama_kategori"]); ?>
    </p>

    <p>
        <strong>Waktu Pengambilan:</strong>
        <?php echo date("d-m-Y H:i", strtotime($booking["waktu_mulai"])); ?>
    </p>

    <p>
        <strong>Waktu Selesai:</strong>
        <?php echo date("d-m-Y H:i", strtotime($booking["waktu_selesai"])); ?>
    </p>

    <p>
        <strong>Durasi:</strong>
        <?php echo htmlspecialchars($booking["durasi_jam"]); ?> jam
    </p>

    <hr>

    <h2>Rincian Biaya</h2>

    <p>
        <strong>Harga Sewa:</strong>
        <?php echo rupiah($booking["harga_sewa"]); ?> / jam
    </p>

    <p>
        <strong>Subtotal Sewa:</strong>
        <?php echo rupiah($booking["subtotal"]); ?>
    </p>

    <p>
        <strong>Deposit:</strong>
        <?php echo rupiah($booking["deposit"]); ?>
    </p>

    <p>
        <strong>Total Harga Sewa:</strong>
        <?php echo rupiah($booking["total_harga"]); ?>
    </p>

    <p>
        <strong>Total Deposit:</strong>
        <?php echo rupiah($booking["total_deposit"]); ?>
    </p>

    <h3>
        Total yang Harus Dibayar:
        <?php echo rupiah($booking["total_harga"] + $booking["total_deposit"]); ?>
    </h3>

    <p>
        <strong>Batas Pembayaran:</strong>
        <?php echo date("d-m-Y H:i", strtotime($booking["batas_pembayaran"])); ?>
    </p>

    <hr>

    <p>
        Silakan lanjutkan ke proses pembayaran setelah fitur pembayaran tersedia.
    </p>

    <a href="dashboard.php">Kembali ke Dashboard</a>

</body>
</html>