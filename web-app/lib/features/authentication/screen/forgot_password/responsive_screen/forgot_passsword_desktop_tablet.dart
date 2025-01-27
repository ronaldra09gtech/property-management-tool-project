import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate_admin_panel/common/widgets/layouts/templates/login_template.dart';
import 'package:tranquilestate_admin_panel/utils/constants/sizes.dart';
import 'package:tranquilestate_admin_panel/utils/constants/text_strings.dart';

class ForgotPassswordScreenDesktopTablet extends StatelessWidget {
  const ForgotPassswordScreenDesktopTablet({super.key});

  @override
  Widget build(BuildContext context) {
    return TLoginTemplate(
      child: Column(
        children: [
          IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Iconsax.arrow_left)),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            TTexts.forgetPasswordTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            TTexts.forgetPasswordSubTitle,
            style: Theme.of(context).textTheme.labelMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwSections * 2),
        ],
      ),
    );
  }
}
