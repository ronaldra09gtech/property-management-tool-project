import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/images/t_circular_image.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/feature/perosanilzation/controller/user_controller.dart';
import 'package:tranquilestate/feature/perosanilzation/screens/profile/widgets/change_name.dart';
import 'package:tranquilestate/feature/perosanilzation/screens/profile/widgets/profile_menu.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/common/widgets/shimmers/shimmer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('プロフィール'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    Obx(() {
                      final networkImage = controller.user.value.profilePicture;
                      final image =
                          networkImage.isNotEmpty ? networkImage : TImages.user;
                      return controller.imageUploading.value
                          ? const TShimmerEffect(
                              width: 80, height: 80, radius: 80)
                          : TCircularImage(
                              image: image,
                              width: 80,
                              height: 80,
                              isNetworkImage: networkImage.isNotEmpty);
                    }),
                    TextButton(
                        onPressed: () {},
                        child: const Text('プロフィール写真の変更')),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: 'プロフィール情報', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(
                  onPressed: () => Get.to(() => const ChangeName()),
                  title: '名前',
                  value: controller.user.value.fullName),
              ProfileMenu(
                  onPressed: () {},
                  title: 'ユーザー名',
                  value: controller.user.value.userName),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: '個人情報', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(
                  onPressed: () {},
                  title: 'ユーザーID',
                  value: controller.user.value.id),
              ProfileMenu(
                  onPressed: () {},
                  title: '電子メール',
                  value: controller.user.value.email),
              ProfileMenu(
                  onPressed: () {},
                  title: '電話番号',
                  value: controller.user.value.phoneNumber),
              ProfileMenu(
                  onPressed: () {},
                  title: '生年月日',
                  value: '1996 年 7 月 10 日'),
            ],
          ),
        ),
      ),
    );
  }
}
