
<?php

if (session_status() === PHP_SESSION_NONE) {
    session_start();
}

function wajibLogin()
{
    if (!isset($_SESSION["id_user"])) {
        header("Location: ../index.html");
        exit;
    }
}

function wajibRole($role)
{
    wajibLogin();

    if ($_SESSION["role"] !== $role) {
        die("Akses ditolak. Anda tidak memiliki izin membuka halaman ini.");
    }
}
