import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/modules/home/meals/cubit/user_meals_cubit.dart';
import 'package:heaaro_company/modules/home/meals/cubit/user_meals_state.dart';
import 'package:heaaro_company/shared/constants.dart';
import '../../../core/config.dart';
import '../../../model/addMealModel.dart';
import '../../../shared/local/cacheHelper.dart';

class LunchScreen extends StatelessWidget {
  const LunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create: (context) => UserMealsCubit()..getUserMeal(),
        child: BlocConsumer<UserMealsCubit, UserMealsState>(
          builder: (context, state) {
            var cubit = context.watch<UserMealsCubit>();
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  Config.localization["mealDetails"] ?? "Your Meal",
                  style: const TextStyle(color: Colors.green),
                ),
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.green),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: state is GetUserMealsLoading || state is CompletedUserMealsLoading
                    ? const Center(child: CircularProgressIndicator())
                    : cubit.lunchItem.isEmpty
                    ? Center(
                  child: Text(
                    Config.localization["noMeal"] ?? "You don't have Meal",
                  ),
                )
                    : ListView.builder(
                  itemCount: cubit.lunchItem.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _mealItem(cubit.lunchItem[index], state, index);
                  },
                ),
              ),
            );
          },
          listener: (BuildContext context, UserMealsState state) {
            if (state is RemoveUserMealsSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    Config.localization["mealCompletedSuccess"] ??
                        "Meal Completed successfully! 🍽️🎉",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _mealItem(AddMealModel model, state, index) => Builder(
    builder: (context) {
      double totalCalories = model.ingredients.fold(0, (sum, item) => sum + item.calories);
      double totalProtein = model.ingredients.fold(0, (sum, item) => sum + item.protein);
      double totalCarbs = model.ingredients.fold(0, (sum, item) => sum + item.carbs);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: model.imageUrl != null && model.imageUrl!.isNotEmpty
                ? Image.network(
              model.imageUrl!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 300,
            )
                : Container(
              height: 300,
              width: double.infinity,
              color: Colors.grey[300],
              child: const Center(child: Icon(Icons.image, size: 80, color: Colors.grey)),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              Config.localization["easyHealthy"] ?? "Easy - Healthy",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _infoChip("${totalCalories.toInt()} ${Config.localization["calories"] ?? "Calories"}", Colors.green.shade100, Colors.green)),
              Expanded(child: _infoChip("${totalProtein}g ${Config.localization["protein"] ?? "Protein"}", Colors.blue.shade100, Colors.blue)),
              Expanded(child: _infoChip("${totalCarbs}g ${Config.localization["carbs"] ?? "Carbs"}", Colors.orange.shade100, Colors.orange)),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
              ],
            ),
            child: Column(
              children: [
                _buildTableHeader(),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: model.ingredients.length,
                  itemBuilder: (context, index) {
                    var ingredient = model.ingredients[index];
                    return _buildTableRow(
                      ingredient.name,
                      "${ingredient.calories} Cal",
                      "${ingredient.protein}g",
                      "${ingredient.carbs}g",
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          state is RemoveUserMealsLoading
              ? LinearProgressIndicator(color: defaultColor)
              : SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                UserMealsCubit.get(context).mealCompleted(
                    age: model.age,
                    healthCondition: model.healthCondition,
                    mealTitle: model.mealTitle,
                    ingredients: model.ingredients,
                    imageUrl: model.imageUrl,
                    category: model.category,
                    mealId: UserMealsCubit.get(context).lunchIdItem[index]);
              },
              child: Text(
                Config.localization["mealCompleted"] ?? "Meal Completed 🤝",
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );

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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
              width: 150,
              child: Text(Config.localization["ingredients"] ?? "Ingredients",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green))),
          Text(Config.localization["calories"] ?? "Calories",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text(Config.localization["protein"] ?? "Protein",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text(Config.localization["carbs"] ?? "Carbs",
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
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
          SizedBox(width: 150, child: Text(ingredient)),
          Text(calories),
          Text(protein),
          Text(carbs),
        ],
      ),
    );
  }
}
