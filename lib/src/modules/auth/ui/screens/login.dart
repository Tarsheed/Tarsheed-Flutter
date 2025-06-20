import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/generated/l10n.dart';
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/core/services/dep_injection.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/sign_up_create_account.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_email.dart';
import 'package:tarsheed/src/modules/auth/ui/widgets/sup_title.dart';
import 'package:tarsheed/src/modules/settings/ui/screens/main_screen.dart';

import '../../../../core/utils/image_manager.dart';
import '../../../../core/widgets/large_button.dart';
import '../../../../core/widgets/rectangle_background.dart';
import '../../../../core/widgets/text_field.dart';
import '../widgets/main_title.dart';
import '../widgets/social_icon.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthBloc authBloc = sl();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: BackGroundRectangle(),
          ),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is LoginSuccessState) {
                context.pushReplacement(MainScreen());
              } else if (state is AuthErrorState) {
                ExceptionManager.showMessage(state.exception);
              }
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 97.h),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MainTitle(mainText: S.of(context).loginHere),
                      SizedBox(height: 20.h),
                      SupTitle(
                        text2: S.of(context).welcomeBack,
                        fontWeight: FontWeight.w600,
                        size: 20.sp,
                        width: 228.w,
                      ),
                      SizedBox(height: 50.h),
                      CustomTextField(
                        autofillHints: const [AutofillHints.email],
                        controller: emailController,
                        hintText: S.of(context).email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '${S.of(context).email} ${S.of(context).isRequired}';
                          }
                          final trimmedValue = value.trim();
                          if (trimmedValue.length > 40) {
                            return '${S.of(context).email} ${S.of(context).cannotExceed} 40 ${S.of(context).characters}';
                          }
                          final emailRegex = RegExp(
                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            caseSensitive: false,
                          );
                          if (!emailRegex.hasMatch(trimmedValue)) {
                            return S.of(context).invalidEmail;
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20.h),
                      CustomTextField(
                        controller: passwordController,
                        autofillHints: const [AutofillHints.password],
                        hintText: S.of(context).password,
                        maxLines: 1,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return '${S.of(context).password} ${S.of(context).isRequired}';
                          }
                          final trimmedValue = value.trim();
                          if (trimmedValue.length < 6) {
                            return '${S.of(context).password} ${S.of(context).mustBeAtLeast} 6 ${S.of(context).characters}';
                          }
                          if (trimmedValue.length > 40) {
                            return '${S.of(context).password} ${S.of(context).cannotExceed} 40 ${S.of(context).characters}';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 21.h),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          onPressed: () {
                            context.push(EmailVerificationScreen());
                          },
                          child: Text(
                            S.of(context).forgotPassword,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          return DefaultButton(
                            isLoading:
                                state is LoginWithEmailAndPasswordLoadingState,
                            title: S.of(context).signIn,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                AuthBloc.instance.add(
                                  LoginWithEmailAndPasswordEvent(
                                    email: emailController.text.trim(),
                                    password: passwordController.text.trim(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 15.h),
                      Center(
                        child: TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.onBackground,
                            textStyle: theme.textTheme.labelLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          onPressed: () {
                            context.push(SignUpScreen());
                          },
                          child: Text(S.of(context).createNewAccount),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Center(
                        child: Text(
                          S.of(context).orContinueWith,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: state is LoginWithGoogleLoadingState
                                    ? null
                                    : () {
                                        AuthBloc.instance
                                            .add(const LoginWithGoogleEvent());
                                      },
                                child: state is LoginWithGoogleLoadingState
                                    ? SizedBox(
                                        height: 44.h,
                                        width: 60.w,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      )
                                    : SocialIcon(
                                        image: AssetsManager.google,
                                        scale: 1.3,
                                      ),
                              ),
                              SizedBox(width: 8.w),
                              GestureDetector(
                                onTap: state is LoginWithFacebookLoadingState
                                    ? null
                                    : () {
                                        AuthBloc.instance.add(
                                            const LoginWithFacebookEvent());
                                      },
                                child: state is LoginWithFacebookLoadingState
                                    ? SizedBox(
                                        height: 44.h,
                                        width: 60.w,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      )
                                    : SocialIcon(
                                        image: AssetsManager.facebook,
                                        scale: 2,
                                      ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
