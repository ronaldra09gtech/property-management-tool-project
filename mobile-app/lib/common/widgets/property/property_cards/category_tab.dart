import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/layouts/grid_layout.dart';
import 'package:tranquilestate/common/widgets/property/property_cards/property_card_vertical.dart';
import 'package:tranquilestate/common/widgets/property/property_cards/property_showcase.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';


class TCategoryTab extends StatelessWidget {
  const TCategoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              TPropertyShowcase(
                images: [TImages.productImage2, TImages.productImage1, TImages.productImage3],
              ),
              TSectionHeading(title: 'You might like', onPressed: (){},),
              const SizedBox(height: TSizes.spaceBtwItems,),
              TGridLayout(itemCount: 4, itemBuilder: (_, index ) => TPropertyCardVartical())
            ],
          ),
      ),
    ],
    );
  }
}
