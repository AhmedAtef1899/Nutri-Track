import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/addMealModel.dart';
import 'package:heaaro_company/modules/report/report_state.dart';
import 'package:heaaro_company/shared/local/cacheHelper.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial()) {
    _loadActivityLevel();
  }

  static ReportCubit get(context) => BlocProvider.of(context);

  final List<AddMealModel> report = [];
  String selectedFilter = 'Day';
  String selectedActivity = 'moderate';
  final List<String> activityLevels = [
    'sedentary',
    'light',
    'moderate',
    'active'
  ];

  Future<void> _loadActivityLevel() async {
    selectedActivity = await CacheHelper.getData(key: 'activity') ?? 'sedentary';
    emit(ReportInitial());
  }

  void changeActivityLevel(String newActivity) {
    selectedActivity = newActivity;
    CacheHelper.saveData(key: 'activity', value: selectedActivity);
    emit(ReportActivityLevelChanged());
  }

  void getReports() async {
    emit(GetReportLoading());

    try {
      final String uId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uId)
          .collection('completed')
          .get();
      report
        ..clear()
        ..addAll(querySnapshot.docs.map((doc) => AddMealModel.fromJson(doc.data())));

      emit(GetReportSuccess());
    } catch (error) {
      emit(GetReportError());
    }
  }

  void changeFilter(String filter) {
    selectedFilter = filter;
    emit(ReportFilterChanged());
  }

  double calculateBMR({
    required String gender,
    required int age,
    required double weightKg,
    required double heightCm,
  }) {
    double bmr = gender == 'male'
        ? 10 * weightKg + 6.25 * heightCm - 5 * age + 5
        : 10 * weightKg + 6.25 * heightCm - 5 * age - 161;

    switch (selectedActivity) {
      case 'sedentary':
        return bmr * 1.2;
      case 'light':
        return bmr * 1.375;
      case 'moderate':
        return bmr * 1.55;
      case 'active':
        return bmr * 1.725;
      default:
        return bmr * 1.2;
    }
  }

  Map<String, double> calculateNutritionTotals(DateTime today, DateTime weekAgo, DateTime monthAgo) {
    double totalCalories = 0;
    double totalProtein = 0;
    double totalCarbs = 0;
    double totalFat = 0;

    final filteredMeals = report.where((meal) {
      final mealDate = meal.date;
      if (mealDate == null) return false;

      switch (selectedFilter) {
        case 'Day':
          return mealDate.year == today.year &&
              mealDate.month == today.month &&
              mealDate.day == today.day;
        case 'Week':
          return mealDate.isAfter(weekAgo) || mealDate.isAtSameMomentAs(weekAgo);
        case 'Month':
          return mealDate.isAfter(monthAgo) || mealDate.isAtSameMomentAs(monthAgo);
        case 'All':
          return true;
        default:
          return true;
      }
    }).toList();

    for (var meal in filteredMeals) {
      for (var ingredient in meal.ingredients) {
        totalCalories += ingredient.calories;
        totalProtein += ingredient.protein;
        totalCarbs += ingredient.carbs;
        totalFat += 0; // Assuming fat isn't being tracked currently
      }
    }

    return {
      'calories': totalCalories,
      'protein': totalProtein,
      'carbs': totalCarbs,
      'fat': totalFat,
    };
  }
}