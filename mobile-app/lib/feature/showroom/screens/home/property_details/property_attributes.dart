import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:tranquilestate/common/widgets/text/property_title_text.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';

class TPropertyAttributes extends StatelessWidget {
  const TPropertyAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
        TRoundedContainer(
            padding: const EdgeInsets.all(TSizes.md),
            backgroundColor: dark ? TColors.darkGrey : TColors.grey,
            child: Column(
              children: [
                Row(
                  children: [
                    TSectionHeading(
                      title: '説明',
                      showActionButton: false,
                    ),
                    SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                  ],
                ),
                TPropertyTitleText(
                  title:
                      "ハウス ツアーとは、ガイド付きまたはセルフガイドで住宅を訪問することで、訪問者はその家の歴史、デザイン、居住者について学ぶことができます。ハウスツアーは住宅、不動産、歴史的建造物で開催できます",
                  smallSize: true,
                  maxLines: 10,
                )
              ],
            )),
        SizedBox(height: TSizes.spaceBtwItems),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ChoiceChip(
              label: const Text('観覧スケジュール'
                  ''),
              selected: false,
              onSelected: (value) {},
            ),
            SizedBox(width: TSizes.spaceBtwItems),
            ChoiceChip(
              label: const Text('家賃'),
              selected: false,
              onSelected: (value) {},
            )
          ],
        )
      ],
    );
  }
}
