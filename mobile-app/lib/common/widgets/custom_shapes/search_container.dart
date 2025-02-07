import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/device/device_utility.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';

class TSearchContainer extends StatelessWidget {
  const TSearchContainer(
      {super.key,
      required this.text,
      this.icon = Iconsax.search_normal,
      this.showBackground = true,
      this.showborder = true,
      this.onTap,
      this.padding =
          const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace)});

  final String text;
  final IconData? icon;
  final bool showBackground, showborder;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Container(
          width: TDeviceUtils.getScreenWidth(context),
          padding: const EdgeInsets.all(TSizes.md),
          decoration: BoxDecoration(
              color: showBackground
                  ? dark
                      ? TColors.dark
                      : TColors.light
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
              border: showborder ? Border.all(color: TColors.grey) : null),
          child: Row(
            children: [
              Icon(
                icon,
                color: TColors.grey,
              ),
              const SizedBox(width: TSizes.spaceBtwItems),
              Text(
                text,
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
        ),
      ),
    );
  }
}
