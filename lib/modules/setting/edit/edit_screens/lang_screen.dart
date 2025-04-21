import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/core/config.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/cubit/edit_cubit.dart';
import 'package:heaaro_company/modules/setting/edit/edit_screens/cubit/edit_state.dart';
import 'package:heaaro_company/shared/local/cacheHelper.dart';
import 'package:restart_app/restart_app.dart';

class LangScreen extends StatelessWidget {
  const LangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var selectedLang = CacheHelper.getData(key: 'lang') ?? 'English';
    List<String> languages = [
      'English',
      'Arabic'
    ];
    return BlocProvider(
      create: (context) => EditCubit(),
      child: BlocConsumer<EditCubit, EditState>(
        listener: (context, state) {
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                  '${Config.localization['change']}'
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedLang,
                    decoration: InputDecoration(
                      labelText: 'Language',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: languages.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value[0].toUpperCase() + value.substring(1),
                          style: const TextStyle(
                              fontSize: 17, color: Colors.blue),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        selectedLang = newValue;
                        EditCubit.get(context).changeLange(newValue);
                        Restart.restartApp();
                      }
                    },
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
