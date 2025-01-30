// ignore_for_file: deprecated_member_use, unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:tranquilestate/common/widgets/text/property_title_text.dart';
import 'package:tranquilestate/common/widgets/text/tproperty_with_verification_icon.dart';
import 'package:tranquilestate/feature/showroom/screens/home/property_details/property_price_text.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';

class TPropertyMetaData extends StatelessWidget {
  const TPropertyMetaData({super.key});

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            TRoundedContainer(
              radius: TSizes.sm,
              backgroundColor: TColors.secondary.withOpacity(0.8),
              padding: const EdgeInsets.symmetric(
                  horizontal: TSizes.sm, vertical: TSizes.xs),
              child: Text('10%',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge!
                      .apply(color: TColors.black)),
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              '\¥10,000,000',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall!
                  .apply(decoration: TextDecoration.lineThrough),
            ),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            const TPropertyPriceText(price: '9,000,000', isLarge: true)
          ],
        ),
        const SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),
        const TPropertyTitleText(title: 'Pent House'),
        const SizedBox(
          height: TSizes.spaceBtwItems / 1.5,
        ),
        const TPropertyWithVerificationIcon(title: 'Robinson Land Corp.'),
        Row(
          children: [
            const TPropertyTitleText(title: 'Status'),
            const SizedBox(
              width: TSizes.spaceBtwItems,
            ),
            Text(
              'Available',
              style: Theme.of(context).textTheme.titleSmall,
            )
          ],
        ),
      ],
    );
  }
}
