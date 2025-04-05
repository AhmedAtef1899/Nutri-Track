
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/modules/auth_screen/login/login.dart';
import 'package:heaaro_company/modules/userDetails/user_details.dart';
import '../../../shared/components.dart';
import '../../../shared/constants.dart';
import '../../../shared/local/cacheHelper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var nameController = TextEditingController();
    var locationController = TextEditingController();
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
                        'Join with Us',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        'Please Enter your Personal Info',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      defaultForm(
                          label: 'Enter your  Name',
                          prefix: CupertinoIcons.person_crop_circle,
                          type: TextInputType.name,
                          controller: nameController,
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
                          label: 'Enter your Location',
                          prefix: CupertinoIcons.location,
                          type: TextInputType.text,
                          controller: locationController,
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
                          label: 'Enter your email',
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
                          suffix: cubit.isVisible? CupertinoIcons.eye_slash : CupertinoIcons.eye,
                          isVisible: cubit.isVisible,
                          suffixPressed: (){
                            cubit.changeVisible();
                          },
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
                      state is AuthRegisterLoadingState?
                      LinearProgressIndicator(color: defaultColor,) :
                      defaultButton(
                          background: defaultColor,
                          height: 58,
                          radius: 100,
                          text: 'Sign Up',
                          function: () {
                            if(formKey.currentState!.validate()){
                              cubit.register(email: emailController.text,
                                  password: passwordController.text,
                                  name: nameController.text,
                                  location: locationController.text);
                            }
                          }),
                      const SizedBox(
                        height: 10,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          TextButton(
                              onPressed: () {
                                navigateAndFinish(context, const LoginScreen());
                              },
                              child: Text(
                                'Sign In',
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
          if(state is AuthRegisterSuccessState){
            showSnackBar(context: context, msg: 'Register Successfully! 👍', title: 'Sign Up Message', type: ContentType.success);
            navigateAndFinish(context, const UserDetailsScreen());
            CacheHelper.saveData(key: 'uId', value: uId);
          }
          if(state is AuthRegisterErrorState){
            showSnackBar(context: context, msg: state.error, title: 'Register Failed!', type: ContentType.failure);
          }
        }));
  }
}
