import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tarsheed/src/core/routing/navigation_manager.dart';
import 'package:tarsheed/src/modules/auth/ui/screens/verify_code.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/error/exception_manager.dart';
import '../../bloc/auth_bloc.dart';
import '../widgets/large_button.dart';
import '../widgets/main_title.dart';
import '../widgets/rectangle_background.dart';
import '../widgets/sup_title.dart';
import '../widgets/text_field.dart';

class EmailVerificationScreen extends StatelessWidget {
  EmailVerificationScreen({super.key});

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = AuthBloc.instance;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Positioned.fill(child: BackGroundRectangle()),
          BlocListener<AuthBloc, AuthState>(
            bloc: authBloc,
            listener: (context, state) {
              if (state is ResendVerificationCodeSuccessState) {
                context.push(
                    CodeVerificationScreen(email: emailController.text.trim()));
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
                      MainTitle(maintext: S.of(context).verify_your_identity),
                      SizedBox(height: 5.h),
                      SupTitle(
                          text2: S.of(context).enter_email_to_receive_code),
                      SizedBox(height: 50.h),
                      CustomTextField(
                        fieldType: FieldType.email,
                        controller: emailController,
                        hintText: S.of(context).email,
                      ),
                      SizedBox(height: 15.h),
                      BlocBuilder<AuthBloc, AuthState>(
                        bloc: authBloc,
                        builder: (context, state) {
                          if (state is VerifyEmailLoadingState) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return DefaultButton(
                            title: S.of(context).continue_text,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context
                                    .read<AuthBloc>()
                                    .add(ResendVerificationCodeEvent());
                              }
                            },
                          );
                        },
                      ),
                      SizedBox(height: 15.h),
                      Container(height: 420.h),
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
