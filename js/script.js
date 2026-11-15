
// Mengambil semua tombol Pilih Sepeda
const tombolSepeda = document.querySelectorAll(".bike-card .btn-primary");

// Memberikan fungsi pada setiap tombol
tombolSepeda.forEach(function(tombol) {

    tombol.addEventListener("click", function(event) {

        // Mencegah halaman berpindah ke atas
        event.preventDefault();

        // Mengambil nama sepeda dari kartu
        const kartu = tombol.closest(".bike-card");
        const namaSepeda = kartu.querySelector("h3").textContent;

        // Menampilkan informasi sepeda yang dipilih
        alert("Kamu memilih " + namaSepeda + ". Fitur pemesanan akan segera tersedia!");
    });

});
