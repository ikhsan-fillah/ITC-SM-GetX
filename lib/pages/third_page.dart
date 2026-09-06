import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThirdPage extends StatelessWidget {
  ThirdPage({super.key});

  //ambil data yang dikirim dari halaman sebelumnya
  final int nilai = Get.arguments as int;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Nilai yang dikirim dari halaman kedua:'),
          Text(
            '$nilai',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: () => Get.back(),
            child: const Text('Kembali'),
          ),
        ],
      ),
    );
  }
}
