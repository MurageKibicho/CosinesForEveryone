// ignore_for_file: use_key_in_widget_constructors, file_names, sized_box_for_whitespace, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, prefer_final_fields

import 'dart:convert';

import 'package:cosines_for_everyone/ClipPaths/HomeClipContainer.dart';
import 'package:cosines_for_everyone/Networking/LoginAndSignup.dart';
import 'package:cosines_for_everyone/Providers/Settings.dart';
import 'package:cosines_for_everyone/SharedWidgets/SharedTextWidgets.dart';
import 'package:country_list_pick/country_list_pick.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'HomeScreen.dart';
import 'LoginScreen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  String name = " ";
  String emailAddress = "";
  String password = "";
  String confirm = "";
  String nationality = "Indonesia";
  String dateOfBirth = "00/ 00/ 00";
  String jwt = "";
  bool isValidEmail = true;
  bool isPasswordLong = true;
  bool passwordsMatch = true;

  DateTime currentDate = DateTime.now();
  DateTime date = DateTime.now();
  MaterialColor white =  MaterialColor(
    0xFFFFFFFF,
    const <int, Color>{
      50:  Color(0xFFFFFFFF),
      100: Color(0xFFFFFFFF),
      200: Color(0xFFFFFFFF),
      300: Color(0xFFFFFFFF),
      400: Color(0xFFFFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );

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
          color: Color(0xffe46b10),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: -50.h,
                left: -50.w,
                child: HomeClipContainer(height: 200.0.h,width: 200.0.w,color1: Colors.white,color2: Colors.white),
              ),
              Positioned(
                top: 150.h,
                left: 0.w,
                right: 0.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>
                  [
                    TitleWidget(),
                    CustomTextEntry("Name",white,"morio kibicho",false,nameController),
                    SizedBox(height: 10,),
                    EmailAndPasswordInput(Colors.white,emailController, passwordController, isValidEmail),
                    SizedBox(height: 10,),
                    CustomTextEntry("Confirm Password",white,"Passwords do not match",true,confirmController),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        SizedBox(width: 20,),
                        Text("Pick your country",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),),
                        SizedBox(width: 20,),
                        Theme(//Had trouble setting country state
                          data: ThemeData(
                            primarySwatch: white,
                          ),
                          child: CountryListPick(
                            theme: CountryTheme(
                              isShowFlag: true,
                              isShowTitle: true,
                              isShowCode: false,
                              isDownIcon: true,
                              showEnglishName: false,
                              labelColor: Color(0xffe46b10),
                              alphabetSelectedBackgroundColor: Color(0xfffbb448),
                              alphabetTextColor: Colors.black,
                            ),
                            initialSelection: '+62',
                            onChanged: (code)
                            {
                              var result = code!.name;
                              setState(() {
                                nationality = (result.toString());
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                        onTap: ()async
                        {
                         final DateTime? dob = await showDatePicker
                            (
                              context: context,
                              firstDate: DateTime(1900,1,1),
                              lastDate: DateTime(currentDate.year - 18),
                              initialDate: DateTime(currentDate.year - 19),
                              initialEntryMode: DatePickerEntryMode.input,
                              errorFormatText: 'Invalid date format',
                              errorInvalidText: 'You must be over 18',
                            );
                         if(dob != null)
                           {
                             setState(() {
                               date = dob;
                               dateOfBirth = date.year.toString() + "/" + date.day.toString() + "/" + date.month.toString();
                             });
                           }
                        },
                        child: DateOfBirth(dateOfBirth, 50, screenWidth)),
                    GestureDetector(
                        onTap: () async
                        {
                          setState(() {
                            name = nameController.text;
                            emailAddress = emailController.text;
                            password = passwordController.text;
                            confirm = confirmController.text;

                            isValidEmail = EmailValidator.validate(emailAddress);
                            isPasswordLong = ValidatePasswordLength(password);
                            passwordsMatch = ValidateMatchingPasswords(password, confirm);
                            if(isValidEmail == false || isPasswordLong == false || passwordsMatch == false)
                              {
                                emailController.clear();
                                passwordController.clear();
                                confirmController.clear();
                              }
                          });
                          if(dateOfBirth == "00/ 00/ 00")
                            {
                              setState(() {
                                dateOfBirth = "Tap to pick date";
                              });
                            }
                          else if(isValidEmail == false)
                            {
                              print("invalid email");
                            }
                          else if(isPasswordLong == false)
                          {
                            print("too short");
                          }
                          else if(passwordsMatch == false)
                          {
                            print("NO MATCH");
                          }
                          else
                            {
                            var res = await AttemptSignUp(name, emailAddress,password, nationality, dateOfBirth);
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
                          }
                        },
                        child: SubmitButton(screenWidth,50)),

                    AlreadyLoginButton(screenWidth,50,context),
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
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
      children:
      [
        TextSpan(
          text: " for ",
          style: TextStyle(color: Colors.black,fontSize: 30),
        ),
        TextSpan(
          text: "Everyone",
          style: TextStyle(color: Colors.white,fontSize: 30),
        ),
      ],
    ),
  );
}

Widget DateOfBirth(String date, double height, double screenWidth)
{
  return Container(
    padding: EdgeInsets.only(left: 16,bottom: 16),
    height: height,
    width: screenWidth,
    color: Color(0xffe46b10),
    child: Row(
      children: <Widget>[
        Text(" Date of Birth: ",style: TextStyle(fontSize: 15, color: Colors.white)),
        SizedBox(width: screenWidth/5,),
        Text(date,style: TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold)),
      ],
    ),
  );
}



Widget SubmitButton(double width, double height)
{
  return Container(
    height: height,
    width: width*0.8,
    padding: EdgeInsets.all(15),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Colors.white,
    ),
    child: Text(
      "Sign Up",
      style: TextStyle(fontSize: 15, color: Color(0xffe46b10)),
    ),
  );
}

Widget AlreadyLoginButton(double screenWidth,double height, BuildContext context)
{
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(screenWidth*0.8,height),
      primary: Colors.white,
      side: BorderSide(width: 5, color:Color(0xffe46b10)),
    ),
    onPressed: (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(Route<dynamic> route) => false);
    },
    child: Text("Have an Account? Log In"),
  );
}

bool ValidatePasswordLength(String password)
{
  if(password.length < 8)
    {
      return false;
    }
  else
    {
      return true;
    }
}

bool ValidateMatchingPasswords(String password, String confirm)
{
  if(password == confirm)
    {
      return true;
    }
  else
    {
      return false;
    }
}




