
<?php
require_once "../includes/auth.php";
require_once "../config/database.php";

wajibRole("penyewa");

// Ambil daftar sepeda yang tersedia dan memiliki tarif aktif
$query = "
    SELECT
        b.id_sepeda,
        b.nama_sepeda,
        b.kode_sepeda,
        bc.nama_kategori,
        cr.harga_per_jam,
        cr.jumlah_deposit
    FROM bikes b
    INNER JOIN bike_categories bc
        ON b.id_kategori = bc.id_kategori
    INNER JOIN category_rates cr
        ON bc.id_kategori = cr.id_kategori
    WHERE b.status = 'tersedia'
      AND b.kondisi = 'baik'
      AND cr.status = 'aktif'
    ORDER BY b.nama_sepeda ASC
";

$result = mysqli_query($conn, $query);

if (!$result) {
    die("Gagal mengambil data sepeda: " . mysqli_error($conn));
}
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Form Pemesanan - SaVi Ride</title>
</head>
<body>

    <h1>Form Pemesanan Sepeda</h1>

    <p>Silakan pilih sepeda yang ingin kamu sewa.</p>

    <a href="dashboard.php">Kembali ke Dashboard</a>

    <hr>

    <?php if (mysqli_num_rows($result) > 0): ?>

        <form action="../actions/proses_booking.php" method="POST">

            <label for="id_sepeda">Pilih Sepeda:</label>
            <br>

            <select name="id_sepeda" id="id_sepeda" required>
                <option value="">-- Pilih Sepeda --</option>

                <?php while ($sepeda = mysqli_fetch_assoc($result)): ?>

                    <option value="<?php echo $sepeda['id_sepeda']; ?>">
                        <?php
                        echo htmlspecialchars($sepeda["nama_sepeda"]);
                        echo " - ";
                        echo htmlspecialchars($sepeda["nama_kategori"]);
                        echo " (Rp" . number_format(
                            $sepeda["harga_per_jam"],
                            0,
                            ",",
                            "."
                        ) . "/jam)";
                        ?>
                    </option>

                <?php endwhile; ?>

            </select>

            <br><br>

            <label for="jenis_pengambilan">Jenis Pengambilan:</label>
            <br>

            <select name="jenis_pengambilan" id="jenis_pengambilan" required>
                <option value="">-- Pilih Pengambilan --</option>
                <option value="sekarang">Ambil Sekarang</option>
                <option value="nanti">Ambil Nanti</option>
            </select>

            <br><br>

            <label for="tanggal_pengambilan">Tanggal Pengambilan:</label>
            <br>

            <input
                type="date"
                name="tanggal_pengambilan"
                id="tanggal_pengambilan"
                required
            >

            <br><br>

            <label for="jam_pengambilan">Jam Pengambilan:</label>
            <br>

            <input
                type="time"
                name="jam_pengambilan"
                id="jam_pengambilan"
                required
            >

            <br><br>

            <label for="durasi_jam">Durasi Sewa (Jam):</label>
            <br>

            <input
                type="number"
                name="durasi_jam"
                id="durasi_jam"
                min="1"
                max="15"
                required
            >

            <br><br>

            <button type="submit">Lanjutkan Pemesanan</button>

        </form>

    <?php else: ?>

        <p>Maaf, belum ada sepeda yang tersedia untuk disewa.</p>

    <?php endif; ?>

    <?php mysqli_free_result($result); ?>

</body>
</html>
