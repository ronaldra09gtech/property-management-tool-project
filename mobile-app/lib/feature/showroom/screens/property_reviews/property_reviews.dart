import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/property/ratings/rating_indicator.dart';
import 'package:tranquilestate/common/widgets/property/ratings/user_review_card.dart';
import 'package:tranquilestate/feature/showroom/screens/home/property_details/overall_property_rating.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';

class TPropertyReviewScreen extends StatelessWidget {
  const TPropertyReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TAppBar(
        title: Text('レビューと評価'),
        showBackArrow: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  "評価とレビューは検証され、あなたが使用するのと同じ種類のアドバイスを使用する人々からのものです。"),
              SizedBox(height: TSizes.spaceBtwItems),
              const TOverAllPropertyRating(),
              TRatingIndicator(rating: 4.9),
              Text(
                '24',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: TSizes.spaceBtwSections),
              TUserReview(),
              TUserReview()
            ],
          ),
        ),
      ),
    );
  }
}
