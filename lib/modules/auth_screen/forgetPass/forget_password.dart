import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/config.dart';
import '../../../shared/components.dart';
import '../../../shared/constants.dart';
import '../../../shared/local/cacheHelper.dart';
import '../cubit/cubit.dart';
import '../cubit/states.dart';
import '../register/Register.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create: (BuildContext context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthStates>(
          listener: (context, state) {
          },
          builder: (context, state) {
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
                        const SizedBox(height: 100),
                        Text(
                          Config.localization['forget_password_title'] ?? '',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          Config.localization['forget_password_subtitle'] ?? '',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 15),
                        defaultForm(
                          label: Config.localization['username_label'] ?? '',
                          prefix: Icons.email_outlined,
                          type: TextInputType.emailAddress,
                          controller: cubit.emailController,
                          validate: (value) {
                            if (value.isEmpty) {
                              return Config.localization['empty']??"";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        defaultButton(
                          background: defaultColor,
                          height: 58,
                          radius: 100,
                          text: Config.localization['send_code']??'',
                          function: () {
                            if (formKey.currentState!.validate()) {
                              cubit.sendResetCode(context);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              Config.localization['no_account']??'',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(width: 5),
                            TextButton(
                              onPressed: () {
                                navigateAndFinish(context, const RegisterScreen());
                              },
                              child: Text(
                                Config.localization['sign_up']??'',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
