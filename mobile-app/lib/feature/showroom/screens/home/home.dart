// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/search_container.dart';
import 'package:tranquilestate/common/widgets/layouts/grid_layout.dart';
import 'package:tranquilestate/common/widgets/property/property_cards/property_card_vertical.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/feature/showroom/screens/home/widgets/home_appbar.dart';
import 'package:tranquilestate/feature/showroom/screens/home/widgets/home_categories.dart';
import 'package:tranquilestate/feature/showroom/screens/home/widgets/promo_slider.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
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
                  THomeAppBar(),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSearchContainer(
                    text: '物件の検索',
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  Padding(
                    padding: EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        TSectionHeading(
                          title: 'カテゴリ',
                          showActionButton: false,
                          textColor: Colors.white,
                        ),
                        SizedBox(height: TSizes.spaceBtwItems),
                        THomeCategories(),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: TSizes.spaceBtwSections,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  TPromoSlider(
                    banners: [
                      TImages.promoBanner1,
                      TImages.promoBanner2,
                      TImages.promoBanner3
                    ],
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TSectionHeading(
                    title: '人気物件',
                    onPressed: () {},
                  ),
                  SizedBox(height: TSizes.spaceBtwSections),
                  TGridLayout(
                      itemCount: 2,
                      itemBuilder: (_, index) => const TPropertyCardVartical())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
