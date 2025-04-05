
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components.dart';
import '../../../shared/constants.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../register/Register.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (BuildContext context) => AuthCubit(),
      child: BlocConsumer<AuthCubit, AuthStates>(listener: (context, state) {
        // if (state is AuthSuccess) {
        //   AppNavigator.pushR(context, const SubmitCodeScreen(),
        //       NavigatorAnimation.slideAnimation);
        // }
      }, builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Text(
                      'Forget Password',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Text(
                      'To reset your password, you need your email or mobile number that can be authenticated',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultForm(
                        label: 'Enter your email ',
                        prefix: Icons.email_outlined,
                        type: TextInputType.emailAddress,
                        controller: cubit.emailController,
                        validate: (value) {
                          if (value.isEmpty) {
                            return 'Empty';
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 20,
                    ),
                    defaultButton(
                        background: defaultColor,
                        height: 58,
                        radius: 100,
                        text: 'Send Code',
                        function: () {
                          if (formKey.currentState!.validate()) {
                            cubit.sendResetCode(context);
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          width: 5,
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
      }),
    );
  }
}
