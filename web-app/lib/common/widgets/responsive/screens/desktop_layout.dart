import 'package:flutter/material.dart';
import 'package:tranquilestate_admin_panel/common/widgets/containers/rounded_container.dart';

class DesktopLayout extends StatelessWidget {
  const DesktopLayout({super.key, this.body});

  final Widget? body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(child: Drawer()),
          Expanded(
            flex: 5,
            child: Column(
              children: [
                //Header
                TRoundedContainer(
                  width: double.infinity,
                  height: 75,
                  backgroundColor: Colors.blue.withOpacity(0.2),
                ),
                //Body
                body ?? const SizedBox()
              ],
            ),
          ),
        ],
      ),
    );
  }
}
