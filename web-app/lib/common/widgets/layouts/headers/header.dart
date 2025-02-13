import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate_admin_panel/common/widgets/images/t_rounded_image.dart';
import 'package:tranquilestate_admin_panel/common/widgets/shimmers/shimmer.dart';
import 'package:tranquilestate_admin_panel/features/authentication/controller/user_controller.dart';
import 'package:tranquilestate_admin_panel/utils/constants/colors.dart';
import 'package:tranquilestate_admin_panel/utils/constants/enums.dart';
import 'package:tranquilestate_admin_panel/utils/constants/image_strings.dart';
import 'package:tranquilestate_admin_panel/utils/constants/sizes.dart';
import 'package:tranquilestate_admin_panel/utils/device/device_utility.dart';

/// Header widget for the application
class THeader extends StatelessWidget implements PreferredSizeWidget {
  const THeader({super.key, this.scaffoldKey});

  /// GlobalKey to access the Scaffold state
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Container(
      decoration: const BoxDecoration(
        color: TColors.white,
        border: Border(bottom: BorderSide(color: TColors.grey, width: 1)),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: TSizes.md, vertical: TSizes.sm),
      child: AppBar(
        /// Mobile Menu
        leading: !TDeviceUtils.isDesktopScreen(context)
            ? IconButton(
                onPressed: () => scaffoldKey?.currentState?.openDrawer(),
                icon: const Icon(Iconsax.menu))
            : null,

        /// Search Field
        title: TDeviceUtils.isDesktopScreen(context)
            ? SizedBox(
                width: 400,
                child: TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.search_normal),
                      hintText: 'Search anything...'),
                ),
              )
            : null,

        /// Actions
        actions: [
          /// Search Icon on Mobile
          if (!TDeviceUtils.isDesktopScreen(context))
            IconButton(
                icon: const Icon(Iconsax.search_normal), onPressed: () {}),

          /// Notification Icon
          IconButton(onPressed: () {}, icon: const Icon(Iconsax.notification)),
          const SizedBox(width: TSizes.spaceBtwItems / 2),

          /// User Data
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Image
              Obx(
                () => TRoundedImage(
                  width: 40,
                  padding: 2,
                  height: 40,
                  imageType: controller.user.value.profilePicture.isNotEmpty
                      ? ImageType.network
                      : ImageType.asset,
                  image: controller.user.value.profilePicture.isNotEmpty
                      ? controller.user.value.profilePicture
                      : TImages.user,
                ),
              ),
              const SizedBox(width: TSizes.sm),

              /// Name and Email
              if (!TDeviceUtils.isMobileScreen(context))
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.loading.value
                        ? const TShimmerEffect(width: 50, height: 13)
                        : Text(controller.user.value.fullName,
                            style: Theme.of(context).textTheme.titleLarge),
                    controller.loading.value
                        ? const TShimmerEffect(width: 50, height: 13)
                        : Text(controller.user.value.email,
                        style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}
