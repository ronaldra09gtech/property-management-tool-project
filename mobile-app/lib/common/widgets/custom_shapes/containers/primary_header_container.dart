// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/curved_edges/curved_edges_widgets.dart';
import 'package:tranquilestate/utils/constants/colors.dart';

class TPrimaryHeaderContainer extends StatelessWidget {
  const TPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TCurvedEdgeWidget(
      child: Container(
        color: TColors.primary,
        padding: const EdgeInsets.all(0),
        child: SizedBox(
          height: 400,
          child: Stack(
            children: [
              Positioned(
                top: -150,
                right: -250,
                child: TCircularContainer(
                    backgroundColor: TColors.textWhite.withOpacity(
                        0.1)),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: TCircularContainer(
                    backgroundColor: TColors.textWhite.withOpacity(
                        0.1)),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}