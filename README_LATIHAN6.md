# Latihan Praktikum Mandiri — Jawaban Nomor 6

Perubahan yang diterapkan pada projek `snack_distro` sesuai instruksi soal:

## 1. Gambar dari URL → Asset Lokal
- `pubspec.yaml`: ditambahkan blok `assets: - assets/images/`.
- `dummy_snack.dart`: nilai `imageUrl` diganti dari link `unsplash.com`
  menjadi path lokal, contoh `assets/images/keripik_kaca_pedas.jpg`.
- `snack_card.dart`: `Image.network(...)` diganti `Image.asset(...)`
  (dipakai di kartu grid maupun di dalam dialog detail).
- Kamu perlu menaruh file gambar aslinya di `assets/images/` — lihat
  `assets/images/README.txt` untuk daftar nama file yang dipakai.

## 2. Tema Warna Hijau Fresh UMKM
- `app_colors.dart`: `primary`, `primaryLight`, dan `priceColor`
  diganti ke nuansa hijau (`0xFF4CAF50`, `0xFF8BC34A`, `0xFF2E7D32`).
  Karena `AppBar` dan `CatalogScreen` sudah mereferensikan
  `AppColors.primary`, seluruh tampilan otomatis ikut berubah tanpa
  perlu menyentuh file lain.

## 3. Pop-up Detail Produk (Modal Dialog)
- `snack_card.dart`: `Card` dibungkus `InkWell` (`onTap`) dan
  ditambahkan method `_showDetailDialog()` yang memanggil
  `showDialog()` → `AlertDialog` berisi gambar besar, deskripsi,
  harga, dan tombol **Tutup** — sesuai tampilan pada gambar acuan soal.

## Struktur file yang disertakan
```
lib/
├── core/
│   ├── constants/app_colors.dart      (diubah)
│   └── utils/currency_formatter.dart  (tidak berubah)
├── data/
│   ├── datasources/dummy_snack.dart   (diubah)
│   └── models/snack_model.dart        (tidak berubah)
├── presentation/
│   ├── screens/catalog_screen.dart    (tidak berubah)
│   └── widgets/snack_card.dart        (diubah — inti Latihan 6)
└── main.dart                          (tidak berubah)
pubspec.yaml                            (diubah — tambah assets)
assets/images/README.txt                (panduan nama file gambar)
```

Tinggal salin folder `lib/` dan `assets/` ini menimpa folder yang sama
di projek `snack_distro` kamu, tambahkan file gambarnya, lalu jalankan
`flutter pub get` dan restart aplikasi.
