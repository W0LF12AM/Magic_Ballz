# 🎤 Magic Ball Voice App (Flutter - Speech to Text Learning Project)

Sebuah aplikasi Flutter sederhana yang dikembangkan untuk **belajar implementasi Speech-to-Text** menggunakan plugin `speech_to_text`. Aplikasi ini merupakan lanjutan dari project sederhana seperti "Roll Dice", namun dikembangkan dengan **fitur suara yang lebih advance dan interaktif**.

## 🎯 Tujuan Proyek

- Belajar cara menggunakan `speech_to_text` di Flutter
- Memahami permission handling (akses mikrofon)
- Mengatur alur logika bicara dan hasil teks
- Latihan membuat UI responsif berdasarkan input suara

---

## 🧠 Fitur Utama

- 🎤 Pengenalan suara (voice recognition)
- 🎱 Menjawab pertanyaan secara acak (seperti magic 8-ball)
- 🔐 Minta izin mikrofon otomatis
- 📱 UI sederhana dan ringan

---

## 🧰 Package yang Digunakan

| Package              | Fungsi                              |
|----------------------|--------------------------------------|
| `speech_to_text`     | Mengubah suara menjadi teks          |
| `permission_handler` | Mengelola izin akses mikrofon        |
| `flutter/material`   | Komponen UI dasar dari Flutter       |
| `dart:math`          | Menghasilkan angka acak untuk bola   |

---

## 🛠 Android Permission

Aplikasi ini membutuhkan izin untuk mengakses mikrofon agar fitur **Speech-to-Text** bisa berjalan dengan baik.

### Tambahkan permission berikut di file:
`android/app/src/main/AndroidManifest.xml`

```xml
<!-- Izin akses mikrofon -->
<uses-permission android:name="android.permission.RECORD_AUDIO" />
```

Untuk Android 12 (API level 31) ke atas
Android 12 memperketat aturan akses Bluetooth, jadi jika aplikasi kamu menggunakan perangkat Bluetooth (misal headset), tambahkan permission berikut:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
```

---

### Catatan Penting

> ⚠️ Pastikan juga kamu meminta izin mikrofon secara **runtime** menggunakan package `permission_handler` agar aplikasi tidak crash saat dijalankan di perangkat modern.

> ⚠️ Jika menggunakan emulator, aktifkan mikrofon di setting emulator dan berikan izin yang diminta.
