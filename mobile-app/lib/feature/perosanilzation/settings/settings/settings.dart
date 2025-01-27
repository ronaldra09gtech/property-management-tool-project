import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tranquilestate/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/feature/perosanilzation/screens/profile/widgets/profile.dart';
import 'package:tranquilestate/feature/perosanilzation/settings/profile/user_profile.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:
        Column(
          children: [
            TPrimaryHeaderContainer(
                child: Column(
                  children: [
                   TAppBar(title: Text('Account',
                    style: Theme.of(context).textTheme.headlineMedium!.apply(color: TColors.white))),
                    TUserProfile(onPressed: () => Get.to(() => const ProfileScreen())),
                    const SizedBox(height: TSizes.spaceBtwSections,)
                  ],
                ),
            ),
              Padding(
                padding: EdgeInsets.all(TSizes.defaultSpace),
                child: Column(
                children: [
                  TSectionHeading(title: 'Account Settings' ,showActionButton: false),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TUserListTile(icon: Iconsax.safe_home, title: 'My Address', subTitle: '', onTap: (){}),
                  TUserListTile(icon: Iconsax.bill, title: 'Bills', subTitle: 'Check for Bills ', onTap: (){}),
                  TUserListTile(icon: Iconsax.bank, title: 'Bank Aaccount', subTitle: 'Withdraw balance to register bank account', onTap: (){}),
                  TUserListTile(icon: Iconsax.notification, title: 'Notification', subTitle: 'Set any kind of notification messages', onTap: (){}),
                  TUserListTile(icon: Iconsax.security_card, title: 'Account Privacy', subTitle: '', onTap: (){}),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(title: 'App Settings' ,showActionButton: false),
                  TUserListTile(icon: Iconsax.call, title: 'Contact Support', subTitle: 'Helps you with any abnormalities in the app ', onTap: (){}),
                  SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(width: double.infinity,
                  child: OutlinedButton(onPressed: (){}, child: const Text('Logout')),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections * 2.5)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
