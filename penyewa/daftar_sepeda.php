
<?php
require_once "../includes/auth.php";
wajibRole("penyewa");

require_once "../config/database.php";

// Mengambil data sepeda beserta kategori, tarif, dan deposit
$query = "
    SELECT
        b.id_sepeda,
        b.kode_sepeda,
        b.nama_sepeda,
        b.merek,
        b.kondisi,
        b.status,
        b.foto,
        b.deskripsi,
        bc.nama_kategori,
        cr.harga_per_jam,
        cr.jumlah_deposit
    FROM bikes b
    INNER JOIN bike_categories bc
        ON b.id_kategori = bc.id_kategori
    LEFT JOIN category_rates cr
        ON b.id_kategori = cr.id_kategori
        AND cr.status = 'aktif'
    ORDER BY b.id_sepeda ASC
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
    <title>Daftar Sepeda - SaVi Ride</title>
</head>
<body>

    <h1>Daftar Sepeda SaVi Ride</h1>

    <p>Berikut daftar sepeda yang tersedia untuk disewa.</p>

    <a href="dashboard.php">Kembali ke Dashboard</a>

    <hr>

    <?php if (mysqli_num_rows($result) > 0): ?>

        <?php while ($sepeda = mysqli_fetch_assoc($result)): ?>

            <div>
                <h3>
                    <?php echo htmlspecialchars($sepeda["nama_sepeda"]); ?>
                </h3>

                <p>
                    Kode:
                    <?php echo htmlspecialchars($sepeda["kode_sepeda"]); ?>
                </p>

                <p>
                    Kategori:
                    <?php echo htmlspecialchars($sepeda["nama_kategori"]); ?>
                </p>

                <p>
                    Merek:
                    <?php echo htmlspecialchars($sepeda["merek"] ?? "-"); ?>
                </p>

                <p>
                    Kondisi:
                    <?php echo htmlspecialchars($sepeda["kondisi"]); ?>
                </p>

                <p>
                    Status:
                    <?php echo htmlspecialchars($sepeda["status"]); ?>
                </p>

                <p>
                    Harga sewa:
                    <?php
                    echo $sepeda["harga_per_jam"] !== null
                        ? "Rp" . number_format((float)$sepeda["harga_per_jam"], 0, ",", ".") . "/jam"
                        : "Tarif belum tersedia";
                    ?>
                </p>

                <p>
                    Deposit:
                    <?php
                    echo $sepeda["jumlah_deposit"] !== null
                        ? "Rp" . number_format((float)$sepeda["jumlah_deposit"], 0, ",", ".")
                        : "Deposit belum tersedia";
                    ?>
                </p>

                <p>
                    <?php echo htmlspecialchars($sepeda["deskripsi"] ?? "-"); ?>
                </p>

                <hr>
            </div>

        <?php endwhile; ?>

    <?php else: ?>

        <p>Belum ada data sepeda.</p>

    <?php endif; ?>

    <?php mysqli_free_result($result); ?>

</body>
</html>
