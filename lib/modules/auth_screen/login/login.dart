
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/homeLayout.dart';
import 'package:heaaro_company/modules/auth_screen/register/Register.dart';
import 'package:heaaro_company/shared/local/cacheHelper.dart';
import '../../../core/config.dart';
import '../../../shared/components.dart';
import '../../../shared/constants.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../forgetPass/forget_password.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
          create: (BuildContext context) => AuthCubit(),
          child: BlocConsumer<AuthCubit, AuthStates>(builder: (context, state) {
            AuthCubit cubit = AuthCubit.get(context);
            return Scaffold(
              body: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 100,
                        ),
                        Text(
                          Config.localization['welcome'] ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        Text(
                          Config.localization['login_instruction'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        defaultForm(
                            label: Config.localization['username_label'] ?? '',
                            prefix: CupertinoIcons.person_crop_circle,
                            type: TextInputType.emailAddress,
                            controller: emailController,
                            formatters: [FilteringTextInputFormatter.deny(' ')],
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return Config.localization['empty_error'] ?? '';
                              }

                              return null;
                            }),
                        const SizedBox(
                          height: 8,
                        ),
                        defaultForm(
                            label: Config.localization['password_label'] ?? '',
                            prefix: FluentIcons.password_16_regular,
                            type: TextInputType.visiblePassword,
                            controller: passwordController,
                            suffix: cubit.isVisible? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                            isVisible: cubit.isVisible,
                            suffixPressed: (){
                              cubit.changeVisible();
                            },
                            formatters: [FilteringTextInputFormatter.deny(' ')],
                            validate: (value) {
                              if (value.isEmpty) {
                                return Config.localization['empty_error'] ?? '';
                              } else if (value.length < 6) {
                                return Config.localization['short_password'] ?? '';
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                       state is AuthLoginLoadingState?
                        LinearProgressIndicator(color: defaultColor,) :
                       defaultButton(
                                background: defaultColor,
                                height: 58,
                                radius: 100,
                                text: Config.localization['login_button'] ?? '',
                                function: () {
                                  if(formKey.currentState!.validate()){
                                    cubit.login(email: emailController.text, password: passwordController.text);
                                  }
                                }),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            Config.localization['or'] ?? '',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: TextButton(
                              onPressed: () {
                                navigateTo(context, ForgetPasswordScreen());
                              },
                              child: Text(
                                Config.localization['forget_password'] ?? '',
                                style: Theme.of(context).textTheme.labelMedium,
                                textAlign: TextAlign.center,
                              )),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Config.localization['no_account'] ?? '',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateAndFinish(context, const RegisterScreen());
                                },
                                child: Text(
                                  Config.localization['sign_up'] ?? '',
                                  style: Theme.of(context).textTheme.labelMedium,
                                ))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, listener: (context, state) {
            if(state is AuthLoginSuccessState)
              {
                showSnackBar(context: context,  msg: Config.localization['login_success'] ?? 'Success',
                    title: Config.localization['sign_in'] ?? 'Sign In', type: ContentType.success);
                navigateAndFinish(context, const AppLayoutScreen());
                CacheHelper.saveData(key: 'uId', value: uId);
              }
            if(state is AuthLoginErrorState){
              showSnackBar(context: context, msg: state.error, title: Config.localization['login_failed'] ?? 'Login Failed', type: ContentType.failure);
            }
          })),
    );
  }
}
