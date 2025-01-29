import 'package:flutter/material.dart';
import 'package:tranquilestate/feature/showroom/screens/home/property_details/property_attributes.dart';
import 'package:tranquilestate/feature/showroom/screens/home/property_details/property_details_image_slider.dart';
import 'package:tranquilestate/feature/showroom/screens/home/property_details/property_meta_data.dart';
import 'package:tranquilestate/feature/showroom/screens/home/property_details/rating_and_share.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';


class PropertyDetails extends StatelessWidget {
  const PropertyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            TPropertySlider(),
            Padding(
                padding: EdgeInsets.only(right: TSizes.defaultSpace, left: TSizes.defaultSpace, bottom: TSizes.defaultSpace),
              child: Column(
                children: [
                  TRatingAndShare(),
                  TPropertyMetaData(),
                  SizedBox(height: TSizes.spaceBtwItems),
                  TPropertyAttributes(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


