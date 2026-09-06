import 'package:get/get.dart';
import 'package:getx/Controllers/counter_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CounterController>(() => CounterController());
  }
}
