import 'package:bytes_machine_test/screens/Home/home_bindings.dart';
import 'package:bytes_machine_test/screens/Home/home_view.dart';
import 'package:get/get.dart';

import '../screens/splash_screen.dart';


class Routes {
  static const splash = '/';
  static const home = '/home';


  static final routes = [
    GetPage(
      name: splash,
      page: () => SplashScreen(),
    ),
    GetPage(
      binding: HomeViewBindings(),
      name: home,
      page: () =>  HomeView(),
    ),

  ];
}
