# ITC-SM-GetX — Tutorial State Management dengan GetX

Aplikasi counter multi-halaman sederhana untuk belajar GetX: state management reaktif, routing, dan dependency injection. Dibuat sebagai materi praktikum — fokusnya bukan pada UI, tapi pada cara kerja GetX.

Setelah mengikuti repo ini, kamu akan paham:

- Variabel reaktif `.obs` dan widget `Obx()`
- Controller (`GetxController`) sebagai tempat state dan logika
- Dependency injection: `Get.lazyPut()` lewat Binding + `Get.find()`
- Navigasi named routes: `Get.toNamed()` dan `Get.back()`
- Pengiriman data antar halaman: `arguments` dan `Get.arguments`
- Snackbar tanpa context: `Get.snackbar()`

## Struktur Project

```
lib/
 ├─ main.dart                    ← gerbang utama: GetMaterialApp
 ├─ Controllers/
 │   └─ counter_controller.dart ← otak: state & logika
 ├─ bindings/
 │   └─ home_binding.dart        ← pendaftar controller untuk route home
 ├─ pages/
 │   ├─ home_page.dart           ← counter + tombol navigasi
 │   ├─ second_page.dart         ← counter yang sama, tetap sinkron
 │   └─ third_page.dart          ← menerima Get.arguments
 └─ routes/
     ├─ app_routes.dart          ← daftar nama halaman
     └─ app_pages.dart           ← penyambung: nama ↔ halaman ↔ binding
```

## Cara Menjalankan

```bash
git clone https://github.com/ikhsan-fillah/ITC-SM-GetX.git
cd ITC-SM-GetX
flutter pub get
flutter run
```

## Langkah Membangun dari Awal

Urutan pengerjaannya dari dalam ke luar: otak dulu, baru alamat, baru wajah, baru penyambung. Setiap step hanya butuh step sebelumnya, jadi tidak ada momen error aneh di tengah jalan.

### Step 1 — Siapkan Project

```bash
flutter create getx
cd getx
flutter pub add get
```

### Step 2 — Buat Otaknya: `Controllers/counter_controller.dart`

Semua state dan logika ditulis di sini, belum ada UI sama sekali. Semua halaman nanti tinggal meminta dari sini.

```dart
import 'package:get/get.dart';

class CounterController extends GetxController {
  // state: variabel reaktif
  final RxInt counter = 0.obs;

  // logika: method untuk mengubah state
  void increment() => counter.value++;
  void decrement() => counter.value--;
  void reset() => counter.value = 0;
}
```

### Step 3 — Buat Alamat Halaman: `routes/app_routes.dart`

Tombol-tombol di halaman akan menulis `Get.toNamed(AppRoutes.second)`, jadi nama-nama halaman harus ada dulu.

```dart
abstract class AppRoutes {
  static const String home = '/home';
  static const String second = '/second';
  static const String third = '/third';
}
```

### Step 4 — Buat Wajahnya: Tiga Halaman di `pages/`

**HomePage** — ambil controller dengan `Get.find()`, tampilkan counter dengan `Obx()`, dan pindah halaman tanpa context:

```dart
// ambil controller yang didaftarkan binding
final CounterController controller = Get.find<CounterController>();

// UI-nya otomatis berubah saat counter berubah — tanpa setState
Obx(() => Text('${controller.counter.value}',
    style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold))),

// pindah halaman
onPressed: () => Get.toNamed(AppRoutes.second),

// reset + notifikasi tanpa context
onPressed: () {
  controller.reset();
  Get.snackbar('Reset', 'Kembali ke 0');
},
```

**SecondPage** — memakai controller yang sama (bukan membuat baru), jadi counter-nya selalu sinkron dengan Home:

```dart
final CounterController controller = Get.find<CounterController>();

// kirim data ke halaman ketiga
onPressed: () => Get.toNamed(AppRoutes.third,
    arguments: controller.counter.value),

// kembali
onPressed: () => Get.back(),
```

**ThirdPage** — menerima kiriman lewat `Get.arguments`:

```dart
final int nilai = Get.arguments as int;
```

### Step 5 — Siapkan Kebutuhan Home: `bindings/home_binding.dart`

Satu tugas kecil: mendaftarkan resep pembuatan controller, dijalankan otomatis oleh GetX sebelum halaman home dibuka.

```dart
import 'package:get/get.dart';
import 'package:getx/Controllers/counter_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterController>(() => CounterController());
  }
}
```

### Step 6 — Rakit Semuanya: `routes/app_pages.dart`

File penyambung: setiap `GetPage` menghubungkan nama alamat, halaman, dan binding.

```dart
import 'package:get/get.dart';
import 'package:getx/bindings/home_binding.dart';
import 'package:getx/pages/home_page.dart';
import 'package:getx/pages/second_page.dart';
import 'package:getx/pages/third_page.dart';
import 'package:getx/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(name: AppRoutes.home, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: AppRoutes.second, page: () => SecondPage()),
    GetPage(name: AppRoutes.third, page: () => ThirdPage()),
  ];
}
```

### Step 7 — Nyalakan: `main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/routes/app_pages.dart';
import 'package:getx/routes/app_routes.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.home,
      getPages: AppPages.routes,
    );
  }
}
```

### Step 8 — Jalankan dan Tes

```bash
flutter run
```

Yang perlu dites:

1. Counter naik-turun tanpa `setState` sama sekali
2. Tambah counter dari halaman kedua, kembali ke Home — nilainya tetap sinkron
3. Halaman ketiga menampilkan nilai yang dikirim dari halaman kedua

## Eksperimen Lanjutan

Coba dua ini biar makin paham:

1. **Hapus `binding: HomeBinding()` di `app_pages.dart`**, lalu hot restart — aplikasi error `CounterController not found`. Buktinya HomePage tidak pernah mendaftarkan apa pun, ia hanya meminta.
2. **Ganti `Get.find` di SecondPage menjadi `Get.put(CounterController())`** — sekarang ada dua controller berbeda, dan counter di kedua halaman tidak lagi sinkron. Inilah inti state management: satu state bersama, banyak pemakai.

> Prinsip yang perlu diingat: kita bangun aplikasi dari data ke tampilan — UI itu pemakai data, bukan pemiliknya.
