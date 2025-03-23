


import 'package:flutter/material.dart';
import 'package:heaaro_company/shared/constants.dart';

class ExtraScreen extends StatelessWidget {
  const ExtraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meal Details", style: TextStyle(color: Colors.green)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset("asset/images/White and Green Minimalist Lunch Time Natural Food Instagram Story 1.png", fit: BoxFit.cover),
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                "Easy - Healthy",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _infoChip("550 Calories", Colors.green.shade100, Colors.green),
                _infoChip("29% Protein", Colors.blue.shade100, Colors.blue),
                _infoChip("27% Carbs", Colors.orange.shade100, Colors.orange),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.shade300, blurRadius: 5),
                ],
              ),
              child: Column(
                children: [
                  _buildTableHeader(),
                  _buildTableRow("Oatmeal", "150Cal", "20g", "6g"),
                  _buildTableRow("Fruit", "150Cal", "20g", "6g"),
                  _buildTableRow("Nuts", "150Cal", "20g", "6g"),
                ],
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: defaultColor,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: const Text("Meal Completed  🤝", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, Color bgColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Chip(
        backgroundColor: bgColor,
        label: Text(label, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildTableHeader() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text("Ingredients", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text("Calories", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text("Protein", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text("Carbs", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        ],
      ),
    );
  }

  Widget _buildTableRow(String ingredient, String calories, String protein, String carbs) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(ingredient),
          Text(calories),
          Text(protein),
          Text(carbs),
        ],
      ),
    );
  }
}