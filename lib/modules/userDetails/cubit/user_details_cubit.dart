
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/userDetailsModel.dart';
import 'package:heaaro_company/modules/userDetails/cubit/user_details_state.dart';


class UserDetailsCubit extends Cubit<UserDetailsState> {
  UserDetailsCubit() : super(UserDetailsInitial());
  static UserDetailsCubit get(context) => BlocProvider.of(context);
  UserDetailsModel? userDetailsModel;

  void addUserDetails({
    required String age,
    required String weight,
    required String height,
    required String health,
}){
    emit(UserDetailsAddedLoadingState());
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(UserDetailsGetErrorState());
      return;
    }
    userDetailsModel = UserDetailsModel(age, health, height, weight);
    FirebaseFirestore.instance.collection('users')
    .doc(userId).collection('details').doc(userId).set(userDetailsModel!.toMap()).then((onValue){
      getUserDetails();
      emit(UserDetailsAddedSuccessState());
    }).catchError((onError){
      emit(UserDetailsAddedErrorState());
    });
  }


  void getUserDetails() {
    emit(UserDetailsGetLoadingState());
    final String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      emit(UserDetailsGetErrorState());
      return;
    }

    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('details')
        .doc(userId)
        .get()
        .then((DocumentSnapshot snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        userDetailsModel = UserDetailsModel.fromJson(snapshot.data() as Map<String, dynamic>);
        emit(UserDetailsGetSuccessState());
      } else {
        emit(UserDetailsGetErrorState());
      }
    })
        .catchError((error) {
      emit(UserDetailsGetErrorState());
    });
  }



}
