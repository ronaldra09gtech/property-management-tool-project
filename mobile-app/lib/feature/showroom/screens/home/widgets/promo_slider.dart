import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:tranquilestate/common/widgets/t_rounded_image.dart';
import 'package:tranquilestate/feature/showroom/controller/home_controller.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';

class TPromoSlider extends StatelessWidget {
  const TPromoSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
              viewportFraction: 1,
              onPageChanged: (index, _) =>
                  controller.updatePageIndicator(index)),
          items: [
            TRoundedImage(imageUrl: TImages.promoBanner1),
            TRoundedImage(imageUrl: TImages.promoBanner2),
            TRoundedImage(imageUrl: TImages.promoBanner3),
          ],
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        Center(
          child: Obx(
            () => Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 3; i++)
                  TCircularContainer(
                    width: 20,
                    height: 4,
                    margin: const EdgeInsets.only(right: 10),
                    backgroundColor: controller.carousalCurrentIndex.value == i
                        ? TColors.primary
                        : TColors.grey,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
