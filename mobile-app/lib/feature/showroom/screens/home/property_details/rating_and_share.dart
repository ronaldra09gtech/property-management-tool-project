import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/feature/showroom/screens/property_reviews/property_reviews.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';



class TRatingAndShare extends StatelessWidget {
  const TRatingAndShare({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            IconButton(icon: Icon(Iconsax.star5 , size: 28,), color: Colors.amber, onPressed: () => Get.to(() => const TPropertyReviewScreen())),
            const SizedBox(width: TSizes.spaceBtwItems / 2),
            Text.rich(
                TextSpan(
                    children:[
                      TextSpan( text: '4.9', style: Theme.of(context).textTheme.bodyLarge),
                      const TextSpan(text: ' (24)'),
                    ]
                )
            )
          ],
        ),
        IconButton(onPressed: (){}, icon: const Icon(Icons.share, size: TSizes.iconMd,))
      ],
    );
  }
}