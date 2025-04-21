import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/chat_bot_screen.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/edit_data_screen.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/faqs_screen.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/lang_screen.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/support_screen.dart';
import 'package:heaaro_company/shared/components.dart';
import '../../../core/config.dart';
import '../../../shared/constants.dart';
import '../../../shared/local/cacheHelper.dart';

class EditScreen extends StatelessWidget {

  const EditScreen({super.key});

  Widget buildCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 65,
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 26, color: defaultColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Icon(isArabic ? FluentIcons.arrow_left_12_filled :FluentIcons.arrow_right_12_filled , color: Colors.grey),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.white),
          elevation: 0,
          title: Text(
            '${Config.localization['settings_title'] ?? 'Settings'}',
            style: TextStyle(color: defaultColor, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${Config.localization['personalize_experience'] ?? 'Personalize your experience'}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 20),

              buildCard(
                context: context,
                icon: FluentIcons.bot_sparkle_32_regular,
                title: '${Config.localization['chat_bot'] ?? 'ChatBot'}',
                onTap: () => navigateTo(context, const ChatBotScreen()),
              ),

              buildCard(
                context: context,
                icon: FluentIcons.edit_person_24_regular,
                title: '${Config.localization['edit_personal_data'] ?? 'Edit Personal Data'}',
                onTap: () => navigateTo(context, const EditDataScreen()),
              ),

              buildCard(
                context: context,
                icon: FluentIcons.question_32_regular,
                title: '${Config.localization['faqs'] ?? 'FAQs'}',
                onTap: () => navigateTo(context, const FAQsScreen()),
              ),

              buildCard(
                context: context,
                icon: FluentIcons.person_support_32_regular,
                title: '${Config.localization['support'] ?? 'Support'}',
                onTap: () => navigateTo(context, const SupportScreen()),
              ),

              buildCard(
                context: context,
                icon: FluentIcons.local_language_28_regular,
                title: '${Config.localization['language'] ?? 'Language'}',
                onTap: () => navigateTo(context, const LangScreen()),
              ),

              const SizedBox(height: 30),

              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: TextButton.icon(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    icon: const Icon(FluentIcons.inprivate_account_24_regular, color: Colors.white),
                    label: Text(
                      '${Config.localization['delete_account'] ?? 'Delete Account'}',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
