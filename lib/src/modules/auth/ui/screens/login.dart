import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tarsheed/generated/l10n.dart'; // تأكد من استيراد الترجمة
import 'package:tarsheed/src/core/error/exception_manager.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/bloc/auth_bloc.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/sign_up_create_account.dart';

import '../../../../core/utils/image_manager.dart';
import '../widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/social_icon.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc.instance;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackGroundRectangle(),
          ),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is LoginSuccessState) {
                context.push("/home");
              } else if (state is AuthErrorState) {
                ExceptionManager.showMessage(state.exception);
              }
            },
            child: SizedBox(),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 97),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MainTitle(maintext: S.of(context).login_here),
                    SizedBox(height: 30),
                    SupTitle(
                      text2: S.of(context).welcome_back,
                      fontweight: FontWeight.w600,
                      size: 20,
                      width: 228,
                    ),
                    SizedBox(height: 64),
                    CustomTextField(
                      fieldType: FieldType.email,
                      controller: emailController,
                      hintText: S.of(context).email,
                    ),
                    SizedBox(height: 20),
                    CustomTextField(
                      fieldType: FieldType.password,
                      controller: passwordController,
                      hintText: S.of(context).password,
                    ),
                    SizedBox(height: 21),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          S.of(context).forgot_password,
                          style: TextStyle(
                              color: Colors.blue[800],
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    BlocBuilder<AuthBloc, AuthState>(
                      bloc: authBloc,
                      builder: (context, state) {
                        return state is LoginLoadingState
                            ? Center(child: CircularProgressIndicator())
                            : LargeButton(
                                textB: S.of(context).sign_in,
                                formKey: formKey,
                                emailController: emailController,
                                passwordController: passwordController,
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                          LoginWithEmailAndPasswordEvent(
                                            email: emailController.text.trim(),
                                            password:
                                                passwordController.text.trim(),
                                          ),
                                        );
                                  }
                                },
                              );
                      },
                    ),
                    const SizedBox(height: 15),
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          textStyle: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SignUpScreen()));
                        },
                        child: Text(S.of(context).create_new_account),
                      ),
                    ),
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        S.of(context).or_continue_with,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF2666DE),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialIcon(
                          image: AssetsManager.google,
                          scale: 1.3,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SocialIcon(
                          image: AssetsManager.facebook,
                          scale: 2,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        SocialIcon(image: AssetsManager.apple)
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
