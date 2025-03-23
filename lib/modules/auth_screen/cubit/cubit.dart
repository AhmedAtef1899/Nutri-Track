

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/authModel.dart';
import 'package:heaaro_company/modules/auth_screen/cubit/states.dart';
import 'package:heaaro_company/shared/constants.dart';

class AuthCubit extends Cubit<AuthStates> {
  AuthCubit() : super(AuthInitial());
  static AuthCubit get(context) => BlocProvider.of(context);


  void login({
    required String email,
    required String password,
}){
    emit(AuthLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((onValue){
      uId = onValue.user!.uid;
      emit(AuthLoginSuccessState());
    }).catchError((onError){
      emit(AuthLoginErrorState());
    });
  }

  AuthModel? authModel;

  void register({
    required String email,
    required String password,
    required String name,
    required String location,
  }){
    emit(AuthRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((onValue){
      createRegister(email: email, password: password, name: name, location: location, uId: onValue.user!.uid);
      uId = onValue.user!.uid;
      emit(AuthRegisterSuccessState());
    }).catchError((onError){
      emit(AuthRegisterErrorState());
    });
  }

  void createRegister({
    required String email,
    required String password,
    required String name,
    required String location,
    required String uId,
  }){
    authModel = AuthModel(name, location, email, password, uId);
    FirebaseFirestore.instance.collection('users').doc(uId).set(authModel!.toMap()).then((onValue){
      print('User Created');
    }).catchError((onError){
      print(onError.toString());
    });
  }

}

