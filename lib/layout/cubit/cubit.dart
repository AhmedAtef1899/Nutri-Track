
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import 'package:heaaro_company/model/authModel.dart';
import 'package:heaaro_company/modules/loginMeal/mealLogin.dart';
import 'package:heaaro_company/modules/report/report.dart';
import 'package:heaaro_company/modules/setting/settings.dart';
import '../../core/config.dart';
import '../../modules/home/home.dart';

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
     BottomNavigationBarItem(
        tooltip: 'Home', icon: const Icon(CupertinoIcons.home), label: '${Config.localization['home'] ?? 'Home'}',),
     BottomNavigationBarItem(
        tooltip: 'Meal',
        icon: const Icon(Icons.food_bank_outlined),
        label: '${Config.localization['meal'] ?? 'Meal'}',),
     BottomNavigationBarItem(
        tooltip: 'Report',
        icon: const Icon(Icons.cell_tower_outlined),
        label: '${Config.localization['report'] ?? 'Report'}',),
     BottomNavigationBarItem(
        tooltip: 'More',
        icon: const Icon(CupertinoIcons.list_bullet),
        label: '${Config.localization['more'] ?? 'More'}',),
  ];

  int currentIndex = 0;

  void changeBar(index) {
    currentIndex = index;
    if(index == 3)
      {
        getUser();
      }
    emit(AppChangeBarState());
  }

  AuthModel? authModel;

  getUser() {
    emit(GetUserLoading());
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(GetUserError());
      return;
    }
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((onValue) {
      if (onValue.exists) {
        authModel = AuthModel.fromJson(onValue.data() as Map<String, dynamic>);
        emit(GetUserSuccess());
      } else {
        emit(GetUserError());
      }
    }).catchError((onError) {
      emit(GetUserError());
    });
  }

  updateUser({
    required String name,
    required String location,
    required String email,
    context,
  })
  {
    emit(UpdateUserLoading());

    String? uid = FirebaseAuth.instance.currentUser?.uid;

    authModel = AuthModel(name, location, email,uid);
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update(authModel!.toMap())
        .then((onValue) {
      getUser();
      emit(UpdateUserSuccess());
    }).catchError((onError) {
      emit(UpdateUserError(error: onError));
    });
  }


}
