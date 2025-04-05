
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heaaro_company/model/addMealModel.dart';
import 'package:heaaro_company/modules/report/report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitial());
  static ReportCubit get(context) => BlocProvider.of(context);


  List<AddMealModel> report = [];

  void getReports(){
    emit(GetReportLoading());
    String uId = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('users')
    .doc(uId).collection('completed').get().then((onValue){
      report = [];
      for (var action in onValue.docs) {
        report.add(AddMealModel.fromJson(action.data()));
      }
      emit(GetReportSuccess());
    }).catchError((onError){
      emit(GetReportError());
    });
  }
}
