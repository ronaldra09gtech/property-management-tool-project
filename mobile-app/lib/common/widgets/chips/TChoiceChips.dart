// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:tranquilestate/utils/constants/colors.dart';

class TChoiceChips extends StatelessWidget {
  const TChoiceChips(
      {super.key, required this.text, required this.selected, this.onSelected});

  final String text;
  final bool selected;
  final void Function(bool)? onSelected;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(text),
      selected: selected,
      onSelected: onSelected,
      labelStyle: TextStyle(color: selected ? TColors.white : null),
    );
  }
}
