
<?php
require_once "../includes/auth.php";

// Pastikan hanya penyewa yang bisa membuka halaman ini
wajibRole("penyewa");

// Ambil data penyewa dari session
$nama = $_SESSION["nama"];
$email = $_SESSION["email"];
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Penyewa - SaVi Ride</title>
</head>
<body>

    <h1>Selamat Datang, <?php echo htmlspecialchars($nama); ?>!</h1>

    <p>Anda berhasil login sebagai penyewa SaVi Ride.</p>

    <p>Email: <?php echo htmlspecialchars($email); ?></p>

    <hr>

    <h2>Menu Penyewa</h2>

    <ul>
        <li><a href="../index.html">Lihat Beranda</a></li>
        <li><a href="daftar_sepeda.php">Lihat Sepeda</a></li>
        <li><a href="#">Riwayat Penyewaan</a></li>
        <li><a href="#">Profil Saya</a></li>
    </ul>

    <a href="../actions/logout.php">Logout</a>

</body>
</html>
