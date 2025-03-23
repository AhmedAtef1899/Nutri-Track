
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/homeLayout.dart';
import 'package:heaaro_company/modules/auth_screen/register/Register.dart';
import 'package:heaaro_company/shared/local/cacheHelper.dart';
import '../../../shared/components.dart';
import '../../../shared/constants.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
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
                        'Welcome Back!',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Enter your credential to Login',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultForm(
                          label: 'Enter your username or email',
                          prefix: CupertinoIcons.person_crop_circle,
                          type: TextInputType.emailAddress,
                          controller: emailController,
                          formatters: [FilteringTextInputFormatter.deny(' ')],
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Empty';
                            }

                            return null;
                          }),
                      const SizedBox(
                        height: 8,
                      ),
                      defaultForm(
                          label: 'Enter your Password',
                          prefix: FluentIcons.password_16_regular,
                          type: TextInputType.visiblePassword,
                          controller: passwordController,
                          suffix: CupertinoIcons.eye_slash,
                          formatters: [FilteringTextInputFormatter.deny(' ')],
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Empty';
                            } else if (value.length < 6) {
                              return 'Short Password';
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
                              text: 'Login',
                              function: () {
                                if(formKey.currentState!.validate()){
                                  cubit.login(email: emailController.text, password: passwordController.text);
                                }
                              }),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'or',
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
                            },
                            child: Text(
                              'Forget password?',
                              style: Theme.of(context).textTheme.labelMedium,
                              textAlign: TextAlign.center,
                            )),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                              onPressed: () {
                                navigateAndFinish(context, const RegisterScreen());
                              },
                              child: Text(
                                'Sign Up',
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
              navigateAndFinish(context, const AppLayoutScreen());
              CacheHelper.saveData(key: 'uId', value: uId);
            }
        }));
  }
}
