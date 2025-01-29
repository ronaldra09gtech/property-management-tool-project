// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';

class TPropertyPriceText extends StatelessWidget {
  const TPropertyPriceText({
    super.key,
    required this.price,
    this.currencySign = '\¥',
    this.isLarge = false,
    this.maxLines = 1,
    this.lineThrough = false,

  });

  final String currencySign ,price;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
      currencySign + price,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
        ? Theme.of(context).textTheme.headlineMedium!.apply(decoration: lineThrough ? TextDecoration.lineThrough: null)
        : Theme.of(context).textTheme.titleLarge!.apply(decoration: lineThrough ? TextDecoration.lineThrough: null),
    );
  }
}
