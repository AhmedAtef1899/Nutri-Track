
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/core/config.dart';
import 'package:heaaro_company/model/userDetailsModel.dart';
import 'package:heaaro_company/shared/local/cacheHelper.dart';
import 'edit_state.dart';

class EditCubit extends Cubit<EditState> {
  EditCubit() : super(EditInitial());
  static EditCubit get(context) => BlocProvider.of(context);


  UserDetailsModel? userDetailsModel;

  getUserData()
  {
    emit(GetLoading());
    FirebaseFirestore.instance.collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('details')
        .doc(FirebaseAuth.instance.currentUser!.uid).get().then((onValue) {
          userDetailsModel = UserDetailsModel.fromJson(onValue.data() as Map<String, dynamic>);
          emit(GetSuccess());
    }).catchError((onError) {
      emit(GetError());
    });
  }

  updateUserData({
    required String weight,
    required String height,
    required String age,
    required String health,
    required String gender,
    required String bmi,
  })
  {
    emit(UpdateLoading());
    userDetailsModel = UserDetailsModel(age, health, height, weight, gender,bmi);
    FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid)
    .collection('details').doc(FirebaseAuth.instance.currentUser!.uid)
        .update(userDetailsModel!.toMap())
        .then((onValue){
      emit(UpdateSuccess());
    }).catchError((onError){
      print(onError.toString());
      emit(UpdateError(error: onError));
    });
  }

  void changeLange(String lang){
    Config.loadLanguage(lang);
    CacheHelper.saveData(key: 'lang', value: lang);
    emit(ChangeLangState());
  }
}
