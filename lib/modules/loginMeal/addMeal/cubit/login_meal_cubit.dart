
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../model/addMealModel.dart';
import 'login_meal_state.dart';

class LoginMealCubit extends Cubit<LoginMealState> {
  LoginMealCubit() : super(LoginMealInitial());
  static LoginMealCubit get(context) => BlocProvider.of(context);

  List<Ingredient> ingredientItems = [];
  List<AddMealModel> breakfastItems = [];
  List<AddMealModel> lunchItems = [];
  List<String> lunchItemsId = [];
  List<AddMealModel> dinnerItems = [];
  List<AddMealModel> extraItems = [];
  AddMealModel? addMealModel;

  void getMeals() {
    emit(GetMealLoading());
    FirebaseFirestore.instance.collection('Breakfast').get()
        .then((onValue) {
      breakfastItems = [];
      ingredientItems = [];
      for (var action in onValue.docs) {
        var data = action.data();
        breakfastItems.add(AddMealModel.fromJson(data));
        if (data.containsKey('ingredients') && data['ingredients'] is List) {
          List<Ingredient> ingredients = (data['ingredients'] as List)
              .map((item) => Ingredient.fromJson(item))
              .toList();
          ingredientItems.addAll(ingredients);
        }
      }
      emit(GetMealSuccess());
    }).catchError((onError) {
      emit(GetMealError());
    });
    FirebaseFirestore.instance.collection('Lunch').get()
        .then((onValue) {
      lunchItems = [];
      lunchItemsId = [];
      ingredientItems = [];
      for (var action in onValue.docs) {
        var data = action.data();
        lunchItems.add(AddMealModel.fromJson(data));
        lunchItemsId.add(action.id);
        if (data.containsKey('ingredients') && data['ingredients'] is List) {
          List<Ingredient> ingredients = (data['ingredients'] as List)
              .map((item) => Ingredient.fromJson(item))
              .toList();
          ingredientItems.addAll(ingredients);
        }
      }
      emit(GetMealSuccess());
    }).catchError((onError) {
      emit(GetMealError());
    });
    FirebaseFirestore.instance.collection('Dinner').get()
        .then((onValue) {
      dinnerItems = [];
      ingredientItems = [];
      for (var action in onValue.docs) {
        var data = action.data();
        dinnerItems.add(AddMealModel.fromJson(data));
        if (data.containsKey('ingredients') && data['ingredients'] is List) {
          List<Ingredient> ingredients = (data['ingredients'] as List)
              .map((item) => Ingredient.fromJson(item))
              .toList();
          ingredientItems.addAll(ingredients);
        }
      }
      emit(GetMealSuccess());
    }).catchError((onError) {
      emit(GetMealError());
    });
    FirebaseFirestore.instance.collection('Extra').get()
        .then((onValue) {
      extraItems = [];
      ingredientItems = [];
      for (var action in onValue.docs) {
        var data = action.data();
        extraItems.add(AddMealModel.fromJson(data));
        if (data.containsKey('ingredients') && data['ingredients'] is List) {
          List<Ingredient> ingredients = (data['ingredients'] as List)
              .map((item) => Ingredient.fromJson(item))
              .toList();
          ingredientItems.addAll(ingredients);
        }
      }
      emit(GetMealSuccess());
    }).catchError((onError) {
      emit(GetMealError());
    });
  }

  void addMeal({
    required BuildContext context, // Pass context to show SnackBar
    required String mealTitle,
    required List<Ingredient> ingredients,
    required String imageUrl,
    required String category,
    required String bmi,
  }) {
    emit(AddMealLoading());

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(category)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isEmpty) {
        addMealModel = AddMealModel(
          ingredients: ingredients,
          mealTitle: mealTitle,
          imageUrl: imageUrl,
          category: category,
          bmi: bmi
        );
        FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection(category)
            .add(addMealModel!.toJson())
            .then((_) {
          emit(AddMealSuccess());
        }).catchError((onError) {
          print(onError.toString());
          emit(AddMealError());
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "You already have a Meal!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
        emit(AddMealError());
      }
    }).catchError((onError) {
      print(onError.toString());
      emit(AddMealError());
    });
  }


}
