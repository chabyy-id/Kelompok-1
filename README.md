# “Aplikasi Absensi Berbasis Selfie dan Lokasi (Flutter + Firebase)” 


Aplikasi Absensi ini adalah aplikasi mobile berbasis **Flutter** yang terintegrasi dengan **Firebase Firestore** sebagai database utama.  
Aplikasi ini dirancang untuk mendukung proses absensi secara **digital, real-time, dan berbasis lokasi**, sehingga lebih aman dan akurat dibandingkan absensi manual.

Aplikasi ini akan ditampilkan beserta **contoh penggunaan langsung (demo aplikasi)** untuk memperlihatkan bagaimana sistem bekerja dari sisi pengguna.

<img width="406" height="849" alt="image" src="https://github.com/user-attachments/assets/b8694242-cf00-494e-863b-1eb7a6f96bae" /> 
<img width="393" height="809" alt="image" src="https://github.com/user-attachments/assets/a4cdcb23-d392-4e13-9a6c-9f61a0148d46" />
<img width="369" height="824" alt="image" src="https://github.com/user-attachments/assets/44fc4de6-d999-459d-a50e-9e42e6565524" />
<img width="377" height="829" alt="image" src="https://github.com/user-attachments/assets/4cb01264-1683-4395-8955-40604a6f0c02" />



---

## 🎯 Latar Belakang
Pada sistem absensi konvensional, sering terjadi:
- Manipulasi data kehadiran
- Ketidaktepatan waktu absensi
- Sulitnya memverifikasi kehadiran secara fisik

Oleh karena itu, aplikasi ini dibuat untuk mengatasi permasalahan tersebut dengan memanfaatkan:
- Kamera (selfie)
- GPS (lokasi)
- Cloud Database (Firebase Firestore)

---

## 🚀 Fitur Utama dan Penjelasan

### 📸 1. Absensi dengan Foto Selfie
Pada saat melakukan absensi, pengguna **wajib mengambil foto selfie** melalui kamera aplikasi.

**Tujuan fitur ini:**
- Memastikan absensi dilakukan oleh orang yang bersangkutan
- Mengurangi kemungkinan titip absen
- Menjadi bukti visual kehadiran

📌 *Pada demo aplikasi, akan ditampilkan proses pengambilan foto langsung dari kamera.*

---

### 📍 2. Validasi Lokasi Kampus
Aplikasi melakukan pengecekan lokasi menggunakan **GPS perangkat**.

**Ketentuan:**
- Absensi hanya dapat dilakukan **jika pengguna berada di area kampus**
- Jika pengguna berada di luar lokasi kampus, maka akan muncul pesan:
  
> *"Anda tidak berada di lokasi absensi"*

📌 *Pada demo aplikasi, akan ditampilkan perbedaan hasil saat berada di dalam dan di luar area kampus.*

---

### 📝 3. Pengajuan Izin dan Sakit
Jika pengguna tidak dapat hadir secara langsung, maka tersedia fitur **izin dan sakit**.

**Ketentuan:**
- Izin dan sakit **boleh diajukan dari luar kampus**
- Data tetap tersimpan di Firebase Firestore
- Memiliki keterangan status yang berbeda dengan absensi hadir

📌 *Pada demo aplikasi, akan diperlihatkan proses pengajuan izin/sakit.*

---

### 📊 4. Riwayat Absensi
Aplikasi menyediakan halaman **riwayat absensi** yang menampilkan seluruh data absensi pengguna.

**Informasi yang ditampilkan:**
- Nama pengguna
- Alamat / lokasi absensi
- Status absensi (Hadir / Telat / Izin / Sakit)
- Waktu absensi

Data ini diambil langsung dari **Firebase Firestore** sehingga selalu **real-time**.

📌 *Pada demo aplikasi, akan ditampilkan contoh data yang sudah tersimpan.*

---

## 🔄 Alur Kerja Aplikasi (Flow Aplikasi)

1. Pengguna membuka aplikasi
2. Memilih menu **Absensi / Izin / Sakit**
3. Sistem meminta akses:
   - Kamera
   - Lokasi GPS
4. Sistem melakukan validasi:
   - Lokasi (khusus absensi hadir)
   - Input data pengguna
5. Data disimpan ke **Firebase Firestore**
6. Data dapat dilihat kembali pada menu **Riwayat Absensi**

---

## 🛠️ Teknologi yang Digunakan

- **Flutter** → Framework UI
- **Dart** → Bahasa pemrograman
- **Firebase Firestore** → Database NoSQL
- **Firebase Storage** → Penyimpanan foto selfie
- **Geolocator & Geocoding** → Validasi lokasi
- **Camera Plugin** → Pengambilan foto

---

## 📂 Struktur Project
lib/
├── main.dart
├── page/
│ ├── absen/
│ │ ├── absen_page.dart
│ │ └── camera_page.dart
│ ├── history/
│ │ └── history_page.dart
│ └── izin/
│ └── izin_page.dart


---

## 📌 Catatan Penggunaan
- Absensi **hanya bisa dilakukan di lokasi kampus**
- Izin dan sakit **tidak memerlukan lokasi kampus**
- Semua data tersimpan di Firebase Firestore secara cloud
- Aplikasi membutuhkan izin kamera dan lokasi

---

## 👩‍💻 Pengembang
Dikembangkan oleh **Kelompok 1**  
Sebagai project UAS mata kuliah **Pengembangan Aplikasi Mobile** 

---


