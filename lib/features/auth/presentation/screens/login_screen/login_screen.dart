import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_reader/core/utils/app_snackbar.dart';
import 'package:smart_reader/features/auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:smart_reader/features/auth/presentation/screens/login_screen/login_screen_controller.dart';

import '../../../../../core/theme/app_color.dart';
import '../../../../../core/theme/app_text_style.dart';
import '../../../../../core/utils/app_dimens.dart';
import '../../../../../core/utils/validators.dart';
import '../../../../../generated/locale_keys.g.dart';
import '../../widgets/my_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  late LoginScreenController controller;

  @override
  void initState() {
    super.initState();
    controller = LoginScreenController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: AppDimens.paddingLarge),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingLarge),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDimens.radiusLarge),
                  ),
                  child: Icon(
                    Icons.bolt,
                    size: AppDimens.iconLarge,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: AppDimens.verticalSpaceLarge),
                Text(
                  LocaleKeys.login_title.tr(),
                  style: AppTextStyles.heading2,
                ),
                const SizedBox(height: AppDimens.verticalSpaceSmall),

                Text(
                  LocaleKeys.login_subtitle.tr(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySecondary,
                ),

                const SizedBox(height: AppDimens.verticalSpaceLarge),

                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(LocaleKeys.email.tr(), style: AppTextStyles.subtitle),
                ),
                MyTextField(
                  controller: controller.emailController,
                  hintText: LocaleKeys.email_hint.tr(),
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(CupertinoIcons.mail_solid),
                  validator: Validators.validateEmail,
                ),

                const SizedBox(height: AppDimens.verticalSpace),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text( LocaleKeys.password.tr(), style: AppTextStyles.subtitle),
                ),
                const SizedBox(height: AppDimens.verticalSpaceSmall),
                MyTextField(
                  controller: controller.passwordController,
                  hintText: LocaleKeys.password_hint.tr(),
                  obscureText: controller.obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  prefixIcon: const Icon(CupertinoIcons.lock_fill),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        controller.togglePasswordVisibility();
                      });
                    },
                    icon: Icon(controller.iconPassword),
                  ),
                  validator: (val) => Validators.validatePassword(val),
                ),

                const SizedBox(height: AppDimens.verticalSpaceLarge),

                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthAuthenticated) {
                      controller.onSuccessLogin(context);
                    } else if (state is AuthError) {
                      AppSnackBar.error(context, state.message);
                    }
                  },
                  builder: (context, state) {
                    return SizedBox(
                      width: width * 0.75,
                      height: AppDimens.buttonHeight,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            context.read<AuthBloc>().add(
                              LoginEvent(
                                controller.emailController.text.trim(),
                                controller.passwordController.text.trim(),
                              ),
                            );
                          } else {}
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppDimens.radiusLarge,
                            ),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            :  Text(LocaleKeys.login.tr()),
                      ),
                    );
                  },
                ),

                const SizedBox(height: AppDimens.verticalSpaceLarge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
