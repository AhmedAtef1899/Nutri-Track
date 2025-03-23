
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import 'package:heaaro_company/modules/mealLogin.dart';
import 'package:heaaro_company/modules/report.dart';
import 'package:heaaro_company/modules/settings.dart';

import '../../modules/home.dart';


class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  static AppCubit get(context) => BlocProvider.of(context);

  List<Widget> screens = const [
    HomeScreen(),
    MealLoginScreen(),
    ReportScreen(),
    SettingsScreen(),
  ];

  List<BottomNavigationBarItem> bottomNav = [
    const BottomNavigationBarItem(
        tooltip: 'Home', icon: Icon(CupertinoIcons.home), label: 'Home'),
    const BottomNavigationBarItem(
        tooltip: 'Meal',
        icon: Icon(Icons.food_bank_outlined),
        label: 'Meal'),
    const BottomNavigationBarItem(
        tooltip: 'Report',
        icon: Icon(Icons.cell_tower_outlined),
        label: 'Report'),
    const BottomNavigationBarItem(
        tooltip: 'Settings',
        icon: Icon(CupertinoIcons.settings),
        label: 'Settings'),
  ];

  int currentIndex = 0;

  void changeBar(index) {
    currentIndex = index;
    emit(AppChangeBarState());
  }

}
