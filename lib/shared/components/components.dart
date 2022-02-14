import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, widget) => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ),
    (route) => false);

Widget defaultTextButton({
  required Function() onPressed,
  required String text,
}) =>
    TextButton(
      onPressed: onPressed,
      child: Text(
        text,
      ),
    );

Widget elevatedButtonBuilder(
        {Function()? onPressed, required String text, double? width}) =>
    ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        )),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
        fixedSize: MaterialStateProperty.all<Size?>(Size(width!, 40.0)),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 18.0),
      ),
    );

Widget defaultButton({
  Function()? onPressed,
  String? text,
}) =>
    Container(
      width: double.infinity,
      height: 40,
      child: MaterialButton(
        color: Colors.blue,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(
          text!,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.blue,
      ),
    );

Widget defaultTextFormField({
  required TextEditingController controller,
  required TextInputType type,
  required String label,
  required IconData prefix,
  required String? validate(String? value),
  IconData? suffix,
  bool isPassword = false,
  Function()? suffixPressed,
  Function()? onTap,
  Function? onChange(String? val)?,
  Function? onSubmitted(String? val)?,
}) =>
    TextFormField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        label: Text(label),
        prefixIcon: Icon(prefix),
        suffixIcon: IconButton(
          onPressed: suffixPressed,
          icon: Icon(suffix),
        ),
        border: const OutlineInputBorder(),
      ),
      obscureText: isPassword,
      validator: validate,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      onChanged: onChange,
    );

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  IconData? icon,
  List<Widget>? actoins,
}) => AppBar(
      title: Text(
        title!,
      ),
      titleSpacing: 0.0,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(icon)),
      actions: actoins,
    );

PreferredSizeWidget? defaultAppBarr({
  String? text,
  Widget? leading,
  List<Widget>? actions,
  required BuildContext context,
}) =>
    AppBar(
      titleSpacing: 0.0,
      leading: leading == null ? null : leading,
      title: Padding(
        padding: const EdgeInsetsDirectional.only(start: 20.0),
        child: Text(
          text!,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20.0),
        ),
      ),
      actions: actions,
    );

Widget defaultFormField(
        {onTap,
        required TextInputType type,
        String? label,
        required IconData prefix,
        required TextEditingController controller,
        IconData? suffix,
        bool isPassword = false,
        bool isClickable = true,
        onChanged,
        validate,
        onFieldSubmitted,
        suffixPassword,
        InputBorder? border}) =>
    TextFormField(
      obscureText: isPassword,
      controller: controller,
      keyboardType: type,
      onFieldSubmitted: onFieldSubmitted,
      validator: validate,
      onChanged: onChanged,
      onTap: onTap,
      enabled: isClickable,
      cursorHeight: 20.0,
      decoration: InputDecoration(
        border: border,
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPassword,
              )
            : null,
        labelText: label,
        prefixIcon: Icon(prefix),
      ),
    );

void showToast({
  required String text,
  required ToastStates states,
}) {
  Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: changeToastColor(states),
      textColor: Colors.white,
      fontSize: 16.0);
}

enum ToastStates { SUCCESS, ERROR, WREAD }

Color changeToastColor(ToastStates states) {
  Color color;
  switch (states) {
    case ToastStates.SUCCESS:
      return color = Colors.green;
      break;
    case ToastStates.ERROR:
      return color = Colors.red;
      break;
    case ToastStates.WREAD:
      return color = Colors.yellow;
      break;
  }
  return color;
}

Widget myDivider() => Divider(
      height: 1,
      color: Colors.grey[300],
      indent: 20,
      endIndent: 20,
    );
