import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/proeperty_card.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';


class TPropertyShowcase extends StatelessWidget {
  const TPropertyShowcase({
    super.key,
    required this.images,
  });
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return TRoundedContainer(
      showBorder: true,
      borderColor: TColors.darkGrey,
      padding: const EdgeInsets.all(TSizes.md),
      backgroundColor: Colors.transparent,
      margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Column(
        children: [
          const TPropertyCard(
            showBorder: false,
          ),
          Row(children: images.map((image)=> PropertyTopProductImageWidget(image, context)).toList()),
        ],
      ),
    );
  }
  Widget PropertyTopProductImageWidget(String images, context){
    return Expanded(
      child: TRoundedContainer(
        height: 100,
        backgroundColor: THelperFunctions.isDarkMode(context) ? TColors.darkGrey : TColors.light,
        margin: const EdgeInsets.only(right: TSizes.sm),
        child: const Image(fit: BoxFit.contain, image: AssetImage(TImages.interior6),),
      ),
    );
  }
}