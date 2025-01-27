// ignore_for_file: dead_code

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate_admin_panel/routes/routes.dart';

class TRouteMiddleare extends GetMiddleware{

  @override
  RouteSettings? redirect(String? route){
    final isAuthenticated = false;
    return isAuthenticated ? null : const RouteSettings(name: TRoutes.login);
  }
}