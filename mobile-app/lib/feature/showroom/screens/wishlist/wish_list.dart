import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/icons/t_circular_icon.dart';
import 'package:tranquilestate/common/widgets/layouts/grid_layout.dart';
import 'package:tranquilestate/common/widgets/property/property_cards/property_card_vertical.dart';
import 'package:tranquilestate/feature/showroom/screens/home/home.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text(
          'お気に入り',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: [
          TCircularIcon(
              icon: Iconsax.add, onPressed: () => Get.to(const HomeScreen())),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TGridLayout(
                  itemCount: 6,
                  itemBuilder: (_, index) => TPropertyCardVartical())
            ],
          ),
        ),
      ),
    );
  }
}
