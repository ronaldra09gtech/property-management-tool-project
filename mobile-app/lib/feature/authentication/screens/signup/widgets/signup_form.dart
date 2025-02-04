import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tranquilestate/feature/authentication/controllers/signup/sign_up_controller.dart';
import 'package:tranquilestate/feature/authentication/screens/signup/widgets/terms_condition_checkbox.dart';
import 'package:tranquilestate/utils/constants/sizes.dart';
import 'package:tranquilestate/utils/constants/text_strings.dart';
import 'package:tranquilestate/utils/validators/validation.dart';

class TSignupForm extends StatelessWidget {
  const TSignupForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    return Form(
      key: controller.signupFormKey,
      child: Column(
        children: [
          Row(
            children: [

              ///FIRSTNAME
              Expanded(
                child: TextFormField(
                  controller: controller.firstName,
                  validator: (value) =>
                      TValidator.validateEmptyText('ファーストネーム', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.firstName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),

              ///LASTNAME
              const SizedBox(width: TSizes.spaceBtwInputFields),
              Expanded(
                child: TextFormField(
                  controller: controller.lastName,
                  validator: (value) =>
                      TValidator.validateEmptyText('苗字', value),
                  expands: false,
                  decoration: const InputDecoration(
                      labelText: TTexts.lastName,
                      prefixIcon: Icon(Iconsax.user)),
                ),
              ),
            ],
          ),

          ///USERNAME
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.userName,
            validator: (value) =>
                TValidator.validateEmptyText('Username', value),
            decoration: const InputDecoration(
                labelText: TTexts.username,
                prefixIcon: Icon(Iconsax.user_edit)),
          ),

          ///EMAIL
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.email,
            validator: (value) => TValidator.validateEmail(value),
            decoration: const InputDecoration(
                labelText: TTexts.email, prefixIcon: Icon(Iconsax.direct)),
          ),

          ///PHONE NUMBER
          const SizedBox(height: TSizes.spaceBtwInputFields),
          TextFormField(
            controller: controller.phoneNumber,
            validator: (value) => TValidator.validatePhoneNumber(value),
            decoration: const InputDecoration(
                labelText: TTexts.phoneNo, prefixIcon: Icon(Iconsax.call)),
          ),

          ///PASSWORD
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Obx(
            () => TextFormField(
              controller: controller.password,
              validator: (value) => TValidator.validatePassword(value),
              obscureText: controller.hidePassword.value,
              decoration: InputDecoration(
                labelText: TTexts.password,
                prefixIcon: Icon(Iconsax.password_check),
                suffixIcon: IconButton(
                    onPressed: () => controller.hidePassword.value =
                        !controller.hidePassword.value,
                    icon: Icon(controller.hidePassword.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye)),
              ),
            ),
          ),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          ///TERMS&CONDITION CHECKBOX
          const TTermsAndConditionCheckbox(),
          const SizedBox(
            height: TSizes.spaceBtwSections,
          ),

          ///SIGNUP BUTTON
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
                onPressed: () => controller.signup(),
                child: const Text(TTexts.createAccount)),
          ),
        ],
      ),
    );
  }
}
