
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/modules/home/meals/cubit/user_meals_cubit.dart';
import 'package:heaaro_company/modules/home/meals/cubit/user_meals_state.dart';
import 'package:heaaro_company/shared/constants.dart';
import '../../../model/addMealModel.dart';

class DinnerScreen extends StatelessWidget {
  const DinnerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserMealsCubit()..getUserMeal(),
      child: BlocBuilder<UserMealsCubit, UserMealsState>(
        builder: (context, state) {
          var cubit = context.watch<UserMealsCubit>();

          return Scaffold(
            appBar: AppBar(
              title: const Text(
                "Meal Details",
                style: TextStyle(color: Colors.green),
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
              child: cubit.dinnerItem.isEmpty
                  ? const Center(child: Text('You don\'t have Meal'))
                  : ListView.builder(
                itemCount: cubit.dinnerItem.length,
                itemBuilder: (BuildContext context, int index) {
                  return _mealItem(cubit.dinnerItem[index],state,index);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _mealItem(AddMealModel model,state, index) => Builder(
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
          const Center(
            child: Text(
              "Easy - Healthy",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _infoChip("$totalCalories Calories", Colors.green.shade100, Colors.green)),
              Expanded(child: _infoChip("${totalProtein}g Protein", Colors.blue.shade100, Colors.blue)),
              Expanded(child: _infoChip("${totalCarbs}g Carbs", Colors.orange.shade100, Colors.orange)),
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
                ListView.builder(
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
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          state is RemoveUserMealsLoading? LinearProgressIndicator(color: defaultColor,) :
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: defaultColor,
                padding: const EdgeInsets.all(15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                UserMealsCubit.get(context).removeMeal(UserMealsCubit.get(context).dinnerIdItem[index], model.category!);
              },
              child: const Text("Meal Completed 🤝", style: TextStyle(fontSize: 18, color: Colors.white)),
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
