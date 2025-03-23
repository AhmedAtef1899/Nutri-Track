
import 'package:flutter/material.dart';
import 'package:heaaro_company/modules/loginMeal/addMeal/mealDetails.dart';
import 'package:heaaro_company/shared/components.dart';
import '../../../shared/constants.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Meal',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Breakfast',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 5,),
              SizedBox(
                height: 320,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => breakfastItem(context),
                  separatorBuilder: (context, index) => const SizedBox(width: 5),
                ),
              ),
              const SizedBox(height: 15,),
              Text(
                'Lunch',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 5,),
              SizedBox(
                height: 320,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => lunchItem(context),
                  separatorBuilder: (context, index) => const SizedBox(width: 5),
                ),
              ),
              const SizedBox(height: 15,),
              Text(
                'Dinner',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 5,),
              SizedBox(
                height: 320,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => dinnerItem(context),
                  separatorBuilder: (context, index) => const SizedBox(width: 5),
                ),
              ),
              const SizedBox(height: 15,),
              Text(
                'Extra',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 5,),
              SizedBox(
                height: 320,
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  itemBuilder: (context, index) => extraItem(context),
                  separatorBuilder: (context, index) => const SizedBox(width: 5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget breakfastItem(context)=> GestureDetector(
  onTap: (){
    navigateTo(context, const MealDetailsScreen());
  },
  child: Container(
    width: MediaQuery.of(context).size.width * 0.55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      children: [
        const Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(
                'asset/images/Red Yellow Simple Delicious Fried Chicken Instagram Story 1.png',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Oatmeal with Fruits & Nuts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              const Text(
                'Calories: 307 | Protein: 42g | Carbs: 24g',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add  ➕",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  ),
);
Widget lunchItem(context)=> GestureDetector(
  onTap: (){
    navigateTo(context, const MealDetailsScreen());
  },
  child: Container(
    width: MediaQuery.of(context).size.width * 0.55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      children: [
        const Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(
                'asset/images/Red Yellow Simple Delicious Fried Chicken Instagram Story 1.png',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Oatmeal with Fruits & Nuts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              const Text(
                'Calories: 307 | Protein: 42g | Carbs: 24g',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add  ➕",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  ),
);
Widget dinnerItem(context)=> GestureDetector(
  onTap: (){
    navigateTo(context, const MealDetailsScreen());
  },
  child: Container(
    width: MediaQuery.of(context).size.width * 0.55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      children: [
        const Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(
                'asset/images/Red Yellow Simple Delicious Fried Chicken Instagram Story 1.png',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Oatmeal with Fruits & Nuts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              const Text(
                'Calories: 307 | Protein: 42g | Carbs: 24g',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add  ➕",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  ),
);
Widget extraItem(context)=> GestureDetector(
  onTap: (){
    navigateTo(context, const MealDetailsScreen());
  },
  child: Container(
    width: MediaQuery.of(context).size.width * 0.55,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 8,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      children: [
        const Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(15),topRight: Radius.circular(15)),
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage(
                'asset/images/Red Yellow Simple Delicious Fried Chicken Instagram Story 1.png',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Oatmeal with Fruits & Nuts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              const Text(
                'Calories: 307 | Protein: 42g | Carbs: 24g',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: defaultColor,
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Add  ➕",
                    style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    ),
  ),
);
