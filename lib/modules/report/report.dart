import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../../core/config.dart';
import '../../layout/cubit/cubit.dart';
import '../../shared/constants.dart';
import '../../shared/local/cacheHelper.dart';
import '../userDetails/cubit/user_details_cubit.dart';
import 'report_cubit.dart';
import 'report_state.dart';

class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocConsumer<ReportCubit, ReportState>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ReportCubit.get(context);
          final userCubit = UserDetailsCubit.get(context);

          final gender = userCubit.userDetailsModel?.gender ?? 'male';
          final age = int.tryParse(userCubit.userDetailsModel?.age ?? '30') ?? 30;
          final height = double.tryParse(userCubit.userDetailsModel?.height ?? '170') ?? 170;
          final weight = double.tryParse(userCubit.userDetailsModel?.weight ?? '70') ?? 70;

          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);
          final weekAgo = today.subtract(const Duration(days: 7));
          final monthAgo = today.subtract(const Duration(days: 30));

          final dailyGoal = cubit.calculateBMR(
            gender: gender,
            age: age,
            weightKg: weight,
            heightCm: height,
          ).roundToDouble();

          final weeklyGoal = dailyGoal * 7;
          final monthlyGoal = dailyGoal * 30;

          final nutritionTotals = cubit.calculateNutritionTotals(today, weekAgo, monthAgo);
          final totalCalories = nutritionTotals['calories']!;
          final totalProtein = nutritionTotals['protein']!;
          final totalCarbs = nutritionTotals['carbs']!;
          final totalFat = nutritionTotals['fat']!;

          final selectedGoal = cubit.selectedFilter == 'Day'
              ? dailyGoal
              : cubit.selectedFilter == 'Week'
              ? weeklyGoal
              : cubit.selectedFilter == 'Month'
              ? monthlyGoal
              : 0.0;

          double percentCalories = selectedGoal != 0 ? totalCalories / selectedGoal : 0.0;
          percentCalories = percentCalories.clamp(0.0, 1.0);

          return Scaffold(
            appBar: AppBar(
              title: Text(Config.localization['progress'] ?? 'Progress',
                  style: TextStyle(color: defaultColor)),
              actions: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Directionality(
                          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                          child: _buildInfoDialog(context)),
                    );
                  },
                  icon: const Icon(Icons.info_outline),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: state is GetReportLoading
                  ? const Center(child: CircularProgressIndicator())
                  : AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: SingleChildScrollView(
                  key: ValueKey(cubit.selectedFilter),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedOpacity(
                        opacity: 1.0,
                        duration: const Duration(milliseconds: 800),
                        child: Text(
                          '${Config.localization['hello'] ?? 'Hello'}, ${AppCubit.get(context).authModel?.name ?? 'User'}! ${Config.localization['daily_goal'] ?? 'Your daily goal'}: ${dailyGoal.toStringAsFixed(0)} cal',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: cubit.selectedActivity,
                        decoration: InputDecoration(
                          labelText: Config.localization['activity_level'] ?? 'Activity Level',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        items: cubit.activityLevels.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value[0].toUpperCase() + value.substring(1),
                              style: const TextStyle(fontSize: 17, color: Colors.blue),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            cubit.changeActivityLevel(newValue);
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        child: Row(
                          children: ['Day', 'Week', 'Month', 'All'].map((filter) {
                            final isSelected = cubit.selectedFilter == filter;
                            return GestureDetector(
                              onTap: () => cubit.changeFilter(filter),
                              child: _buildFilterButton(Config.localization[filter.toLowerCase()] ?? filter,
                                  isSelected: isSelected),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Config.localization['food_log_focus'] ?? 'Food Log Focus',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (cubit.selectedFilter != 'All') ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(Config.localization['remaining'] ?? 'Remaining',
                                      style: const TextStyle(color: Colors.grey)),
                                  Text(Config.localization['target'] ?? 'Target',
                                      style: const TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    (selectedGoal - totalCalories).toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    selectedGoal.toStringAsFixed(0),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 20),
                            Center(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 600),
                                child: CircularPercentIndicator(
                                  key: ValueKey(percentCalories),
                                  radius: 70.0,
                                  lineWidth: 10.0,
                                  percent: percentCalories,
                                  center: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.local_fire_department,
                                          color: Colors.orange, size: 30),
                                      Text(
                                        totalCalories.toStringAsFixed(0),
                                        style: const TextStyle(
                                            fontSize: 22, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        Config.localization['consumed'] ?? 'Consumed',
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                  progressColor: Colors.orange,
                                  backgroundColor: Colors.grey.shade300,
                                  circularStrokeCap: CircularStrokeCap.round,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildNutrientInfo(
                                    Config.localization['protein'] ?? 'Protein',
                                    '${totalProtein.toStringAsFixed(0)} g',
                                    Colors.red),
                                _buildNutrientInfo(
                                    Config.localization['carbs'] ?? 'Carbs',
                                    '${totalCarbs.toStringAsFixed(0)} g',
                                    Colors.blue),
                                _buildNutrientInfo(
                                    Config.localization['fat'] ?? 'Fat',
                                    '${totalFat.toStringAsFixed(0)} g',
                                    Colors.green),
                              ],
                            ),
                            const SizedBox(height: 20),
                            if (cubit.selectedFilter != 'All')
                              AnimatedOpacity(
                                opacity: 1,
                                duration: const Duration(milliseconds: 500),
                                child: Text(
                                  '${Config.localization['weekly_goal'] ?? 'Weekly Goal'}: ${weeklyGoal.toStringAsFixed(0)} cal\n${Config.localization['monthly_goal'] ?? 'Monthly Goal'}: ${monthlyGoal.toStringAsFixed(0)} cal',
                                  style:
                                  const TextStyle(fontSize: 14, color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoDialog(BuildContext context) {
    return AlertDialog(
      title: Text(Config.localization['report_screen_info'] ?? 'Report Screen Info'),
      content: SingleChildScrollView(
        child: Text(
          Config.localization['report_info_content'] ??
              '📊 This screen shows your calorie and nutrient tracking...',
          style: const TextStyle(height: 1.5),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(Config.localization['close'] ?? 'Close'),
        ),
      ],
    );
  }

  Widget _buildFilterButton(String text, {bool isSelected = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, Color color) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        Text(value, style: const TextStyle(fontSize: 14, color: Colors.black)),
      ],
    );
  }
}
