import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/cubit.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/add_meal.dart';
import 'package:heaaro_company/shared/components.dart';
import '../../core/config.dart';
import '../../shared/constants.dart';
import '../../shared/local/cacheHelper.dart';

class MealLoginScreen extends StatefulWidget {
  const MealLoginScreen({super.key});

  @override
  State<MealLoginScreen> createState() => _MealLoginScreenState();
}

class _MealLoginScreenState extends State<MealLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(
              '${Config.localization["login_meal"] ?? "Login Meal"}',
              style: TextStyle(color: defaultColor),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => Directionality(
                      textDirection:
                      isArabic ? TextDirection.rtl : TextDirection.ltr,
                      child: AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              '${Config.localization["about_meals"] ?? "About Meals"}',
                            ),
                          ],
                        ),
                        content: Text(
                          '${Config.localization["meals_description"] ?? "Meals are tailored based on your BMI and health condition to ensure they are suitable and healthy for you."}',
                          style: const TextStyle(fontSize: 16),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '${Config.localization["ok"] ?? "Ok"}',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.info_outline),
              )
            ],
          ),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 50,
                    left: 20,
                    child: ScaleTransition(
                      scale: _animation,
                      child: Icon(
                        Icons.fastfood,
                        color: defaultColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 30,
                    right: 40,
                    child: ScaleTransition(
                      scale: _animation,
                      child: Icon(
                        Icons.local_dining,
                        color: defaultColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 100,
                    left: 40,
                    child: ScaleTransition(
                      scale: _animation,
                      child: Icon(
                        Icons.emoji_food_beverage,
                        color: defaultColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 80,
                    right: 20,
                    child: ScaleTransition(
                      scale: _animation,
                      child: Icon(
                        Icons.icecream,
                        color: defaultColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ScaleTransition(
                        scale: _animation,
                        child: GestureDetector(
                          onTap: () {
                            navigateTo(context, const MealsScreen());
                          },
                          child: Container(
                            padding: const EdgeInsets.all(30),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: defaultColor.withOpacity(0.2),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.restaurant_menu,
                                  size: 60,
                                  color: defaultColor,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  '${Config.localization["tap_to_add_meal"] ?? "Tap to add your meal"}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: defaultColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
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
        ),
      ),
    );
  }
}
