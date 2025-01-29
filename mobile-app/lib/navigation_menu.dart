import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/feature/perosanilzation/settings/settings/settings.dart';
import 'package:tranquilestate/feature/showroom/screens/explore/explore_screen.dart';
import 'package:tranquilestate/feature/showroom/screens/home/home.dart';
import 'package:tranquilestate/feature/showroom/screens/wishlist/wish_list.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';


class NavigationMenu extends StatelessWidget {
  const NavigationMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? TColors.black : Colors.white,
          indicatorColor: darkMode
              ? TColors.white.withOpacity(0.1)
              : TColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.home), label: "Home"),
            NavigationDestination(icon: Icon(Iconsax.activity), label: "Explore"),
            NavigationDestination(icon: Icon(Iconsax.heart), label: "Wishlist"),
            NavigationDestination(icon: Icon(Iconsax.user), label: "Account"),
          ],
        ),
      ),
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const ExploreScreen(),
    const FavouriteScreen(),
    const SettingScreen(),
  ];
}
