
<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

// Memeriksa apakah pengguna sudah login
function wajibLogin()
{
    if (!isset($_SESSION["id_user"])) {
        header("Location: ../index.html");
        exit;
    }
}

// Memeriksa hak akses berdasarkan role
function wajibRole($role)
{
    wajibLogin();

    if ($_SESSION["role"] !== $role) {
        die("Akses ditolak. Anda tidak memiliki izin membuka halaman ini.");
    }
}

?>
