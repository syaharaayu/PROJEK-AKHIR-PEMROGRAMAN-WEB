
<?php
require_once "config/database.php";
?>

<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <title>Test Registrasi SaVi Ride</title>
</head>
<body>

    <h2>Form Registrasi SaVi Ride</h2>

    <form action="actions/register.php" method="POST">

        <label>Nama Lengkap</label><br>
        <input type="text" name="nama" required>
        <br><br>

        <label>Email</label><br>
        <input type="email" name="email" required>
        <br><br>

        <label>Nomor HP</label><br>
        <input type="text" name="no_hp">
        <br><br>

        <label>Password</label><br>
        <input type="password" name="password" required>
        <br><br>

        <label>Konfirmasi Password</label><br>
        <input type="password" name="konfirmasi_password" required>
        <br><br>

        <button type="submit">Daftar</button>

    </form>

</body>
</html>
