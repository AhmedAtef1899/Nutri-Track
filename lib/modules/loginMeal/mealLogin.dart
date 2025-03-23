
import 'package:flutter/material.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/addMeal.dart';
import 'package:heaaro_company/shared/components.dart';

class MealLoginScreen extends StatelessWidget {
  const MealLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: (){
                navigateTo(context, const MealsScreen());
              },
                child: const Center(
                    child: Image(
                        image: AssetImage(
                            'asset/images/Frame 18.png'
                        )
                    )
                )
            ),
          ],
        ),
      ),
    );
  }
}
