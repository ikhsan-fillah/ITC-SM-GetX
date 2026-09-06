import 'package:get/get.dart';

class CounterController extends GetxController {
  //state: variabel reaktif
  final RxInt counter = 0.obs;

  //logika: method untuk mengubah state
  void increment() => counter.value++;
  void decrement() => counter.value--;
  void reset() => counter.value = 0;
}
