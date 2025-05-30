import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/homeLayout.dart';
import 'package:heaaro_company/modules/userDetails/cubit/user_details_cubit.dart';
import 'package:heaaro_company/modules/userDetails/cubit/user_details_state.dart';
import 'package:heaaro_company/shared/components.dart';
import 'package:heaaro_company/shared/constants.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final ValueNotifier<String?> healthConditionNotifier = ValueNotifier<String?>(
      null);
  final ValueNotifier<String?> genderNotifier = ValueNotifier<String?>(null);

  final List<String> healthConditions = [ 'High Blood Pressure',
    'Heart Disease',
    'Diabetes',
    'None',
  ];
  final List<String> genderOptions = ['Male', 'Female'];

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) return 'Underweight';
    if (bmi >= 18.5 && bmi < 25) return 'Normal';
    if (bmi >= 25 && bmi < 30) return 'Overweight';
    return 'Obese';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserDetailsCubit(),
      child: BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (context, state) {
          if (state is UserDetailsAddedSuccessState) {
            navigateAndFinish(context, const AppLayoutScreen());
          }
        },
        builder: (context, state) =>
            Scaffold(
              appBar: AppBar(
                title: const Text(
                    'User Details', style: TextStyle(color: Colors.white)),
                centerTitle: true,
                backgroundColor: defaultColor,
                elevation: 2,
                systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: defaultColor,
                  statusBarIconBrightness: Brightness.light,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'We use this information to recommend suitable meal plans.',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),

                        // Age
                        defaultForm(
                          label: 'Age',
                          type: TextInputType.number,
                          prefix: FluentIcons.number_circle_0_28_regular,
                          controller: ageController,
                          validate: (value) {
                            if (value.isEmpty) return 'Please enter your age';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Height
                        defaultForm(
                          label: 'Height (cm)',
                          type: TextInputType.number,
                          prefix: FluentIcons
                              .arrow_autofit_height_in_24_regular,
                          controller: heightController,
                          validate: (value) {
                            if (value.isEmpty)
                              return 'Please enter your height';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Weight
                        defaultForm(
                          label: 'Weight (kg)',
                          type: TextInputType.number,
                          prefix: Icons.line_weight_outlined,
                          controller: weightController,
                          validate: (value) {
                            if (value.isEmpty)
                              return 'Please enter your weight';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),

                        // Gender Dropdown
                        const Text(
                          'Gender:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        ValueListenableBuilder<String?>(
                          valueListenable: genderNotifier,
                          builder: (context, selectedGender, _) {
                            return DropdownButtonFormField<String>(
                              value: selectedGender,
                              items: genderOptions
                                  .map((gender) =>
                                  DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender,
                                        style: const TextStyle(fontSize: 18)),
                                  ))
                                  .toList(),
                              onChanged: (value) =>
                              genderNotifier.value = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                              ),
                              validator: (value) {
                                if (value == null)
                                  return 'Please select your gender';
                                return null;
                              },
                            );
                          },
                        ),

                        const SizedBox(height: 12),

                        // Health Condition
                        const Text(
                          'Health Condition:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        ValueListenableBuilder<String?>(
                          valueListenable: healthConditionNotifier,
                          builder: (context, selectedValue, _) {
                            return DropdownButtonFormField<String>(
                              value: selectedValue,
                              items: healthConditions
                                  .map((condition) =>
                                  DropdownMenuItem(
                                    value: condition,
                                    child: Text(condition,
                                        style: const TextStyle(fontSize: 18)),
                                  ))
                                  .toList(),
                              onChanged: (value) =>
                              healthConditionNotifier.value = value,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: Colors.grey[100],
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 12),
                              ),
                              validator: (value) {
                                if (value == null)
                                  return 'Please select your health condition';
                                return null;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),

                        // Submit Button
                        state is UserDetailsAddedLoadingState
                            ? LinearProgressIndicator(color: defaultColor)
                            : Center(
                          child: defaultButton(
                            background: defaultColor,
                            text: 'Continue ➡️',
                            function: () {
                              if (formKey.currentState!.validate()) {
                                final double weight = double.tryParse(
                                    weightController.text) ?? 0;
                                final double heightCm = double.tryParse(
                                    heightController.text) ?? 0;
                                final double heightM = heightCm / 100;
                                if (weight > 0 && heightM > 0) {
                                  final double bmi = weight /
                                      (heightM * heightM);

                                  UserDetailsCubit.get(context).addUserDetails(
                                    age: ageController.text,
                                    weight: weightController.text,
                                    height: heightController.text,
                                    health: healthConditionNotifier.value
                                        .toString(),
                                    gender: genderNotifier.value.toString(),
                                    bmi: bmi.toStringAsFixed(2),
                                  );
                                } else {
                                  showSnackBar(
                                    title: 'Invalid height or weight values',
                                    context: context,
                                    type: ContentType.failure,
                                    msg: 'Please check your input values.',
                                  );
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
      ),
    );
  }

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    healthConditionNotifier.dispose();
    genderNotifier.dispose();
    super.dispose();
  }
}
