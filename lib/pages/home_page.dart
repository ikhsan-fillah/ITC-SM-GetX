import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx/Controllers/counter_controller.dart';
import 'package:getx/routes/app_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //daftarin controller
  final CounterController controller = Get.find<CounterController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Home"), actions: const []),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Nilai Counter'),
          Obx(
            () => Text(
              '${controller.counter.value}',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: controller.decrement,
                child: const Icon(Icons.remove),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: controller.increment,
                child: Icon(Icons.add),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.toNamed(AppRoutes.second),
            child: const Text('Halaman Kedua'),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {
              controller.reset();
              Get.snackbar('Reset', 'Kembali ke 0');
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}
