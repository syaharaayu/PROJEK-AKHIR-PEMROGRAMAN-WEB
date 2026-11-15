
<?php
session_start();

// Menghapus seluruh data session
$_SESSION = [];

// Menghapus session
session_destroy();

// Kembali ke halaman utama
header("Location: ../index.html");
exit;
?>
