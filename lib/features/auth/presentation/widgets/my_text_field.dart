import 'package:flutter/material.dart';
class MyTextField extends StatelessWidget {
  const MyTextField({this.fillColor,super.key, required this.controller, required this.hintText, required this.obscureText, required this.keyboardType,this.textInputAction, this.suffixIcon, this.onTap, this.prefixIcon, this.validator, this.focusNode, this.errorMsg, this.onChange, this.border});

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final Widget? prefixIcon;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorMsg;
  final Color? fillColor;
  final OutlineInputBorder? border;
  final void Function(String)? onChange;
  final TextInputAction? textInputAction;




  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
        obscureText: obscureText,
      keyboardType: keyboardType,
      focusNode: focusNode,
      onTap: onTap,
      onChanged: onChange,
      autofocus: false,
      textInputAction: textInputAction ?? TextInputAction.next,

      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        border:  border,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.transparent),
        ),focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
      ),
        fillColor:fillColor ??  Colors.grey.shade200,
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.grey[500]),
        errorText: errorMsg
      ),
    );
  }
}
