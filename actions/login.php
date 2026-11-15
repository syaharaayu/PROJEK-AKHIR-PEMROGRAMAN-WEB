
<?php
session_start();

require_once "../config/database.php";

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    header("Location: ../index.html");
    exit;
}

$email = trim($_POST["email"] ?? "");
$password = $_POST["password"] ?? "";

if ($email === "" || $password === "") {
    die("Email dan password wajib diisi.");
}

// Mencari akun berdasarkan email
$stmt = mysqli_prepare(
    $conn,
    "SELECT id_user, nama, email, password, role, status
     FROM users
     WHERE email = ?
     LIMIT 1"
);

mysqli_stmt_bind_param($stmt, "s", $email);
mysqli_stmt_execute($stmt);

$result = mysqli_stmt_get_result($stmt);
$user = mysqli_fetch_assoc($result);

mysqli_stmt_close($stmt);

// Memeriksa akun dan password
if (!$user || !password_verify($password, $user["password"])) {
    die("Email atau password salah.");
}

if ($user["status"] !== "aktif") {
    die("Akun sedang tidak aktif.");
}

// Menyimpan informasi login ke session
session_regenerate_id(true);

$_SESSION["id_user"] = $user["id_user"];
$_SESSION["nama"] = $user["nama"];
$_SESSION["email"] = $user["email"];
$_SESSION["role"] = $user["role"];

// Mengarahkan pengguna berdasarkan peran
if ($user["role"] === "admin") {
    header("Location: ../admin/dashboard.php");
} elseif ($user["role"] === "karyawan") {
    header("Location: ../karyawan/dashboard.php");
} else {
    header("Location: ../penyewa/dashboard.php");
}

exit;
?>
