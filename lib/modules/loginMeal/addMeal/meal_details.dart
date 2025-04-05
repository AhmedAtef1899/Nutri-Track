
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/addMealModel.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/cubit/login_meal_cubit.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/cubit/login_meal_state.dart';
import '../../../shared/constants.dart';

class MealDetailsScreen extends StatelessWidget {
  final AddMealModel addMealModel;
  const MealDetailsScreen({super.key, required this.addMealModel});
  @override
  Widget build(BuildContext context) {
    double calculateTotalCalories(List<Ingredient> ingredients) {
      return ingredients.fold(
          0, (sum, ingredient) => sum + ingredient.calories);
    }
    double calculateTotalProtein(List<Ingredient> ingredients) {
      return ingredients.fold(0, (sum, ingredient) => sum + ingredient.protein);
    }
    double calculateTotalCarbs(List<Ingredient> ingredients) {
      return ingredients.fold(0, (sum, ingredient) => sum + ingredient.carbs);
    }
    return BlocProvider(
      create: (context) =>
      LoginMealCubit()
        ..getMeals(),
      child: BlocConsumer<LoginMealCubit, LoginMealState>(
        listener: (context, state) {
          if (state is AddMealSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  "Meal added successfully! 🍽️🎉",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: const Text(
                "Meal Details",
                style: TextStyle(color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.green),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body:
            state is GetMealLoading ? Center(
                child: CircularProgressIndicator(color: defaultColor,)) :
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: addMealModel.imageUrl ?? '',
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          addMealModel.imageUrl ?? '',
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    const Center(
                      child: Text(
                        "Easy - Healthy",
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _infoChip(
                            "${calculateTotalCalories(
                                addMealModel.ingredients)} Calories",
                            Colors.green.shade100,
                            Colors.green,
                          ),
                        ),
                        Expanded(
                          child: _infoChip(
                            "${calculateTotalProtein(
                                addMealModel.ingredients)}g Protein",
                            Colors.blue.shade100,
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _infoChip(
                            "${calculateTotalCarbs(
                                addMealModel.ingredients)}g Carbs",
                            Colors.orange.shade100,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(
                            color: Colors.grey.shade300, blurRadius: 5)
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildTableHeader(),
                          ...addMealModel.ingredients.map((ingredient) =>
                              _buildTableRow(
                                ingredient.name,
                                "${ingredient.calories} Cal",
                                "${ingredient.protein}g",
                                "${ingredient.carbs}g",
                              )),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: defaultColor,
                          padding: const EdgeInsets.all(15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          LoginMealCubit.get(context).addMeal(
                              mealTitle: addMealModel.mealTitle ?? '',
                              ingredients: addMealModel.ingredients,
                              imageUrl: addMealModel.imageUrl ?? '',
                              category: addMealModel.category ?? '',
                            context: context
                          );
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Add",
                              style: TextStyle(fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 5,),
                            Icon(
                              FluentIcons.add_circle_48_regular,
                              color: Colors.white,
                            )
                          ],
                        ),
                      ),
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

  Widget _infoChip(String label, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Chip(
        backgroundColor: bgColor,
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text("Calories", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text("Protein", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text("Carbs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String ingredient, String calories, String protein, String carbs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(ingredient),
          Text(calories),
          Text(protein),
          Text(carbs),
        ],
      ),
    );
  }
}