// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/search_container.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/feature/showroom/screens/home/widgets/home_appbar.dart';
import 'package:tranquilestate/feature/showroom/screens/home/widgets/home_categories.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPrimaryHeaderContainer(
              child: Column(
                children: [
                  const THomeAppBar(),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  TSearchContainer(
                    text: 'Search Property',
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                          title: 'Popular Categories',
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        THomeCategories(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
