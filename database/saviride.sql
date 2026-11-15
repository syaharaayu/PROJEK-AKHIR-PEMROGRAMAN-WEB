-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 15 Nov 2026 pada 12.28
-- Versi server: 10.4.32-MariaDB
-- Versi PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_saviride`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `accessories`
--

CREATE TABLE `accessories` (
  `id_aksesori` int(11) NOT NULL,
  `nama_aksesori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga_sewa` decimal(12,2) NOT NULL DEFAULT 0.00,
  `stok` int(11) NOT NULL DEFAULT 0,
  `stok_tersedia` int(11) NOT NULL DEFAULT 0,
  `status` enum('tersedia','habis','nonaktif') DEFAULT 'tersedia',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `accessories`
--

INSERT INTO `accessories` (`id_aksesori`, `nama_aksesori`, `deskripsi`, `harga_sewa`, `stok`, `stok_tersedia`, `status`, `created_at`) VALUES
(1, 'Helm', 'Helm keselamatan untuk penyewa', 5000.00, 10, 10, 'tersedia', '2026-11-15 11:06:38'),
(2, 'Kunci Sepeda', 'Kunci pengaman sepeda', 2000.00, 10, 10, 'tersedia', '2026-11-15 11:06:38');

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity_logs`
--

CREATE TABLE `activity_logs` (
  `id_log` int(11) NOT NULL,
  `id_user` int(11) DEFAULT NULL,
  `aktivitas` varchar(255) NOT NULL,
  `detail` text DEFAULT NULL,
  `waktu_aktivitas` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `bikes`
--

CREATE TABLE `bikes` (
  `id_sepeda` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `kode_sepeda` varchar(30) NOT NULL,
  `nama_sepeda` varchar(100) NOT NULL,
  `merek` varchar(100) DEFAULT NULL,
  `kondisi` enum('baik','perawatan','rusak') DEFAULT 'baik',
  `status` enum('tersedia','disewa','nonaktif') DEFAULT 'tersedia',
  `foto` varchar(255) DEFAULT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bikes`
--

INSERT INTO `bikes` (`id_sepeda`, `id_kategori`, `kode_sepeda`, `nama_sepeda`, `merek`, `kondisi`, `status`, `foto`, `deskripsi`, `created_at`) VALUES
(1, 1, 'SG001', 'Sepeda Gunung 1', 'Polygon', 'baik', 'tersedia', NULL, 'Sepeda gunung untuk perjalanan dan medan menantang.', '2026-11-15 11:05:24'),
(2, 1, 'SG002', 'Sepeda Gunung 2', 'United', 'baik', 'tersedia', NULL, 'Sepeda gunung yang nyaman digunakan.', '2026-11-15 11:05:24'),
(3, 2, 'SL001', 'Sepeda Lipat 1', 'Pacific', 'baik', 'tersedia', NULL, 'Sepeda lipat praktis untuk berkeliling kota.', '2026-11-15 11:05:24'),
(4, 2, 'SL002', 'Sepeda Lipat 2', 'Polygon', 'baik', 'tersedia', NULL, 'Sepeda lipat ringan dan mudah dibawa.', '2026-11-15 11:05:24'),
(5, 3, 'SE001', 'Sepeda Listrik 1', 'Uwinfly', 'baik', 'tersedia', NULL, 'Sepeda listrik untuk perjalanan santai.', '2026-11-15 11:05:24'),
(6, 3, 'SE002', 'Sepeda Listrik 2', 'Selis', 'baik', 'tersedia', NULL, 'Sepeda listrik dengan tenaga baterai.', '2026-11-15 11:05:24');

-- --------------------------------------------------------

--
-- Struktur dari tabel `bike_categories`
--

CREATE TABLE `bike_categories` (
  `id_kategori` int(11) NOT NULL,
  `nama_kategori` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `bike_categories`
--

INSERT INTO `bike_categories` (`id_kategori`, `nama_kategori`, `deskripsi`, `created_at`) VALUES
(1, 'Sepeda Gunung', 'Sepeda untuk penggunaan di berbagai medan.', '2026-11-15 10:26:36'),
(2, 'Sepeda Lipat', 'Sepeda praktis untuk penggunaan sehari-hari.', '2026-11-15 10:26:36'),
(3, 'Sepeda Listrik', 'Sepeda dengan bantuan tenaga listrik.', '2026-11-15 10:26:36');

-- --------------------------------------------------------

--
-- Struktur dari tabel `bookings`
--

CREATE TABLE `bookings` (
  `id_booking` int(11) NOT NULL,
  `kode_booking` varchar(30) NOT NULL,
  `id_user` int(11) NOT NULL,
  `tanggal_pesan` timestamp NOT NULL DEFAULT current_timestamp(),
  `batas_pembayaran` datetime DEFAULT NULL,
  `waktu_mulai` datetime NOT NULL,
  `waktu_selesai` datetime NOT NULL,
  `jenis_pengambilan` enum('sekarang','nanti') NOT NULL,
  `total_harga` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_deposit` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('menunggu_pembayaran','dikonfirmasi','berlangsung','selesai','dibatalkan') DEFAULT 'menunggu_pembayaran'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `booking_accessories`
--

CREATE TABLE `booking_accessories` (
  `id_booking_accessory` int(11) NOT NULL,
  `id_booking_item` int(11) NOT NULL,
  `id_aksesori` int(11) NOT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga_satuan` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `booking_consents`
--

CREATE TABLE `booking_consents` (
  `id_consent` int(11) NOT NULL,
  `id_booking` int(11) NOT NULL,
  `id_terms` int(11) NOT NULL,
  `disetujui` tinyint(1) NOT NULL DEFAULT 1,
  `waktu_persetujuan` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `booking_items`
--

CREATE TABLE `booking_items` (
  `id_booking_item` int(11) NOT NULL,
  `id_booking` int(11) NOT NULL,
  `id_sepeda` int(11) NOT NULL,
  `durasi_jam` int(11) NOT NULL,
  `harga_sewa` decimal(12,2) NOT NULL,
  `subtotal` decimal(12,2) NOT NULL,
  `deposit` decimal(12,2) NOT NULL DEFAULT 0.00,
  `waktu_mulai_aktual` datetime DEFAULT NULL,
  `waktu_selesai_aktual` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `category_rates`
--

CREATE TABLE `category_rates` (
  `id_tarif` int(11) NOT NULL,
  `id_kategori` int(11) NOT NULL,
  `harga_per_jam` decimal(12,2) NOT NULL,
  `jumlah_deposit` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('aktif','tidak_aktif') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `category_rates`
--

INSERT INTO `category_rates` (`id_tarif`, `id_kategori`, `harga_per_jam`, `jumlah_deposit`, `status`, `created_at`) VALUES
(1, 1, 10000.00, 50000.00, 'aktif', '2026-11-15 10:27:02'),
(2, 2, 8000.00, 40000.00, 'aktif', '2026-11-15 10:27:02'),
(3, 3, 15000.00, 75000.00, 'aktif', '2026-11-15 10:27:02');

-- --------------------------------------------------------

--
-- Struktur dari tabel `closed_dates`
--

CREATE TABLE `closed_dates` (
  `id_libur` int(11) NOT NULL,
  `tanggal` date NOT NULL,
  `alasan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `customers`
--

CREATE TABLE `customers` (
  `id_customer` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `alamat` text DEFAULT NULL,
  `tanggal_lahir` date DEFAULT NULL,
  `jenis_kelamin` enum('laki-laki','perempuan') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `customers`
--

INSERT INTO `customers` (`id_customer`, `id_user`, `alamat`, `tanggal_lahir`, `jenis_kelamin`, `created_at`) VALUES
(1, 1, NULL, NULL, NULL, '2026-11-15 11:14:56');

-- --------------------------------------------------------

--
-- Struktur dari tabel `deposits`
--

CREATE TABLE `deposits` (
  `id_deposit` int(11) NOT NULL,
  `id_booking_item` int(11) NOT NULL,
  `jumlah_deposit` decimal(12,2) NOT NULL,
  `jumlah_dikembalikan` decimal(12,2) NOT NULL DEFAULT 0.00,
  `status` enum('menunggu','ditahan','dikembalikan','dipotong') DEFAULT 'menunggu',
  `tanggal_pembayaran` datetime DEFAULT NULL,
  `tanggal_pengembalian` datetime DEFAULT NULL,
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `digital_signatures`
--

CREATE TABLE `digital_signatures` (
  `id_signature` int(11) NOT NULL,
  `id_booking` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `jenis_penanda_tangan` enum('penyewa','karyawan') NOT NULL DEFAULT 'penyewa',
  `file_tanda_tangan` varchar(255) NOT NULL,
  `waktu_tanda_tangan` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `employees`
--

CREATE TABLE `employees` (
  `id_employee` int(11) NOT NULL,
  `id_user` int(11) NOT NULL,
  `jabatan` varchar(100) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `tanggal_mulai_kerja` date DEFAULT NULL,
  `status_kerja` enum('aktif','nonaktif') DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `fines`
--

CREATE TABLE `fines` (
  `id_denda` int(11) NOT NULL,
  `id_return` int(11) NOT NULL,
  `jenis_denda` enum('keterlambatan','kerusakan','kehilangan','lainnya') NOT NULL,
  `jumlah_denda` decimal(12,2) NOT NULL,
  `keterangan` text DEFAULT NULL,
  `status_pembayaran` enum('belum_dibayar','sudah_dibayar','dipotong_deposit') DEFAULT 'belum_dibayar',
  `tanggal_pembayaran` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `operating_hours`
--

CREATE TABLE `operating_hours` (
  `id_jam` int(11) NOT NULL,
  `hari` enum('senin','selasa','rabu','kamis','jumat','sabtu','minggu') NOT NULL,
  `jam_buka` time NOT NULL,
  `jam_tutup` time NOT NULL,
  `status_buka` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `operating_hours`
--

INSERT INTO `operating_hours` (`id_jam`, `hari`, `jam_buka`, `jam_tutup`, `status_buka`) VALUES
(1, 'senin', '08:00:00', '21:00:00', 1),
(2, 'selasa', '08:00:00', '21:00:00', 1),
(3, 'rabu', '08:00:00', '21:00:00', 1),
(4, 'kamis', '08:00:00', '21:00:00', 1),
(5, 'jumat', '08:00:00', '21:00:00', 1),
(6, 'sabtu', '08:00:00', '21:00:00', 1),
(7, 'minggu', '08:00:00', '21:00:00', 1);

-- --------------------------------------------------------

--
-- Struktur dari tabel `payments`
--

CREATE TABLE `payments` (
  `id_payment` int(11) NOT NULL,
  `id_booking` int(11) NOT NULL,
  `metode_pembayaran` enum('tunai','transfer','qris') NOT NULL,
  `kode_referensi` varchar(100) DEFAULT NULL,
  `jumlah_bayar` decimal(12,2) NOT NULL,
  `tanggal_bayar` datetime DEFAULT NULL,
  `status` enum('menunggu','berhasil','gagal') DEFAULT 'menunggu',
  `bukti_pembayaran` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `refunds`
--

CREATE TABLE `refunds` (
  `id_refund` int(11) NOT NULL,
  `id_deposit` int(11) NOT NULL,
  `jumlah_refund` decimal(12,2) NOT NULL,
  `tanggal_refund` datetime DEFAULT NULL,
  `metode_refund` enum('tunai','transfer','lainnya') NOT NULL,
  `kode_referensi` varchar(100) DEFAULT NULL,
  `status` enum('menunggu','berhasil','gagal') DEFAULT 'menunggu',
  `keterangan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `rental_handovers`
--

CREATE TABLE `rental_handovers` (
  `id_handover` int(11) NOT NULL,
  `id_booking_item` int(11) NOT NULL,
  `id_karyawan` int(11) NOT NULL,
  `waktu_penyerahan` datetime NOT NULL,
  `verifikasi_identitas` tinyint(1) DEFAULT 0,
  `catatan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `rental_settings`
--

CREATE TABLE `rental_settings` (
  `id_setting` int(11) NOT NULL,
  `nama_setting` varchar(100) NOT NULL,
  `nilai_setting` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `rental_settings`
--

INSERT INTO `rental_settings` (`id_setting`, `nama_setting`, `nilai_setting`, `deskripsi`, `updated_at`) VALUES
(1, 'maksimal_durasi_sewa', '15', 'Maksimal durasi penyewaan dalam jam', '2026-11-15 11:06:28'),
(2, 'maksimal_pemesanan_awal', '7', 'Maksimal pemesanan sebelum tanggal pengambilan dalam hari', '2026-11-15 11:06:28'),
(3, 'batas_pembayaran', '60', 'Batas waktu pembayaran booking dalam menit', '2026-11-15 11:06:28'),
(4, 'maksimal_item_booking', '10', 'Maksimal jumlah sepeda dalam satu booking', '2026-11-15 11:06:28'),
(5, 'zona_waktu', 'Asia/Jakarta', 'Zona waktu operasional sistem', '2026-11-15 11:06:28'),
(6, 'mata_uang', 'IDR', 'Mata uang yang digunakan sistem', '2026-11-15 11:06:28');

-- --------------------------------------------------------

--
-- Struktur dari tabel `returns`
--

CREATE TABLE `returns` (
  `id_return` int(11) NOT NULL,
  `id_booking_item` int(11) NOT NULL,
  `id_karyawan` int(11) DEFAULT NULL,
  `waktu_pengembalian` datetime DEFAULT NULL,
  `kondisi_sepeda` enum('baik','rusak','perlu_perawatan') DEFAULT 'baik',
  `keterlambatan_jam` int(11) DEFAULT 0,
  `catatan` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `terms_versions`
--

CREATE TABLE `terms_versions` (
  `id_terms` int(11) NOT NULL,
  `versi` varchar(20) NOT NULL,
  `isi_ketentuan` text NOT NULL,
  `status` enum('aktif','tidak_aktif') DEFAULT 'aktif',
  `tanggal_dibuat` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id_user` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `no_hp` varchar(20) DEFAULT NULL,
  `role` enum('penyewa','karyawan','admin') NOT NULL DEFAULT 'penyewa',
  `status` enum('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id_user`, `nama`, `email`, `password`, `no_hp`, `role`, `status`, `created_at`) VALUES
(1, 'sayu', 'syahara@gmail.com', '$2y$10$qiuAoFPzhIIlzScZdpVTCuHvRGo6hk/5yhyLaICos48QKUvQT4Nry', '123456789', 'penyewa', 'aktif', '2026-11-15 11:14:56');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `accessories`
--
ALTER TABLE `accessories`
  ADD PRIMARY KEY (`id_aksesori`);

--
-- Indeks untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`id_log`),
  ADD KEY `fk_activity_logs_user` (`id_user`);

--
-- Indeks untuk tabel `bikes`
--
ALTER TABLE `bikes`
  ADD PRIMARY KEY (`id_sepeda`),
  ADD UNIQUE KEY `kode_sepeda` (`kode_sepeda`),
  ADD KEY `fk_bikes_category` (`id_kategori`);

--
-- Indeks untuk tabel `bike_categories`
--
ALTER TABLE `bike_categories`
  ADD PRIMARY KEY (`id_kategori`);

--
-- Indeks untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id_booking`),
  ADD UNIQUE KEY `kode_booking` (`kode_booking`),
  ADD KEY `fk_bookings_user` (`id_user`);

--
-- Indeks untuk tabel `booking_accessories`
--
ALTER TABLE `booking_accessories`
  ADD PRIMARY KEY (`id_booking_accessory`),
  ADD KEY `fk_booking_accessories_item` (`id_booking_item`),
  ADD KEY `fk_booking_accessories_accessory` (`id_aksesori`);

--
-- Indeks untuk tabel `booking_consents`
--
ALTER TABLE `booking_consents`
  ADD PRIMARY KEY (`id_consent`),
  ADD UNIQUE KEY `id_booking` (`id_booking`),
  ADD KEY `fk_consents_terms` (`id_terms`);

--
-- Indeks untuk tabel `booking_items`
--
ALTER TABLE `booking_items`
  ADD PRIMARY KEY (`id_booking_item`),
  ADD KEY `fk_booking_items_booking` (`id_booking`),
  ADD KEY `fk_booking_items_bike` (`id_sepeda`);

--
-- Indeks untuk tabel `category_rates`
--
ALTER TABLE `category_rates`
  ADD PRIMARY KEY (`id_tarif`),
  ADD KEY `fk_category_rates_category` (`id_kategori`);

--
-- Indeks untuk tabel `closed_dates`
--
ALTER TABLE `closed_dates`
  ADD PRIMARY KEY (`id_libur`),
  ADD UNIQUE KEY `tanggal` (`tanggal`);

--
-- Indeks untuk tabel `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`id_customer`),
  ADD UNIQUE KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `deposits`
--
ALTER TABLE `deposits`
  ADD PRIMARY KEY (`id_deposit`),
  ADD KEY `fk_deposits_booking_item` (`id_booking_item`);

--
-- Indeks untuk tabel `digital_signatures`
--
ALTER TABLE `digital_signatures`
  ADD PRIMARY KEY (`id_signature`),
  ADD KEY `fk_signatures_booking` (`id_booking`),
  ADD KEY `fk_signatures_user` (`id_user`);

--
-- Indeks untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id_employee`),
  ADD UNIQUE KEY `id_user` (`id_user`);

--
-- Indeks untuk tabel `fines`
--
ALTER TABLE `fines`
  ADD PRIMARY KEY (`id_denda`),
  ADD KEY `fk_fines_return` (`id_return`);

--
-- Indeks untuk tabel `operating_hours`
--
ALTER TABLE `operating_hours`
  ADD PRIMARY KEY (`id_jam`),
  ADD UNIQUE KEY `hari` (`hari`);

--
-- Indeks untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`id_payment`),
  ADD KEY `fk_payments_booking` (`id_booking`);

--
-- Indeks untuk tabel `refunds`
--
ALTER TABLE `refunds`
  ADD PRIMARY KEY (`id_refund`),
  ADD KEY `fk_refunds_deposit` (`id_deposit`);

--
-- Indeks untuk tabel `rental_handovers`
--
ALTER TABLE `rental_handovers`
  ADD PRIMARY KEY (`id_handover`),
  ADD UNIQUE KEY `id_booking_item` (`id_booking_item`),
  ADD KEY `fk_handovers_employee` (`id_karyawan`);

--
-- Indeks untuk tabel `rental_settings`
--
ALTER TABLE `rental_settings`
  ADD PRIMARY KEY (`id_setting`),
  ADD UNIQUE KEY `nama_setting` (`nama_setting`);

--
-- Indeks untuk tabel `returns`
--
ALTER TABLE `returns`
  ADD PRIMARY KEY (`id_return`),
  ADD UNIQUE KEY `id_booking_item` (`id_booking_item`),
  ADD KEY `fk_returns_employee` (`id_karyawan`);

--
-- Indeks untuk tabel `terms_versions`
--
ALTER TABLE `terms_versions`
  ADD PRIMARY KEY (`id_terms`),
  ADD UNIQUE KEY `versi` (`versi`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id_user`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `accessories`
--
ALTER TABLE `accessories`
  MODIFY `id_aksesori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `id_log` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `bikes`
--
ALTER TABLE `bikes`
  MODIFY `id_sepeda` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `bike_categories`
--
ALTER TABLE `bike_categories`
  MODIFY `id_kategori` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id_booking` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `booking_accessories`
--
ALTER TABLE `booking_accessories`
  MODIFY `id_booking_accessory` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `booking_consents`
--
ALTER TABLE `booking_consents`
  MODIFY `id_consent` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `booking_items`
--
ALTER TABLE `booking_items`
  MODIFY `id_booking_item` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `category_rates`
--
ALTER TABLE `category_rates`
  MODIFY `id_tarif` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT untuk tabel `closed_dates`
--
ALTER TABLE `closed_dates`
  MODIFY `id_libur` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `customers`
--
ALTER TABLE `customers`
  MODIFY `id_customer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `deposits`
--
ALTER TABLE `deposits`
  MODIFY `id_deposit` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `digital_signatures`
--
ALTER TABLE `digital_signatures`
  MODIFY `id_signature` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `employees`
--
ALTER TABLE `employees`
  MODIFY `id_employee` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `fines`
--
ALTER TABLE `fines`
  MODIFY `id_denda` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `operating_hours`
--
ALTER TABLE `operating_hours`
  MODIFY `id_jam` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT untuk tabel `payments`
--
ALTER TABLE `payments`
  MODIFY `id_payment` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `refunds`
--
ALTER TABLE `refunds`
  MODIFY `id_refund` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `rental_handovers`
--
ALTER TABLE `rental_handovers`
  MODIFY `id_handover` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `rental_settings`
--
ALTER TABLE `rental_settings`
  MODIFY `id_setting` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT untuk tabel `returns`
--
ALTER TABLE `returns`
  MODIFY `id_return` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `terms_versions`
--
ALTER TABLE `terms_versions`
  MODIFY `id_terms` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id_user` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `bikes`
--
ALTER TABLE `bikes`
  ADD CONSTRAINT `fk_bikes_category` FOREIGN KEY (`id_kategori`) REFERENCES `bike_categories` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `fk_bookings_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `booking_accessories`
--
ALTER TABLE `booking_accessories`
  ADD CONSTRAINT `fk_booking_accessories_accessory` FOREIGN KEY (`id_aksesori`) REFERENCES `accessories` (`id_aksesori`),
  ADD CONSTRAINT `fk_booking_accessories_item` FOREIGN KEY (`id_booking_item`) REFERENCES `booking_items` (`id_booking_item`);

--
-- Ketidakleluasaan untuk tabel `booking_consents`
--
ALTER TABLE `booking_consents`
  ADD CONSTRAINT `fk_consents_booking` FOREIGN KEY (`id_booking`) REFERENCES `bookings` (`id_booking`),
  ADD CONSTRAINT `fk_consents_terms` FOREIGN KEY (`id_terms`) REFERENCES `terms_versions` (`id_terms`);

--
-- Ketidakleluasaan untuk tabel `booking_items`
--
ALTER TABLE `booking_items`
  ADD CONSTRAINT `fk_booking_items_bike` FOREIGN KEY (`id_sepeda`) REFERENCES `bikes` (`id_sepeda`),
  ADD CONSTRAINT `fk_booking_items_booking` FOREIGN KEY (`id_booking`) REFERENCES `bookings` (`id_booking`);

--
-- Ketidakleluasaan untuk tabel `category_rates`
--
ALTER TABLE `category_rates`
  ADD CONSTRAINT `fk_category_rates_category` FOREIGN KEY (`id_kategori`) REFERENCES `bike_categories` (`id_kategori`);

--
-- Ketidakleluasaan untuk tabel `customers`
--
ALTER TABLE `customers`
  ADD CONSTRAINT `fk_customers_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `deposits`
--
ALTER TABLE `deposits`
  ADD CONSTRAINT `fk_deposits_booking_item` FOREIGN KEY (`id_booking_item`) REFERENCES `booking_items` (`id_booking_item`);

--
-- Ketidakleluasaan untuk tabel `digital_signatures`
--
ALTER TABLE `digital_signatures`
  ADD CONSTRAINT `fk_signatures_booking` FOREIGN KEY (`id_booking`) REFERENCES `bookings` (`id_booking`),
  ADD CONSTRAINT `fk_signatures_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `employees`
--
ALTER TABLE `employees`
  ADD CONSTRAINT `fk_employees_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `fines`
--
ALTER TABLE `fines`
  ADD CONSTRAINT `fk_fines_return` FOREIGN KEY (`id_return`) REFERENCES `returns` (`id_return`);

--
-- Ketidakleluasaan untuk tabel `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `fk_payments_booking` FOREIGN KEY (`id_booking`) REFERENCES `bookings` (`id_booking`);

--
-- Ketidakleluasaan untuk tabel `refunds`
--
ALTER TABLE `refunds`
  ADD CONSTRAINT `fk_refunds_deposit` FOREIGN KEY (`id_deposit`) REFERENCES `deposits` (`id_deposit`);

--
-- Ketidakleluasaan untuk tabel `rental_handovers`
--
ALTER TABLE `rental_handovers`
  ADD CONSTRAINT `fk_handovers_booking_item` FOREIGN KEY (`id_booking_item`) REFERENCES `booking_items` (`id_booking_item`),
  ADD CONSTRAINT `fk_handovers_employee` FOREIGN KEY (`id_karyawan`) REFERENCES `users` (`id_user`);

--
-- Ketidakleluasaan untuk tabel `returns`
--
ALTER TABLE `returns`
  ADD CONSTRAINT `fk_returns_booking_item` FOREIGN KEY (`id_booking_item`) REFERENCES `booking_items` (`id_booking_item`),
  ADD CONSTRAINT `fk_returns_employee` FOREIGN KEY (`id_karyawan`) REFERENCES `users` (`id_user`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
