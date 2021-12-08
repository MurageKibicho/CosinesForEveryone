
// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_constructors

import 'package:flutter/material.dart';

Widget EmailAndPasswordInput(Color titleColor, TextEditingController emailController, TextEditingController passwordController, bool isValidEmail)
{
  late String emailHint;
  if(isValidEmail == true)
  {
    emailHint = "morio@gmail.com";
  }
  else
  {
    emailHint = "Invalid email address";
  }
  return Column(
    children:<Widget>[
      CustomTextEntry("Email Address",titleColor,emailHint,false,emailController),
      SizedBox(height: 10,),
      CustomTextEntry("Password",titleColor,"Password must have at least 8 characters",true,passwordController),
    ],
  );
}

Widget CustomTextEntry(String title, Color titleColor, String hintText, bool passwordEntry, TextEditingController controller)
{
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: titleColor),
        ),
        SizedBox(
          height: 10,
        ),
        TextField(
          obscureText: passwordEntry,
          controller: controller,
          decoration: InputDecoration(
              border: InputBorder.none,
              fillColor: Color(0xfff3f3f4),
              filled: true,
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 12,
              )
          ),
        ),
      ],
    ),
  );
}