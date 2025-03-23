
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/modules/onBoarding.dart';
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

  runApp(const MyApp(),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themeLight,
      home: OnBoard(),
    );
  }
}

