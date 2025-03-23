
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/layout/cubit/cubit.dart';
import 'package:heaaro_company/layout/cubit/states.dart';
import '../shared/constants.dart';

class HomeLayoutScreen extends StatelessWidget {
  const HomeLayoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context)=> AppCubit(),
    child:BlocConsumer<AppCubit,AppStates>(builder: (context,state)=>Scaffold(
      appBar: AppBar(
        title:  Text('Nutrition Track',
          style: TextStyle(
            color: defaultColor
          ),
        ),
      ),
      body: AppCubit.get(context).screens[AppCubit.get(context).currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: AppCubit.get(context).currentIndex,
        items: AppCubit.get(context).bottomNav,
        onTap: (index){
          AppCubit.get(context).changeBar(index);
        },
      ),
    ), listener: (context,state){}),
    );
  }
}
