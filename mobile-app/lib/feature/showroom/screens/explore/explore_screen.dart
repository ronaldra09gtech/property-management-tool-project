// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tranquilestate/common/widgets/appbar/appbar.dart';
import 'package:tranquilestate/common/widgets/appbar/tabbar.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/containers/proeperty_card.dart';
import 'package:tranquilestate/common/widgets/custom_shapes/search_container.dart';
import 'package:tranquilestate/common/widgets/layouts/grid_layout.dart';
import 'package:tranquilestate/common/widgets/property/property_cards/category_tab.dart';
import 'package:tranquilestate/common/widgets/text/section_heading.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/helpers/helper_functions.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: TAppBar(
          title: Text(
            '探検する',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: NestedScrollView(
          headerSliverBuilder: (_, innerBoxISScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: THelperFunctions.isDarkMode(context)
                    ? TColors.black
                    : TColors.white,
                expandedHeight: 440,
                flexibleSpace: Padding(
                  padding: EdgeInsets.all(TSizes.defaultSpace),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        height: TSizes.spaceBtwItems,
                      ),
                      TSearchContainer(
                        text: '探検する',
                        showborder: true,
                        showBackground: false,
                        padding: EdgeInsets.zero,
                      ),
                      SizedBox(
                        height: TSizes.spaceBtwSections,
                      ),
                      TSectionHeading(title: '不動産', onPressed: () {}),
                      SizedBox(
                        height: TSizes.spaceBtwItems / 1.5,
                      ),
                      TGridLayout(
                          itemCount: 4,
                          mainAxisExtent: 80,
                          itemBuilder: (_, index) {
                            return const TPropertyCard(showBorder: false);
                          }),
                    ],
                  ),
                ),
                bottom: const TTabBar(tabs: [
                  Tab(child: Text('居住の')),
                  Tab(child: Text('コマーシャル')),
                  Tab(child: Text('産業用')),
                  Tab(child: Text('土地')),
                  Tab(child: Text('特別な目的'))
                ]),
              )
            ];
          },
          body: TabBarView(children: [
            TCategoryTab(),
            TCategoryTab(),
            TCategoryTab(),
            TCategoryTab(),
            TCategoryTab(),
          ]),
        ),
      ),
    );
  }
}
