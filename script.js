
// SaVi Ride - JavaScript

document.addEventListener("DOMContentLoaded", function () {

    // 1. Smooth Scrolling Navigasi
    const navigationLinks = document.querySelectorAll(
        'nav a, .btn-login, .btn-primary[href^="#"]'
    );

    navigationLinks.forEach(function (link) {
        link.addEventListener("click", function (event) {
            const targetId = this.getAttribute("href");

            if (targetId && targetId.startsWith("#") && targetId.length > 1) {
                const target = document.querySelector(targetId);

                if (target) {
                    event.preventDefault();
                    target.scrollIntoView({
                        behavior: "smooth",
                        block: "start"
                    });
                }
            }
        });
    });

    // 2. Memilih Sepeda
    const bikeButtons = document.querySelectorAll(".bike-card .btn-primary");

    bikeButtons.forEach(function (button) {
        button.addEventListener("click", function (event) {
            event.preventDefault();

            const bikeCard = this.closest(".bike-card");
            const bikeName = bikeCard.querySelector("h3").textContent;
            const bikePrice = bikeCard.querySelector("h4").textContent;

            // Menyimpan pilihan sepeda sementara
            const selectedBike = {
                nama: bikeName,
                harga: bikePrice
            };

            localStorage.setItem(
                "selectedBike",
                JSON.stringify(selectedBike)
            );

            alert(
                "Kamu memilih " + bikeName +
                "\nHarga: " + bikePrice +
                "\n\nPilihan sepeda berhasil disimpan!"
            );
        });
    });

    // 3. Menampilkan Pesan Selamat Datang
    console.log("SaVi Ride berhasil dijalankan!");
    console.log("JavaScript berhasil terhubung dengan HTML.");

});
