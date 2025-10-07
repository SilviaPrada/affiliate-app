# 🧩 Affiliate App – Test Programmer Project

Project ini merupakan hasil dari **Tes Programmer (Soal Mobile Apps dan SQL Query)**.
Aplikasi ini dibangun menggunakan **Flutter** untuk frontend dan **Node.js + MySQL** untuk backend.

---

## 📁 Struktur Project

```
AFFILIATE_APP/
│
├── affiliate-backend/        # Backend (Node.js + Express + MySQL)
│   ├── controllers/          # Logic API
│   ├── middleware/           # Middleware (auth, dll)
│   ├── routes/               # Routing API
│   ├── db.js                 # Koneksi database
│   ├── server.js             # File utama server backend
│   ├── package.json
│   └── package-lock.json
│
├── assets/                   # Gambar dan aset Flutter
├── lib/                      # Source code utama Flutter
├── pubspec.yaml              # Konfigurasi dependencies Flutter
├── create_users.sql          # Script SQL untuk membuat tabel users
├── test_tigaraksa.sql        # Jawaban Soal No 1 (Query SQL)
└── README.md                 # Dokumentasi project ini
```

---

## 🧠 Soal dan Hasil Pengerjaan

### 1️⃣ **Soal SQL Query**

* Jawaban dari soal SQL (“Data Member & Data Atasan berdasarkan level GEPD-EPD-EPC”) ada di file:

  ```
  test_tigaraksa.sql
  ```

### 2️⃣ **Soal Mobile Apps**

* Aplikasi Flutter dengan login, form CRUD data, dan fitur reporting (download Excel).
* Backend menggunakan **Node.js (Express)** dan **MySQL** sebagai database.

---

## ⚙️ Tools dan Dependencies

### 🔸 Frontend (Flutter)

Dependencies utama diambil dari `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.5.0
  shared_preferences: ^2.5.3
  flutter_bloc: ^9.1.1
  equatable: ^2.0.7
  cupertino_icons: ^1.0.8
  flutter_custom_clippers: ^2.1.0
  flutter_svg: ^2.2.1
  path_provider: ^2.1.5
  open_filex: ^4.7.0
  permission_handler: ^12.0.1
```

### 🔸 Backend (Node.js)

Package utama yang digunakan:

```json
"dependencies": {
    "bcryptjs": "^2.4.3",
    "body-parser": "^1.20.3",
    "cors": "^2.8.5",
    "exceljs": "^4.4.0",
    "express": "^4.21.2",
    "jsonwebtoken": "^9.0.2",
    "mysql2": "^3.15.1"
  },
```

---

## 🧩 Setting Database

1. Jalankan **MySQL** di `localhost`.
2. Import file SQL berikut ke database Anda:

   * `test_tigaraksa.sql`
   * `create_users.sql`
3. Pastikan nama database sama seperti di konfigurasi berikut:

```js
// affiliate-backend/db.js
import mysql from "mysql2/promise";

const pool = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "",
  database: "test_tigaraksa"
});

export default pool;
```

---

## 🚀 Cara Menjalankan Aplikasi

### 1️⃣ Clone Repository

```bash
git clone https://github.com/username/affiliate_app.git
cd affiliate_app
```

### 2️⃣ Jalankan Backend

```bash
cd affiliate-backend
npm install        # install dependencies
npm start          # menjalankan server backend
```

Server akan berjalan di:

```
http://localhost:5000
```

### 3️⃣ Jalankan Frontend (Flutter)

Buka terminal baru:

```bash
flutter pub get
flutter run
```

---

## 🔐 Akun Login yang Dapat Digunakan

| Role          | Username | Password   | Hak Akses                                                      |
| ------------- | -------- | ---------- | -------------------------------------------------------------- |
| Administrator | admin    | admin123   | Dapat melakukan fungsi **CRUD** (Create, Read, Update, Delete) |
| General User  | johndoe  | johndoe123 | Hanya dapat melihat **report** (read-only)                     |

---

## 🧰 Fitur Aplikasi

### 🔸 **Login System**

* Dibangun dengan **Flutter + Node.js API**.
* Autentikasi berdasarkan role (Admin & General User).
* Menyimpan session login menggunakan **Shared Preferences**.

### 🔸 **CRUD Data (Admin Only)**

* Admin dapat menambahkan, mengedit, dan menghapus data member.
* Data dikirim ke server melalui **HTTP API (Node.js Express)** dan disimpan di **MySQL**.

### 🔸 **Reporting System**

* Menampilkan data dari database dalam bentuk tabel Flutter.
* Dapat diunduh dalam bentuk **Excel (.xlsx)** menggunakan **path_provider + open_filex**.
* Menampilkan data berdasarkan role:

  * Admin dapat melihat seluruh data.
  * General user hanya dapat melihat tanpa mengubah data.

### 🔸 **Responsive UI**

* Menggunakan kombinasi **Material Design + Custom Clipper + SVG Assets**.
* Antarmuka ringan, intuitif, dan mendukung berbagai ukuran layar.

---

## 🧠 Catatan Tambahan

* Pastikan Node.js dan Flutter sudah terinstall.
* Jalankan backend **sebelum** membuka aplikasi Flutter.

---

## 🧾 Informasi Tambahan

* **Jawaban SQL Soal No 1:** `test_tigaraksa.sql`
* **Aplikasi Backend:** `affiliate-backend`
* **Frontend Flutter:** Root folder `affiliate_app`

---
