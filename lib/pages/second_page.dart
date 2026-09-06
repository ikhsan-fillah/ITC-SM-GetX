import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Controllers/counter_controller.dart';
import 'package:getx/routes/app_routes.dart';

class SecondPage extends StatelessWidget {
  SecondPage({super.key});

  //ambil controller yang sama tapi tidak membuat data
  final CounterController controller = Get.find<CounterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Dashboard"), actions: const []),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('ambil value counter'),
            Obx(
              () => Text(
                '${controller.counter.value}',
                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.increment,
              child: const Text('Tambah dari sini'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Kembali'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.toNamed(
                AppRoutes.third,
                arguments: controller.counter.value,
              ),
              child: const Text('Kirim Nilai ke Halaman Ketiga'),
            ),
          ],
        ),
      ),
    );
  }
}
