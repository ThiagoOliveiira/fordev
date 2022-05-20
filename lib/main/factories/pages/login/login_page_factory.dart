import 'package:flutter/material.dart';
import 'package:fordev/main/factories/factories.dart';
import 'package:get/get.dart';

import '../../../../ui/pages/pages.dart';

Widget makeLoginPage() {
  final presenter = Get.put<LoginPresenter>(makeGetxLoginPresenter());
  return LoginPage(presenter);
}
