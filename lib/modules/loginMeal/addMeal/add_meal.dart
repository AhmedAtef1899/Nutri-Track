
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/addMealModel.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/cubit/login_meal_state.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/meal_details.dart';
import 'package:heaaro_company/shared/components.dart';
import '../../../shared/constants.dart';
import 'cubit/login_meal_cubit.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      LoginMealCubit()
        ..getMeals(),
      child: BlocConsumer<LoginMealCubit, LoginMealState>(
          builder: (context, state) =>
              Scaffold(
                appBar: AppBar(
                  title: const Text(
                    'Add Meal',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  centerTitle: true,
                ),
                body:
                state is GetMealLoading ? Center(
                    child: CircularProgressIndicator(color: defaultColor,)) :
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Breakfast',
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                        ),
                        const SizedBox(height: 5,),
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: LoginMealCubit
                                .get(context)
                                .breakfastItems
                                .length,
                            itemBuilder: (context, index) {
                              final meal = LoginMealCubit
                                  .get(context)
                                  .breakfastItems[index];
                              return mealItem(
                                  context, meal,
                                  meal.ingredients,
                                  index); // Pass the full list
                            },
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Text(
                          'Lunch',
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                        ),
                        const SizedBox(height: 5,),
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: LoginMealCubit
                                .get(context)
                                .lunchItems
                                .length,
                            itemBuilder: (context, index) {
                              final meal = LoginMealCubit
                                  .get(context)
                                  .lunchItems[index];
                              return mealItem(
                                  context, meal, meal.ingredients, index
                              );
                            },
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Text(
                          'Dinner',
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                        ),
                        const SizedBox(height: 5,),
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: LoginMealCubit
                                .get(context)
                                .dinnerItems
                                .length,
                            itemBuilder: (context, index) {
                              final meal = LoginMealCubit
                                  .get(context)
                                  .dinnerItems[index];
                              return mealItem(context, meal,
                                  meal.ingredients,
                                  index); // Pass the full list
                            },
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                          ),
                        ),
                        const SizedBox(height: 15,),
                        Text(
                          'Extra',
                          style: Theme
                              .of(context)
                              .textTheme
                              .displayLarge,
                        ),
                        const SizedBox(height: 5,),
                        SizedBox(
                          height: 320,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: LoginMealCubit
                                .get(context)
                                .extraItems
                                .length,
                            itemBuilder: (context, index) {
                              final meal = LoginMealCubit
                                  .get(context)
                                  .extraItems[index];
                              return mealItem(context, meal,
                                  meal.ingredients,
                                  index); // Pass the full list
                            },
                            separatorBuilder: (context, index) =>
                            const SizedBox(width: 5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          listener: (context, state) {
            if (state is AddMealSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Meal added successfully!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          }
      ),);
  }
}

Widget mealItem(context, AddMealModel model, List<Ingredient> ingredient,index)=> Builder(
  builder: (context) {
    double totalCalories = ingredient.fold(0, (sum, item) => sum + (item.calories));
    double totalProtein = ingredient.fold(0, (sum, item) => sum + (item.protein));
    double totalCarbs = ingredient.fold(0, (sum, item) => sum + (item.carbs));
    return GestureDetector(
      onTap: (){
        navigateTo(context,  MealDetailsScreen(addMealModel: model,));
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.55,
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
          children: [
             Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
                child: Image(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    model.imageUrl ?? 'asset/images/Red Yellow Simple Delicious Fried Chicken Instagram Story 1.png',
                  ),
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
                    'Calories: ${totalCalories.toStringAsFixed(2)}g | Protein: ${totalProtein.toStringAsFixed(2)}g | Carbs: ${totalCarbs.toStringAsFixed(2)}g',
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: defaultColor,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        LoginMealCubit.get(context).addMeal(
                            mealTitle: model.mealTitle ?? '',
                            ingredients: ingredient,
                            imageUrl: model.imageUrl ?? '',
                            category: model.category ?? '',
                          context: context
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Add",
                            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
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
            )
          ],
        ),
      ),
    );
  }
);

