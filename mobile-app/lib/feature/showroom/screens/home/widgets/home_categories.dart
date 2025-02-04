import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/image_text_widgets/vertical_image_text.dart';
import 'package:tranquilestate/utils/constants/image_strings.dart';

class THomeCategories extends StatelessWidget {
  const THomeCategories({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 4,
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) {
          return TVerticalImageText(
            image: TImages.residential,
            title: '家',
            onTap: () {},
          );
        },
      ),
    );
  }
}
