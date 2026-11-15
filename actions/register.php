
<?php
session_start();

require_once "../config/database.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../index.html");
    exit;
}

// Mengambil data dari formulir
$nama = trim($_POST["nama"] ?? "");
$email = trim($_POST["email"] ?? "");
$no_hp = trim($_POST["no_hp"] ?? "");
$password = $_POST["password"] ?? "";
$konfirmasi_password = $_POST["konfirmasi_password"] ?? "";

// Validasi data
if ($nama === "" || $email === "" || $password === "") {
    die("Nama, email, dan password wajib diisi.");
}

if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
    die("Format email tidak valid.");
}

if ($password !== $konfirmasi_password) {
    die("Konfirmasi password tidak sesuai.");
}

if (strlen($password) < 8) {
    die("Password minimal 8 karakter.");
}

// Mengenkripsi password
$password_hash = password_hash($password, PASSWORD_DEFAULT);

// Memulai transaksi database
mysqli_begin_transaction($conn);

try {
    // Memasukkan akun ke tabel users
    $stmt = mysqli_prepare(
        $conn,
        "INSERT INTO users (nama, email, no_hp, password, role)
         VALUES (?, ?, ?, ?, 'penyewa')"
    );

    mysqli_stmt_bind_param(
        $stmt,
        "ssss",
        $nama,
        $email,
        $no_hp,
        $password_hash
    );

    mysqli_stmt_execute($stmt);
    $id_user = mysqli_insert_id($conn);
    mysqli_stmt_close($stmt);

    // Membuat profil pelanggan
    $stmt = mysqli_prepare(
        $conn,
        "INSERT INTO customers (id_user) VALUES (?)"
    );

    mysqli_stmt_bind_param($stmt, "i", $id_user);
    mysqli_stmt_execute($stmt);
    mysqli_stmt_close($stmt);

    mysqli_commit($conn);

    header("Location: ../index.html?registrasi=berhasil");
    exit;

} catch (mysqli_sql_exception $e) {
    mysqli_rollback($conn);

    if ($e->getCode() == 1062) {
        die("Email sudah terdaftar. Silakan gunakan email lain.");
    }

    die("Registrasi gagal. Silakan coba kembali.");
}
?>
