import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/cubit/edit_cubit.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/cubit/edit_state.dart';
import 'package:heaaro_company/shared/components.dart';
import '../../../../core/config.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/local/cacheHelper.dart';

class EditDataScreen extends StatefulWidget {
  const EditDataScreen({super.key});
  @override
  _EditDataScreenState createState() => _EditDataScreenState();
}

class _EditDataScreenState extends State<EditDataScreen> {
  String? selectedGender;
  String? selectedHealthCondition;

  final List<String> genders = ['Male', 'Female'];
  final List<String> healthConditions = [ 'High Blood Pressure',
    'Heart Disease',
    'Diabetes',
    'None',];

  @override
  Widget build(BuildContext context) {
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();
    TextEditingController ageController = TextEditingController();
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create: (context) => EditCubit()..getUserData(),
        child: BlocConsumer<EditCubit, EditState>(
          listener: (context, state) {
            if (state is UpdateSuccess) {
              showSnackBar(
                context: context,
                msg: '${Config.localization['updated_success'] ?? 'Updated Successfully'}',
                title: '${Config.localization['updated_title'] ?? 'Updated'}',
                type: ContentType.success,
              );
            }
            if (state is UpdateError) {
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
            EditCubit cubit = EditCubit.get(context);
            weightController.text = cubit.userDetailsModel?.weight ?? '';
            heightController.text = cubit.userDetailsModel?.height ?? '';
            ageController.text = cubit.userDetailsModel?.age ?? '';

            selectedGender = cubit.userDetailsModel?.gender ?? ''; // Default to 'Male'
            selectedHealthCondition = cubit.userDetailsModel?.health ?? ''; // Default to 'None'

            return Scaffold(
              appBar: AppBar(
                title: Text('${Config.localization['edit_personal_data'] ?? 'Edit Personal Data'}', style: TextStyle(color: defaultColor)),
              ),
              body:
              state is UpdateLoading || state is GetLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  :
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      defaultForm(
                        label: '${Config.localization['age'] ?? 'Age'}',
                        type: TextInputType.number,
                        controller: ageController,
                        prefix: FluentIcons.person_5_20_regular,
                        validate: (value) => '',
                      ),
                      const SizedBox(height: 8),
                      defaultForm(
                        label: '${Config.localization['weight'] ?? 'Weight'}',
                        type: TextInputType.number,
                        controller: weightController,
                        prefix: FluentIcons.slide_size_24_regular,
                        validate: (value) => '',
                      ),
                      const SizedBox(height: 8),
                      defaultForm(
                        label: '${Config.localization['height'] ?? 'Height'}',
                        type: TextInputType.number,
                        controller: heightController,
                        prefix: FluentIcons.arrow_autofit_height_in_24_regular,
                        validate: (value) => '',
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedGender,
                        hint:  Text('${Config.localization['select_gender'] ?? 'Select Gender'}', style: const TextStyle(fontSize: 17)),
                        items: genders.map((String gender) {
                          return DropdownMenuItem<String>(
                            value: gender,
                            child: Text(gender, style: const TextStyle(fontSize: 17)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '${Config.localization['gender'] ?? 'Gender'}',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: selectedHealthCondition,
                        hint: const Text('Select Health Condition', style: TextStyle(fontSize: 17)),
                        items: healthConditions.map((String condition) {
                          return DropdownMenuItem<String>(
                            value: condition,
                            child: Text(condition, style: const TextStyle(fontSize: 17)),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedHealthCondition = newValue;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: '${Config.localization['health_condition'] ?? 'Health Condition'}',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.blue,
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            final double weight = double.tryParse(
                                weightController.text) ?? 0;
                            final double heightCm = double.tryParse(
                                heightController.text) ?? 0;
                            final double heightM = heightCm / 100;
                            if (weight > 0 && heightM > 0) {
                              final double bmi = weight /
                                  (heightM * heightM);
                              EditCubit.get(context).updateUserData(
                                  weight: weightController.text,
                                  height: heightController.text,
                                  age: ageController.text,
                                  health: selectedHealthCondition.toString(),
                                  gender: selectedGender.toString(),
                                  bmi: bmi.toStringAsFixed(0)
                              );
                            }
                          },
                          label:  Text(
                            '${Config.localization['update'] ?? 'Update'}',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
                          ),
                          icon: const Icon(Icons.save,color: Colors.white,),
                        ),
                      ),
                    ],
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

