import 'package:flutter/material.dart';
import '../../../../core/config.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/local/cacheHelper.dart';

class FAQsScreen extends StatelessWidget {
  const FAQsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': Config.localization['faqs_'][0]['question'] ?? 'How do I track my meals?',
        'answer': Config.localization['faqs_'][0]['answer'] ?? 'Go to the “Nutrition” section and add each meal manually by selecting foods from the database or scanning a barcode.'
      },
      {
        'question': Config.localization['faqs_'][1]['question'] ?? 'Can I customize my daily calorie goal?',
        'answer': Config.localization['faqs_'][1]['answer'] ?? 'Yes, head to the Settings > Edit Personal Data and set your custom calorie, protein, and macro goals.'
      },
      {
        'question': Config.localization['faqs_'][2]['question'] ?? 'How do I reset my progress?',
        'answer': Config.localization['faqs_'][2]['answer'] ?? 'Currently, you can reset data by going to Settings > Delete Account or contacting support.'
      },
      {
        'question': Config.localization['faqs_'][3]['question'] ?? 'Does the app support intermittent fasting?',
        'answer': Config.localization['faqs_'][3]['answer'] ?? 'Yes! Enable the fasting tracker from Settings and set your fasting windows.'
      },
    ];

    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(Config.localization['faqs'] ?? 'FAQs', style: TextStyle(color: defaultColor)),
          iconTheme: IconThemeData(color: defaultColor),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.separated(
            itemCount: faqs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = faqs[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ExpansionTile(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  title: Text(
                    item['question']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                      child: Text(
                        item['answer']!,
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
