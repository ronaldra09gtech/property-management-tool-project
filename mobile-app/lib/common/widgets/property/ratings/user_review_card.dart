import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:tranquilestate/common/widgets/property/ratings/rating_indicator.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';


class TUserReview extends StatelessWidget {
  const TUserReview({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      children: [
       Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Row(
             children: [
               const CircleAvatar(backgroundImage: AssetImage(TImages.userProfileImage2)),
               const SizedBox(width: TSizes.spaceBtwItems),
               Text('John Doe', style: Theme.of(context).textTheme.titleLarge)
             ],
           ),
           IconButton(onPressed: (){}, icon: Icon(Icons.more_vert))
         ],
       ),
        const SizedBox(width: TSizes.spaceBtwItems,),
        Row(
          children: [
            TRatingIndicator(rating: 4),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text('01 Nov, 2024', style: Theme.of(context).textTheme.bodyMedium,)
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        ReadMoreText('The user interface of this app is quite intuitive. I was able to navigate and make transaction seamlessly. Great Job!',
          trimLines: 2,
          trimMode: TrimMode.Line,
          trimExpandedText: 'show less',
          trimCollapsedText: 'show more',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
          lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        TRoundedContainer(
          backgroundColor: dark ? TColors.darkGrey : TColors.grey,
          child: Padding(
            padding: EdgeInsets.all(TSizes.md),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Robinson Land Corp.',style: Theme.of(context).textTheme.bodyLarge),
                    Text('03 Nov, 2024', style: Theme.of(context).textTheme.bodyMedium,),
                  ],
                ),
                SizedBox( height: TSizes.spaceBtwItems,),
                ReadMoreText('The user interface of this app is quite intuitive. I was able to navigate and make transaction seamlessly. Great Job!',
                  trimLines: 2,
                  trimMode: TrimMode.Line,
                  trimExpandedText: 'show less',
                  trimCollapsedText: 'show more',
                  moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                  lessStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: TColors.primary),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TSizes.spaceBtwSections),
      ],
    );
  }
}
