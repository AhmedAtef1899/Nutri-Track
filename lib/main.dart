
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/cubit.dart';
import 'package:heaaro_company/layout/homeLayout.dart';
import 'package:heaaro_company/modules/home/meals/cubit/user_meals_cubit.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/cubit/login_meal_cubit.dart';
import 'package:heaaro_company/modules/onBoarding.dart';
import 'package:heaaro_company/modules/report/report_cubit.dart';
import 'package:heaaro_company/modules/userDetails/cubit/user_details_cubit.dart';
import 'package:heaaro_company/shared/blocObserve.dart';
import 'package:heaaro_company/shared/local/cacheHelper.dart';
import 'package:heaaro_company/shared/theme.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyBv5El2ibPLjl65fbmnTasE_aNi-ecAHG4',
        appId: '1:1038912317047:android:c0f22c5947d7b53e3c4872',
        messagingSenderId: '1038912317047',
        projectId: 'heaaro-74ff7',
      storageBucket: 'heaaro-74ff7.appspot.com'
    )
  );
  await CacheHelper.init();
  Bloc.observer = MyBlocObserver();
  var uId = CacheHelper.getData(key: 'uId') ?? '';
  Widget widget;
  if(uId == ''){
    widget = const OnBoard();
  }else{
    widget = const AppLayoutScreen();
  }
  runApp( MyApp(startWidget: widget,),);
}

class MyApp extends StatelessWidget {
  final Widget startWidget;
  const MyApp({super.key, required this.startWidget});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context)=> AppCubit()),
          BlocProvider(create: (context)=> UserDetailsCubit()..getUserDetails()),
          BlocProvider(create: (context)=> LoginMealCubit()..getMeals()),
          BlocProvider(create: (context)=> UserMealsCubit()..getUserMeal()),
          BlocProvider(create: (context)=> ReportCubit()..getReports()),
        ],
        child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeLight,
      home: startWidget,
    ));
  }
}

