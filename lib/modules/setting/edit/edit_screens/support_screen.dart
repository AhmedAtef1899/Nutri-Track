
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heaaro_company/core/config.dart';
import 'package:heaaro_company/shared/components.dart';
import 'package:heaaro_company/shared/constants.dart';

import '../../../../shared/local/cacheHelper.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final bool isArabic = CacheHelper.getData(key: 'lang') == "Arabic";
    return Directionality(
      textDirection: isArabic? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title:  Text(
            '${Config.localization['support'] ?? 'Support'}'
          ),
        ),
        body:  SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                defaultForm(label: '${Config.localization['app_number'] ?? 'Whats app Number'}',
                    type: TextInputType.number,
                    controller: TextEditingController(),
                    prefix: CupertinoIcons.phone_circle,
                    validate: (value){
                      return null;
                    }
                ),
                const SizedBox(height: 8,),
                TextFormField(
                  validator: (value){
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: '${Config.localization['problem'] ?? 'Describe your Problem...'}',
                    prefixIcon: const Icon(FluentIcons.person_support_28_regular),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(
                        color: Colors.transparent
                      ),
                    ),
                    fillColor: Colors.white
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 20,),
                defaultButton(background: defaultColor,
                    text: '${Config.localization['send'] ?? 'Send'}',
                    function: (){}
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
