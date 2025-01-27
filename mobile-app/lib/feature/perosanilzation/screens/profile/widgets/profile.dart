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
                      const TCircularImage(image: TImages.user, width: 120, height: 120,),
                      TextButton(onPressed: (){}, child: const Text('Change Profile Picture')),
                    ],
                  ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems / 2),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Profile Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(onPressed: (){}, title: 'Name', value: 'Ronald Avila'),
              ProfileMenu(onPressed: (){}, title: 'UserName', value: 'Ra45645655'),
              const SizedBox(height: TSizes.spaceBtwItems),
              const Divider(),
              const SizedBox(height: TSizes.spaceBtwItems),
              const TSectionHeading(title: 'Personal Information', showActionButton: false),
              const SizedBox(height: TSizes.spaceBtwItems),
              ProfileMenu(onPressed: (){}, title: 'UserID', value: '88754121'),
              ProfileMenu(onPressed: (){}, title: 'E-mail', value: 'Ra45645655@gmail.com'),
              ProfileMenu(onPressed: (){}, title: 'Phone Number', value: '+63 956-002-8874'),
              ProfileMenu(onPressed: (){}, title: 'Date of Birth', value: '10 July 1996'),



            ],
          ),
        ),
      ),
    );
  }
}
