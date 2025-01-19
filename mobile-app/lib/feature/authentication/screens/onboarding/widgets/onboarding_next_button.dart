import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/feature/authentication/controllers/onboarding/onboarding_controller.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/device/device_utility.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Positioned(
      right: TSizes.defaultSpace,
      bottom: TDeviceUtils.getBottomNavigationBarHeight(),
      child: ElevatedButton(
        onPressed: () => OnBoardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(shape:CircleBorder(), backgroundColor: dark ? TColors.primary : Colors.black ),
        child: const Icon(Iconsax.arrow_right_3),
      ),
    );
  }
}