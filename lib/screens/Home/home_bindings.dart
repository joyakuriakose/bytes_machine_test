import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';
import 'home_controller.dart';

class HomeViewBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeViewController>(
          () => HomeViewController(),
    );
  }
}