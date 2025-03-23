
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/cubit.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import 'package:heaaro_company/modules/home/meals/breakfast.dart';
import 'package:heaaro_company/modules/home/meals/dinner.dart';
import 'package:heaaro_company/modules/home/meals/extra.dart';
import 'package:heaaro_company/modules/home/meals/lunch.dart';
import 'package:heaaro_company/modules/userDetails/cubit/user_details_cubit.dart';
import 'package:heaaro_company/modules/userDetails/cubit/user_details_state.dart';
import 'package:heaaro_company/shared/components.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;


  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage % 3,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  double calculateBMI(double height, double weight) {
    if (height <= 0) return 0.0;
    return weight / (height * height);
  }

  final List<double> bmiHistory = [18.5, 20.3, 21.7, 22.5, 23.1, 24.0];

  String getBMIStatus(double bmi) {
    if (bmi < 18.5) return "Underweight";
    if (bmi < 24.9) return "Normal";
    if (bmi < 29.9) return "Overweight";
    return "Obese";
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      builder: (context, state) => BlocConsumer<UserDetailsCubit, UserDetailsState>(
        listener: (context, state) {},
        builder: (context, state) {
          UserDetailsCubit cubit = UserDetailsCubit.get(context);
          double userHeight = double.tryParse(cubit.userDetailsModel?.height ?? '175') ?? 175;
          double userWeight = double.tryParse(cubit.userDetailsModel?.weight ?? '60') ?? 60;
          userHeight = userHeight / 100;
          double bmi = calculateBMI(userHeight,userWeight);
          String bmiStatus = getBMIStatus(bmi);
          return Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 250,
                    child: PageView(
                      controller: _pageController,
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        Image.asset('asset/images/food.png', fit: BoxFit.cover),
                        Image.asset('asset/images/Banners.png', fit: BoxFit.cover),
                        Image.asset('asset/images/freepik.png', fit: BoxFit.cover),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 15,
                      left: 20,
                      right: 20,
                      bottom: 30,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text('Age: ${cubit.userDetailsModel?.age ?? 0}'),
                                  Text('Weight: ${cubit.userDetailsModel?.weight ?? 0} kg'),
                                  Text('Height: ${cubit.userDetailsModel?.height ?? 0} cm'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "BMI: ${bmi.toStringAsFixed(1)} - $bmiStatus",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: bmiStatus == "Underweight" || bmiStatus == "Obese"
                                      ? Colors.red
                                      : bmiStatus == "Overweight"
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'BMI Report:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(show: false),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 40,
                                    getTitlesWidget: (value, _) => Text(
                                      value.toStringAsFixed(1),
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, _) => Text(
                                      'M${value.toInt() + 1}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                              ),
                              borderData: FlBorderData(show: true, border: Border.all(color: Colors.black)),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: List.generate(
                                    bmiHistory.length,
                                        (index) => FlSpot(index.toDouble(), bmiHistory[index]),
                                  ),
                                  isCurved: true,
                                  barWidth: 3,
                                  color: Colors.blue,
                                  belowBarData: BarAreaData(show: false),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Your Meals:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  navigateTo(context, const BreakfastScreen());
                                },
                                child: const Image(image: AssetImage('asset/images/breakFast.png')),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  navigateTo(context, const LunchScreen());
                                },
                                child: const Image(image: AssetImage('asset/images/lunch.png')),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  navigateTo(context, const DinnerScreen());
                                },
                                child: const Image(image: AssetImage('asset/images/dinner.png')),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  navigateTo(context, const ExtraScreen());
                                },
                                child: const Image(image: AssetImage('asset/images/extraMeal.png')),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      listener: (context, state) {},
    );
  }
}
