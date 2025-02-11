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

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = UserController.instance;
    return Scaffold(
      appBar: TAppBar(
        showBackArrow: true,
        title: Text('Profile'),
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
                    const TCircularImage(
                      image: TImages.user,
                      width: 120,
                      height: 120,
                    ),
                    TextButton(
                        onPressed: () {},
                        child: const Text('Change Profile Picture')),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(
                  onPressed: () => Get.to(() => const ChangeName()), title: 'Name', value: controller.user.value.fullName),
              ProfileMenu(
                  onPressed: () {}, title: 'UserName', value: controller.user.value.userName),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: 'Personal Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(onPressed: () {}, title: 'UserID', value: controller.user.value.id),
              ProfileMenu(
                  onPressed: () {},
                  title: 'E-mail',
                  value: controller.user.value.email),
              ProfileMenu(
                  onPressed: () {},
                  title: 'Phone Number',
                  value: controller.user.value.phoneNumber),
              ProfileMenu(
                  onPressed: () {},
                  title: 'Date of Birth',
                  value: '10 July 1996'),
            ],
          ),
        ),
      ),
    );
  }
}
