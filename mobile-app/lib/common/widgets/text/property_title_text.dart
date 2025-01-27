import 'package:flutter/material.dart';

import '../../../utils/constants/enums.dart';

class TPropertyTitleText extends StatelessWidget {
  const TPropertyTitleText(
      {super.key,
      this.color,
      required this.title,
      this.brandTextSize = TextSizes.small,
      this.smallSize = false,
      this.maxLines = 2,
      this.textAlign = TextAlign.center});

  final Color? color;
  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? textAlign;
  final TextSizes brandTextSize;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: brandTextSize == TextSizes.small
          ? Theme.of(context).textTheme.labelMedium!.apply(color: color)
          : brandTextSize == TextSizes.medium
              ? Theme.of(context).textTheme.bodyLarge!.apply(color: color)
              : brandTextSize == TextSizes.large
                  ? Theme.of(context).textTheme.titleLarge!.apply(color: color)
                  : Theme.of(context).textTheme.bodyMedium!.apply(color: color),
    );
  }
}
