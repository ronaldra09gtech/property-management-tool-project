import 'package:flutter/material.dart';
import 'package:tranquilestate/utils/constants/colors.dart';



class TShadowStyle {
 
  static final verticalPropertyShadow =  BoxShadow(
    color: TColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
  
  static final horizontalPropertyShadow = BoxShadow(
    color: TColors.darkGrey.withOpacity(0.1),
    blurRadius: 50,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );

  
}
