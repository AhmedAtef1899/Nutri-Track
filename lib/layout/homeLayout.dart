
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/cubit.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import '../shared/constants.dart';
import '../shared/local/cacheHelper.dart';

class AppLayoutScreen extends StatelessWidget {
  const AppLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic? TextDirection.rtl : TextDirection.ltr,
      child: BlocProvider(
        create: (BuildContext context) => AppCubit(),
        child: BlocConsumer<AppCubit, AppStates>(
          builder: (context, state) => Scaffold(
            body: AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:  BorderRadius.circular(20
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:  BorderRadius.circular(20
                  ),
                  child: BottomNavigationBar(
                    currentIndex: AppCubit.get(context).currentIndex,
                    items: AppCubit.get(context).bottomNav,
                    onTap: (index) {
                      AppCubit.get(context).changeBar(index);
                    },
                    selectedItemColor: defaultColor,
                    unselectedItemColor: Colors.grey,
                    selectedFontSize: 14,
                    unselectedFontSize: 12,
                    iconSize: 28,
                    elevation: 5,
                    backgroundColor: Colors.white,
                    type: BottomNavigationBarType.fixed,
                  ),
                ),
              ),
            ),
          ),
          listener: (context, state) {},
        ),
      ),
    );
  }
}
