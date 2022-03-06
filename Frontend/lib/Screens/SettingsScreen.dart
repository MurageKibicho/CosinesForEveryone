// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace, prefer_const_literals_to_create_immutables, non_constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:version2/SharedWidgets/SharedTextWidgets.dart';

import '../Providers/Settings.dart';
import 'HomeScreen.dart';
import 'SignupScreen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final settingsClass = Provider.of<Settings>(context);
    return Material(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Container(
            height: screenHeight,
            width: screenWidth,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children:<Widget>
                    [
                      SizedBox(height: 10,),
                      ExitButtonTitle(50,screenWidth,context),
                      GeneralTitle("General Settings",50,screenWidth),
                      GeneralSettings(settingsClass.email,context,50, screenWidth),
                      SizedBox(height: 20,),
                      GeneralTitle("Mining History",50,screenWidth),
                      ApprovedImages(3,"Approved Images",200, screenWidth),
                      Divider(height: 20, thickness: 2,color: Colors.black,),
                      ApprovedImages(3,"Pending Images",200, screenWidth),
                      Divider(height: 20, thickness: 1,),


                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    height: screenHeight*0.7,
                    width: screenWidth,
                    color: Colors.black.withOpacity(0.1),
                    child: Center(child: Text("Under construction", style: TextStyle(color: Colors.white,fontSize: 30),)),
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

Widget GeneralTitle(String title, double height, double screenWidth)
{
  return Container(
    height: height,
    width: screenWidth,
    child: Column(
      children:<Widget>[
        Text(title),
        Divider(height: 20, thickness: 2,color: Colors.black,)
      ],
    ),
  );
}



Widget GeneralSettings(String email,BuildContext context,double height, double screenWidth)
{
  return Column(
    children: [
      Container(
        height: height,
        width: screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                  "Email address: "
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right:8.0),
              child: Text(
                  email,
              ),
            ),
          ],
        ),
      ),
      Divider(height: 20, thickness: 1,),
      GestureDetector(
        onTap: ()
        {
          ShowPasswordDialog(context);
        },
        child: Container(
          height: height,
          width: screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:<Widget>[
              Padding(
                padding: EdgeInsets.only(left:20.0),
                child: Text("Change Password",),
              ),
              Padding(
                padding: EdgeInsets.only(right:8.0),
                child: Icon(
                  Icons.arrow_forward_ios,
                ),
              ),

            ],
          ),
        ),
      ),
      Divider(height: 20, thickness: 2,color: Colors.black,)
    ],
  );
}

ShowPasswordDialog(BuildContext context)
{
  final previousController = TextEditingController();
  final newController = TextEditingController();
  final confirmController = TextEditingController();
  AlertDialog alert = AlertDialog(
    insetPadding: EdgeInsets.only(bottom: 50,top: 50),
    title: Text("Change Password",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20,color: Colors.black)),
    content: SingleChildScrollView(
      child: Column(
        children: [
          CustomTextEntry("Old Password",Colors.black,"Previous password",true,previousController),
          CustomTextEntry("New Password",Colors.black,"New password at least 8 characters",true,newController),
          CustomTextEntry("Confirm Password",Colors.black,"Confirm new password",true,confirmController),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: (){
        Navigator.of(context, rootNavigator: true).pop();
      }, child: Text("Cancel")),
      TextButton(onPressed: (){
        bool isPasswordLong = ValidatePasswordLength(newController.text);
        bool passwordsMatch = ValidateMatchingPasswords(newController.text, confirmController.text);
        if(isPasswordLong == false || passwordsMatch == false)
          {
            newController.clear();
            confirmController.clear();
            previousController.clear();
          }
      }, child: Text("Submit"))
    ],
  );

  showDialog(context: context,
      builder: (context)
      {
        return alert;
      });
}

Widget ExitButtonTitle(double arrowHeight, double screenWidth, BuildContext context)
{
  return Container(
    padding: EdgeInsets.only(left: 20,bottom: 20),
    height: arrowHeight,
    width: screenWidth,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
          },
          child: Row(
            children:<Widget>[
              Icon(
                Icons.arrow_back_ios,
                color: Color(0xffe46b10),
              ),
              Text("Exit",style: TextStyle(color: Color(0xffe46b10),fontSize: 20),),
            ],
          ),
        ),


      ],
    ),
  );
}

Widget ApprovedImages(int length,String title, double height, double screenWidth)
{
  return Container(
    height: height,
    width: screenWidth,
    child: Column(
      children: [
        Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15,color: Colors.black)),
        SizedBox(
          height: 10,
        ),
        Expanded(
          child: ListView.builder(
              itemCount: length,
              padding: EdgeInsets.only(left: 16, right: 16),
              shrinkWrap: true,
              itemBuilder: (context, index)
              {
                return Container(
                  height: 100,
                  width: screenWidth,
                  margin: EdgeInsets.only(bottom: 13),
                  padding: EdgeInsets.only(left: 24, right: 12, top:12,bottom:12),
                  decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Color(0xffe46b10)),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Wrap(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:<Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                              children:<Widget>[
                                Text("ID: "),
                                Text("Date: "),
                                Text("Miners: "),
                              ],
                          ),
                          Column(
                            children: [
                              Text("+255§"),
                              Text("Reward"),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
          ),
        ),
      ],
    ),
  );
}

