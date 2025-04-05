

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/authModel.dart';
import 'package:heaaro_company/modules/auth_screen/cubit/states.dart';
import 'package:heaaro_company/modules/auth_screen/login/login.dart';
import 'package:heaaro_company/shared/constants.dart';
import '../../../shared/components.dart';

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
      emit(AuthLoginErrorState(error: onError.toString()));
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
      emit(AuthRegisterErrorState(error: onError.toString()));
    });
  }

  void createRegister({
    required String email,
    required String password,
    required String name,
    required String location,
    required String uId,
  })
  {
    authModel = AuthModel(name, location, email, password, uId);
    FirebaseFirestore.instance.collection('users').doc(uId).set(authModel!.toMap()).then((onValue){
      print('User Created');
    }).catchError((onError){
      print(onError.toString());
    });
  }

  final TextEditingController emailController = TextEditingController();

  Future<void> sendResetCode(BuildContext context) async {
    if (emailController.text.isEmpty) {
      showSnackBar(title: "Error", msg: "Email cannot be empty", type: ContentType.failure, context: context);
      return;
    }
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      navigateAndFinish(context, const LoginScreen());
      emit(AuthSuccess());
    } catch (error) {
      print("Reset Code Error: ${error.toString()}");
      emit(AuthError());
    }
  }

  bool isVisible = true;
  void changeVisible(){
    isVisible = !isVisible;
    emit(IsVisibleState());
  }
}

