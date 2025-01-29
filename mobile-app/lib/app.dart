import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:tranquilestate/bindings/general_bindings.dart';
import 'package:tranquilestate/utils/constants/colors.dart';
import 'package:tranquilestate/utils/constants/text_strings.dart';
import 'package:tranquilestate/utils/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: TTexts.appName,
      themeMode: ThemeMode.system,
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialBinding: GeneralBindings(),
      home: const Scaffold(
        backgroundColor: TColors.primary,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      ),
    );
  }
}
