import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tranquilestate/common/widgets/list_tiles/user_profile_tile.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/feature/authentication/screens/login/login.dart';
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
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  TAppBar(
                      title: Text('アカウント',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .apply(color: TColors.white))),
                  TUserProfile(
                      onPressed: () => Get.to(() => const ProfileScreen())),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TSectionHeading(
                      title: 'アカウント設定', showActionButton: false),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TUserListTile(
                      icon: Iconsax.safe_home,
                      title: '私の住所',
                      subTitle: '',
                      onTap: () {}),
                  TUserListTile(
                      icon: Iconsax.bill,
                      title: '請求書',
                      subTitle: '請求書を確認する',
                      onTap: () {}),
                  TUserListTile(
                      icon: Iconsax.bank,
                      title: '銀行口座',
                      subTitle: '残高を引き出して銀行口座を登録する',
                      onTap: () {}),
                  TUserListTile(
                      icon: Iconsax.notification,
                      title: '通知',
                      subTitle: 'あらゆる種類の通知メッセージを設定します',
                      onTap: () {}),
                  TUserListTile(
                      icon: Iconsax.security_card,
                      title: 'アカウントのプライバシー',
                      subTitle: '',
                      onTap: () {}),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                      title: 'アプリの設定', showActionButton: false),
                  TUserListTile(
                      icon: Iconsax.call,
                      title: 'サポートに連絡する',
                      subTitle: 'アプリの異常を解決します',
                      onTap: () {}),
                  SizedBox(height: TSizes.spaceBtwSections),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                        onPressed: () => Get.to(() => const LoginScreen()),
                        child: const Text('ログアウト')),
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
