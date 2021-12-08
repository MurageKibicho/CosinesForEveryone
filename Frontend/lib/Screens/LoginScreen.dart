// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'package:cosines_for_everyone/ClipPaths/HomeClipContainer.dart';
import 'package:cosines_for_everyone/Networking/LoginAndSignup.dart';
import 'package:cosines_for_everyone/Providers/Settings.dart';
import 'package:cosines_for_everyone/Screens/HomeScreen.dart';
import 'package:cosines_for_everyone/Screens/SignupScreen.dart';
import 'package:cosines_for_everyone/SharedWidgets/SharedTextWidgets.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String emailAddress = "";
  String password = "";

  bool isValidEmail = true;
  bool isPasswordLong = true;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final settingsClass = Provider.of<Settings>(context);
    return Scaffold(
      body: Material(
        child: Container(
          height: screenHeight,
          width: screenWidth,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -50.h,
                  left: -50.w,
                  child: HomeClipContainer(height: 200.0.h,width: 200.0.w,color1: Color(0xfffbb448),color2:Color(0xffe46b10)),
              ),
              Positioned(
                top: 200.h,
                left: 0.w,
                right: 0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>
                  [
                    TitleWidget(),
                    SizedBox(height: 50.h,),
                    EmailAndPasswordInput(Colors.black,emailController, passwordController, isValidEmail),
                    SizedBox(height: 50.h,),
                    GestureDetector(
                        onTap: () async
                        {
                          setState(() {
                            emailAddress = emailController.text;
                            password = passwordController.text;

                            isValidEmail = EmailValidator.validate(emailAddress);
                            isPasswordLong = ValidatePasswordLength(password);
                            if(isValidEmail == false || isPasswordLong == false)
                            {
                              emailController.clear();
                              passwordController.clear();
                            }
                          });
                          var res = await AttemptLogin(emailAddress,password);
                          if(res == "400")
                            {
                              print("Error");
                            }
                          else
                            {
                              var parsed = json.decode(res);
                              settingsClass.setJWT(parsed['jwt']);
                              settingsClass.setAccountBalance(parsed['currentBalance']);
                              settingsClass.setEmail(parsed['email']);
                              settingsClass.setAccountNumber(parsed['accountNumber']);
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()),(Route<dynamic> route) => false);

                            }
                        },
                        child: SubmitButton("Log In",screenWidth.w,60.h),),
                    SizedBox(height: 30.h,),
                    NewAccountButton(screenWidth.w,60.h,context),
                  ],
                ),
              ),
            ],
          ),

        ),
      ),
    );
  }
}

Widget TitleWidget()
{
  return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Cosines",
        style: TextStyle(
          fontSize: 30.sp,
          fontWeight: FontWeight.w700,
          color: Color(0xffe46b10),
        ),
        children:
        [
          TextSpan(
            text: " for ",
            style: TextStyle(color: Colors.black,fontSize: 30.sp),
          ),
          TextSpan(
            text: "Everyone",
            style: TextStyle(color: Color(0xffe46b10),fontSize: 30.sp),
          ),
        ],
      ),
  );
}


Widget SubmitButton(String buttonText,double width, double height)
{
  return Container(
    height: height,
    width: width*0.8,
    padding: EdgeInsets.all(15.sp),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5.sp)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          offset: Offset(2.w,4.h),
          blurRadius: 5,
          spreadRadius: 2,
        ),
      ],
      gradient: LinearGradient(
        colors: [Color(0xfffbb448),Color(0xffe46b10)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
    child: Text(
      "Log In",
      style: TextStyle(fontSize: 15.sp, color: Colors.white),
    ),
  );
}

Widget NewAccountButton(double screenWidth,double height, BuildContext context)
{
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(screenWidth*0.8,height),
      primary: Color(0xffe46b10),
      side: BorderSide(width: 0, color:Colors.white),
    ),
    onPressed: (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignupScreen()),(Route<dynamic> route) => false);
    },
    child: Text("New User? Create an account"),
  );
}





