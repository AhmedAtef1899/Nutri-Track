
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/core/config.dart';
import 'package:heaaro_company/layout/cubit/cubit.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import 'package:heaaro_company/modules/auth_screen/login/login.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screen.dart';
import 'package:heaaro_company/shared/components.dart';

import '../../shared/constants.dart';
import '../../shared/local/cacheHelper.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController locationController = TextEditingController();
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {
          if (state is UpdateUserSuccess) {
            showSnackBar(
              context: context,
              msg: '${Config.localization['updated_success'] ?? 'Updated Successfully'}',
              title: '${Config.localization['updated_title'] ?? 'Updated'}',
              type: ContentType.success,
            );
          }
          if (state is UpdateUserError) {
            String errorMsg = '${Config.localization['update_error'] ?? 'An unexpected error occurred'}';
            if (state.error is FirebaseException) {
              errorMsg = state.error.toString();
            }
            showSnackBar(
              context: context,
              msg: errorMsg,
              title: '${Config.localization['error_title'] ?? 'Error'}',
              type: ContentType.failure,
            );
          }
        },
        builder: (context, state) {
          final authModel = AppCubit
              .get(context)
              .authModel;

          emailController.text = authModel?.email ?? '';
          nameController.text = authModel?.name ?? '';
          locationController.text = authModel?.location ?? '';

          return Scaffold(
            appBar: AppBar(
              title: Text('${Config.localization['settings_title'] ?? 'Settings'}', style: TextStyle(color: defaultColor)),
              actions: [
                IconButton(
                  onPressed: () {
                    navigateTo(context, const EditScreen());
                  },
                  icon: const Icon(FluentIcons.edit_settings_24_filled),
                ),
              ],
            ),
            body: state is UpdateUserLoading || state is GetUserLoading
                ? const Center(
              child: CircularProgressIndicator(),
            )
                : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    defaultForm(
                      label: '${Config.localization['name'] ?? 'Name'}',
                      type: TextInputType.name,
                      controller: nameController,
                      prefix: Icons.person_outline_outlined,
                      validate: (value) {
                        return '';
                      },
                    ),
                    const SizedBox(height: 8),
                    defaultForm(
                      label: '${Config.localization['location'] ?? 'Location'}',
                      type: TextInputType.text,
                      controller: locationController,
                      prefix: Icons.location_on_outlined,
                      validate: (value) {
                        return '';
                      },
                    ),
                    const SizedBox(height: 8),
                    defaultForm(
                      label: '${Config.localization['email'] ?? 'Email'}',
                      type: TextInputType.emailAddress,
                      controller: emailController,
                      prefix: Icons.email_outlined,
                      validate: (value) {
                        return '';
                      },
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue,
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                if (authModel != null) {
                                  AppCubit.get(context).updateUser(
                                    name: nameController.text,
                                    location: locationController.text,
                                    email: emailController.text,
                                  );
                                }
                              },
                              label:  Text(
                                '${Config.localization['update'] ?? 'Update'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.red,
                            ),
                            child: TextButton.icon(
                              onPressed: () {
                                navigateAndFinish(context, const LoginScreen());
                              },
                              label:  Text(
                                '${Config.localization['logout'] ?? 'Logout'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              icon: const Icon(
                                Icons.output,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

