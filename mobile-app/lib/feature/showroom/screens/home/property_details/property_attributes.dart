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
                      title: 'Description',
                      showActionButton: false,
                    ),
                    SizedBox(
                      width: TSizes.spaceBtwItems,
                    ),
                  ],
                ),
                TPropertyTitleText(
                  title:
                      "A house tour is a guided or self-guided visit to a house, where visitors can learn about the house's history, design, and residents. House tours can take place in homes, estates, and historic buildings",
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
              label: const Text('Schedule for Viewing'
                  ''),
              selected: false,
              onSelected: (value) {},
            ),
            SizedBox(width: TSizes.spaceBtwItems),
            ChoiceChip(
              label: const Text('Rent'),
              selected: false,
              onSelected: (value) {},
            )
          ],
        )
      ],
    );
  }
}
