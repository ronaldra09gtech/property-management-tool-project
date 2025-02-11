import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/feature/perosanilzation/controller/user_controller.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/text_strings.dart';
import 'package:tranquilestate/utils/loaders/shimmer.dart';

class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(UserController());
    return TAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(TTexts.homeAppbarTitle,
              style: Theme
                  .of(context)
                  .textTheme
                  .labelMedium!
                  .apply(color: TColors.grey)),
          Obx(
                  () {
                if (controller.profileLoading.value) {
                  return const TShimmerEffect(width: 80, height: 15);
                } else {
                  return Text(controller.user.value.fullName,
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineSmall!
                          .apply(color: TColors.white));
                }
              }
          ),
        ],
      ),
    );
  }
}
