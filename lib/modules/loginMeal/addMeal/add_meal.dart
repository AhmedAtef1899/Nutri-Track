import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/addMealModel.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/cubit/login_meal_state.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/meal_details.dart';
import 'package:heaaro_company/shared/components.dart';
import '../../../core/config.dart';
import '../../../shared/constants.dart';
import '../../../shared/local/cacheHelper.dart';
import 'cubit/login_meal_cubit.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create: (context) => LoginMealCubit()..getMeals(),
        child: BlocConsumer<LoginMealCubit, LoginMealState>(
          listener: (context, state) {
            if (state is AddMealSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                  content: Text('${Config.localization["meal_added_successfully"] ?? "Meal added successfully!"}',),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is GetMealLoading) {
              return Center(child: CircularProgressIndicator(color: defaultColor));
            }

            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .collection('details')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final userData = snapshot.data!.data() as Map<String, dynamic>;
                final bmiValue = double.tryParse(userData['bmi'].toString());
                final healthCondition = userData['health'] ?? 'None';

                if (bmiValue == null) return const Center(child: Text("Invalid BMI"));

                String bmiCategory = '';
                if (bmiValue < 18.5) {
                  bmiCategory = 'BMI < 18.5';
                } else if (bmiValue >= 18.5 && bmiValue <= 24.9) {
                  bmiCategory = 'BMI 18.5 - 24.9';
                } else if (bmiValue >= 25 && bmiValue <= 29.9) {
                  bmiCategory = 'BMI 25 - 29.9';
                } else if (bmiValue >= 30) {
                  bmiCategory = 'BMI >= 30';
                }

                final cubit = LoginMealCubit.get(context);

                return Scaffold(
                  appBar: AppBar(
                    title:  Text(
                        '${Config.localization["addMeal"] ?? "Add Meal"}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildMealCategory('${Config.localization["breakfast"] ?? "Breakfast"}', cubit.breakfastItems, bmiCategory, healthCondition, context),
                        buildMealCategory('${Config.localization["lunch"] ?? "Lunch"}', cubit.lunchItems, bmiCategory, healthCondition, context),
                        buildMealCategory('${Config.localization["dinner"] ?? "Dinner"}', cubit.dinnerItems, bmiCategory, healthCondition, context),
                        buildMealCategory('${Config.localization["snack"] ?? "Snack"}', cubit.extraItems, bmiCategory, healthCondition, context),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget buildMealCategory(
      String title,
      List<AddMealModel> meals,
      String bmiCategory,
      String healthCondition,
      BuildContext context,
      ) {
    final filteredMeals = meals.where((meal) {
      return meal.bmi == bmiCategory &&
          (meal.healthCondition == 'None' || meal.healthCondition == healthCondition);
    }).toList();

    if (filteredMeals.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 5),
        SizedBox(
          height: 320,
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: filteredMeals.length,
            itemBuilder: (context, index) {
              final meal = filteredMeals[index];
              return mealItem(context, meal, meal.ingredients, index, bmiCategory);
            },
            separatorBuilder: (context, index) => const SizedBox(width: 5),
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget mealItem(BuildContext context, AddMealModel model, List<Ingredient> ingredient, int index, String userBmiCategory) {
    double totalCalories = ingredient.fold(0, (double sum, item) => sum + item.calories);
    double totalProtein = ingredient.fold(0, (double sum, item) => sum + item.protein);
    double totalCarbs = ingredient.fold(0, (double sum, item) => sum + item.carbs);
    return GestureDetector(
      onTap: () {
        navigateTo(context, MealDetailsScreen(addMealModel: model));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
        ),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(model.imageUrl ?? 'asset/images/Red Yellow Simple Delicious Fried Chicken Instagram Story 1.png'),
                  width: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.mealTitle ?? '',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${Config.localization['calories'] ?? 'Calories'}: ${totalCalories.toStringAsFixed(2)}g | ${Config.localization['protein'] ?? 'Protein'}: ${totalProtein.toStringAsFixed(2)}g | ${Config.localization['carbs'] ?? 'Carbs'}: ${totalCarbs.toStringAsFixed(2)}g',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: defaultColor,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        LoginMealCubit.get(context).addMeal(
                          mealTitle: model.mealTitle ?? '',
                          ingredients: ingredient,
                          imageUrl: model.imageUrl ?? '',
                          category: model.category ?? '',
                          context: context,
                          bmi: model.bmi ?? '',
                        );
                      },
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${Config.localization['add'] ?? 'Add'}",
                            style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(width: 5),
                          const Icon(FluentIcons.add_circle_48_regular, color: Colors.white),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
