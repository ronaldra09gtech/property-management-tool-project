import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RouteObserver extends GetObserver {

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    // final sidebarController = Get.put(SidebarController());
    //
    // if (previousRoute ! = null){
    //   for (var routeName in TRoutes.sidebarMenuItems) {
    //     if (previousRoute.settings.name == routeName) {
    //       sidebarController.activeItem.value = routeName;
    //     }
    //   }
    // }
  }

  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? previousRoute) {
    // final sidebarController = Get.put(SidebarController());
    //
    // if(route != null) {
    //   for (var routeName in TRoutes.sideMenuItems) {
    //     if (route.settings.name == routeName) {
    //       sidebarController.activeItem.value = routeName;
    //     }
    //   }
    // }
  }
}