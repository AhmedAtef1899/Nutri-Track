
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/addMealModel.dart';
import 'package:heaaro_company/modules/home/meals/cubit/user_meals_state.dart';

class UserMealsCubit extends Cubit<UserMealsState> {
  UserMealsCubit() : super(UserMealsInitial());

  static UserMealsCubit get(context) => BlocProvider.of(context);

  List<AddMealModel> breakfastItem = [];
  List<String> breakfastIdItem = [];
  List<AddMealModel> lunchItem = [];
  List<String> lunchIdItem = [];
  List<AddMealModel> dinnerItem = [];
  List<String> dinnerIdItem = [];
  List<AddMealModel> extraItem = [];
  List<String> extraIdItem = [];

  void getUserMeal()
  {
    removeOldMeals();
    emit(GetUserMealsLoading());
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Breakfast')
    .get().then((onValue){
      breakfastItem = [];
      breakfastIdItem = [];
      for (var action in onValue.docs) {
        breakfastItem.add(AddMealModel.fromJson(action.data()));
        breakfastIdItem.add(action.id);
      }
      emit(GetUserMealsSuccess());
    }).catchError((onError){
      emit(GetUserMealsError());
    });
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Lunch')
        .get().then((onValue){
      lunchItem = [];
      lunchIdItem = [];
      for (var action in onValue.docs) {
        lunchItem.add(AddMealModel.fromJson(action.data()));
        lunchIdItem.add(action.id);
      }
    }).catchError((onError){
      print(onError.toString());
    });
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Dinner')
        .get().then((onValue){
      dinnerItem = [];
      dinnerIdItem = [];
      for (var action in onValue.docs) {
        dinnerItem.add(AddMealModel.fromJson(action.data()));
        dinnerIdItem.add(action.id);
      }
    }).catchError((onError){
      print(onError.toString());
    });
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('Extra')
        .get().then((onValue){
      extraItem = [];
      extraIdItem = [];
      for (var action in onValue.docs) {
        extraItem.add(AddMealModel.fromJson(action.data()));
        extraIdItem.add(action.id);
      }
    }).catchError((onError){
      print(onError.toString());
    });
  }

  void mealCompleted ({
    required String? age,
    required String? healthCondition,
    required String? mealTitle,
    required List<Ingredient> ingredients,
    required String? imageUrl,
    required String? category,
    required String mealId
}){
    emit(CompletedUserMealsLoading());
    String uid = FirebaseAuth.instance.currentUser!.uid;
    AddMealModel addMealModel = AddMealModel(
        ingredients: ingredients,age: age,healthCondition: healthCondition,mealTitle: mealTitle,imageUrl: imageUrl,category: category
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('completed')
        .add(addMealModel.toJson())
        .then((querySnapshot){
          removeMeal(mealId, category!);
      emit(CompletedUserMealsSuccess());
    }).catchError((error) {
      print("Error deleting meal: $error");
      emit(CompletedUserMealsSuccess());
    });
  }

  void removeMeal(String mealId, String category) {
    emit(RemoveUserMealsLoading());
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection(category)
        .doc(mealId)
        .delete()
        .then((querySnapshot){
          getUserMeal();
      emit(RemoveUserMealsSuccess());
    }).catchError((error) {
      print("Error deleting meal: $error");
      emit(RemoveUserMealsError());
    });
  }

  void removeOldMeals() {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    DateTime now = DateTime.now();
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Breakfast')
        .where('timestamp', isLessThan: now.subtract(const Duration(hours: 14)).millisecondsSinceEpoch)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      emit(GetUserMealsSuccess());
    }).catchError((error) {
      print("Error removing old meals: $error");
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Lunch')
        .where('timestamp', isLessThan: now.subtract(const Duration(hours: 14)).millisecondsSinceEpoch)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      emit(GetUserMealsSuccess());
    }).catchError((error) {
      print("Error removing old meals: $error");
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Dinner')
        .where('timestamp', isLessThan: now.subtract(const Duration(hours: 14)).millisecondsSinceEpoch)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      emit(GetUserMealsSuccess());
    }).catchError((error) {
      print("Error removing old meals: $error");
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('Extra')
        .where('timestamp', isLessThan: now.subtract(const Duration(hours: 14)).millisecondsSinceEpoch)
        .get()
        .then((querySnapshot) {
      for (var doc in querySnapshot.docs) {
        doc.reference.delete();
      }
      emit(GetUserMealsSuccess());
    }).catchError((error) {
      print("Error removing old meals: $error");
    });
  }
}
