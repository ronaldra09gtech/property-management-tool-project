import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/images/t_circular_image.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/feature/perosanilzation/settings/profile/widgets/profile_menu.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    const TCircularImage(
                      image: TImages.user,
                      width: 120,
                      height: 120,
                    ),
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
                  onPressed: () {}, title: '名前', value: 'ロナルド・アビラ'),
              ProfileMenu(
                  onPressed: () {}, title: 'ユーザー名', value: 'Ra45645655'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(
                  title: '個人情報', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(onPressed: () {}, title: 'ユーザーID', value: '八千八百七十五万四千百二十一'),
              ProfileMenu(
                  onPressed: () {},
                  title: '電子メール',
                  value: 'ra45645655@gmail.com'),
              ProfileMenu(
                  onPressed: () {},
                  title: '電話番号',
                  value: '+63 956-002-8874'),
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
