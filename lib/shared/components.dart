

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';




Widget defaultButton({
  double width = double.infinity,
  double height = 60,
  required Color background,
  double radius = 100,
  required String text,
  required Function() function,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: background,
      ),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          text,
          maxLines: 1,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );


Widget defaultForm(
    {required String label,
      IconData? prefix,
      BuildContext? context,
      required TextInputType type,
      required TextEditingController controller,
      required FormFieldValidator validate,
      Function()? onTap,
      List<FilteringTextInputFormatter>? formatters,
      bool isVisible = false,
      IconData? suffix,
      Function()? suffixPressed,
      Function(String value)? onSubmit,
      bool enable = true,
      Function(String value)? onChange,
      double height = 68,
      double radius = 24}) =>
    Container(
      alignment: Alignment.centerLeft,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: Colors.white,
      ),
      child: TextFormField(
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIconColor: Colors.grey,
          suffixIconColor: Colors.grey,
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontWeight: FontWeight.w400,
            fontSize: 15,
          ),
          prefixIcon: Icon(prefix),
          suffixIcon: suffix != null
              ? IconButton(
            onPressed: suffixPressed,
            icon: Icon(suffix),
          )
              : null,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onFieldSubmitted: onSubmit,
        obscureText: isVisible,
        keyboardType: type,
        controller: controller,
        validator: validate,
        onTap: onTap,
        enabled: enable,
        inputFormatters: formatters,
        onChanged: onChange,
      ),
    );



Widget line()=> Padding(
  padding: const EdgeInsets.all(20),
  child:   Container(
    height: 1,
    color: Colors.grey[600],
  ),
);

void navigateTo(context,widget) =>   Navigator.push(
    context,
    MaterialPageRoute(builder:
        (context)=> widget)
);

void navigateAndFinish(context,widget) =>   Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder:
        (context)=> widget),
        (route){
      return false;
    }
) ;

// void showToast({required String msg, ToastState? state}) =>  Fluttertoast.showToast(
//     msg: msg,
//     toastLength: Toast.LENGTH_LONG,
//     gravity: ToastGravity.BOTTOM,
//     timeInSecForIosWeb: 5,
//     backgroundColor: chooseToastColor(state!),
//     textColor: Colors.white,
//     fontSize: 16.0
// );

//enum

enum ToastState {SUCCESS,ERROR,WARNING}

Color chooseToastColor(ToastState state){
  Color color;
  switch(state)
  {
    case ToastState.SUCCESS:
      color = Colors.green;
      break;
    case ToastState.ERROR:
      color =  Colors.red;
      break;
    case ToastState.WARNING:
      color =  Colors.amber;
      break;
  }
  return color;
}





