import 'package:get/get.dart';
import 'package:getx/bindings/home_binding.dart';
import 'package:getx/pages/home_page.dart';
import 'package:getx/pages/second_page.dart';
import 'package:getx/pages/third_page.dart';
import 'package:getx/routes/app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(name: AppRoutes.second, page: () => SecondPage()),
    GetPage(name: AppRoutes.third, page: () => ThirdPage()),
  ];
}
