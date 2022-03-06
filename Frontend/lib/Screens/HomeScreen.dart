// ignore_for_file: file_names, prefer_const_literals_to_create_immutables, prefer_const_constructors, sized_box_for_whitespace

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:version2/Providers/Settings.dart';
import 'ImageScreen.dart';
import 'LoginScreen.dart';
import 'SettingsScreen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(

         builder: Builder(builder: (context) => HomeShowcase()),
      ),
    );
  }
}



class HomeShowcase extends StatefulWidget {
  @override
  _HomeShowcaseState createState() => _HomeShowcaseState();
}

class _HomeShowcaseState extends State<HomeShowcase> {
  GlobalKey getWorkKey = GlobalKey();
  GlobalKey settingsKey = GlobalKey();
  GlobalKey accountKey = GlobalKey();
  GlobalKey signOutKey = GlobalKey();
  bool showCaseDisplay = true;

  //IOS permissions
  Permission photoPermission = Permission.photos;
  Permission photoAddPermission = Permission.photosAddOnly;
  PermissionStatus _photoStatus = PermissionStatus.denied;
  PermissionStatus _photoAddStatus = PermissionStatus.denied;

  //Android permissions
  Permission storagePermission = Permission.storage;
  Permission externalStoragePermission = Permission.manageExternalStorage;
  PermissionStatus _storageStatus = PermissionStatus.denied;
  PermissionStatus _externalStorageStatus = PermissionStatus.denied;

  Future<void> AskPermission(Permission permission, PermissionStatus _permissionStatus) async
  {
    final status = await permission.request();

    setState(() {
      print(status);
      _permissionStatus = status;
      print(_permissionStatus);
    });
  }

  void CheckShowcase()async
  {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("showcaseDisplay"))
      {
        final result = await prefs.getBool('showcaseDisplay');
        //print("Yes , set to ${showCaseDisplay}");
        setState(() {
          showCaseDisplay = result!;
        });
        print("Yes , set to ${showCaseDisplay}");
      }
    else
      {
        prefs.setBool('showcaseDisplay', true);
        setState(() {
          showCaseDisplay = true;
        });
        print("No , set to ${showCaseDisplay}");
      }
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp)
    {
      print("showCaseDisplay : ${showCaseDisplay}");
      if(showCaseDisplay == true)
      {
        ShowCaseWidget.of(context)!.startShowCase([signOutKey,settingsKey,accountKey,getWorkKey]);
        setState(() {
          showCaseDisplay = false;
        });
        prefs.setBool('showcaseDisplay', false);
      }
    });

  }



  void CheckPermissions() async
  {
    final photoStatus = await photoPermission.status;
    final photoAddStatus = await photoAddPermission.status;

    final storageStatus = await storagePermission.status;
    final externalStorageStatus = await externalStoragePermission.status;
    setState(() {
      _photoAddStatus = photoAddStatus;
      _photoStatus = photoStatus;
      _storageStatus = storageStatus;
      _externalStorageStatus = externalStorageStatus;
    });
  }
  @override
  void initState() {
    CheckPermissions();
      if(Platform.isIOS)
      {
          AskPermission(photoPermission,_photoStatus).then((value){
            AskPermission(photoAddPermission,_photoAddStatus);
          });
      }
      else
        {
          AskPermission(storagePermission,_storageStatus).then((value){
            AskPermission(externalStoragePermission,_externalStorageStatus);
          });
        }
    CheckShowcase();
    super.initState();
  }

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
          child: SafeArea(
            child: Column(
              children:<Widget>[
                SizedBox(height: 20.h),
                TitleSection(50.h, screenWidth),
                Showcase(
                    key:accountKey,
                    description: "Check your current balance and your account number",
                    child: AccountSection(settingsClass.accountBalance, settingsClass.accountNumber,300.h,screenWidth)),
                SizedBox(height: 1.h,),
                Showcase(
                    key: getWorkKey,
                    description: "Tap here to start working",
                    child: GetWorkButton(context, settingsClass.jwt)),
                SizedBox(height: 10.h,),
                Showcase(
                    key: settingsKey,
                    description: "Tap here to change settings",
                    child: SettingsButton(context)),
                SizedBox(height: 5.h,),
                Showcase(
                    key: signOutKey,
                    description: "Tap here to Sign out",
                    child: SignOutButton(context)),
                //SettingsSection(screenHeight/3,screenWidth)
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget GetWorkButton(BuildContext context, String jwt)
{
  //print("HomeScreen: ${jwt}");
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(280.w,100.h),
      primary: Color(0xffe46b10),
      side: BorderSide(width: 3, color:Color(0xffe46b10)),
    ),
      onPressed: ()
      {
        Navigator.push(context, MaterialPageRoute(builder: (context) => ImageScreen(jwt: jwt,)));
      },
      child: Text("Start work"),
  );
}

Widget SignOutButton(BuildContext context)
{
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(200.w,80.h),
      primary: Color(0xffe46b10),
      side: BorderSide(width: 3, color:Color(0xffe46b10)),
    ),
    onPressed: (){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()),(Route<dynamic> route) => false);
    },
    child: Text("Sign Out"),
  );
}

Widget SettingsButton(BuildContext context)
{
  return OutlinedButton(
    style: OutlinedButton.styleFrom(
      minimumSize: Size(220.w,80.h),
      primary: Color(0xffe46b10),
      side: BorderSide(width: 3, color:Color(0xffe46b10)),
    ),
    onPressed: (){
      Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
    },
    child: Text("Settings"),
  );
}

Widget TitleSection(double height,double screenWidth)
{
  return Container(
    height: height,
    width: screenWidth,
    child: Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Cosines",
          style: TextStyle(
            fontSize: 25.sp,
            fontWeight: FontWeight.w700,
            color: Color(0xffe46b10),
          ),
          children:
          [
            TextSpan(
              text: " for ",
              style: TextStyle(color: Colors.black,fontSize: 25.sp),
            ),
            TextSpan(
              text: "Everyone",
              style: TextStyle(color: Color(0xffe46b10),fontSize: 25.sp),
            ),
          ],
        ),
      ),
    ),
  );
}
Widget AccountSection(String currentBalance, String accountNumber, double height, double screenWidth)
{
  return Container(
    height: height,
    width: screenWidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
        SizedBox(height: 1.0.h,),
        Center(
          child: Text("\u0024${currentBalance}.00",style: GoogleFonts.mPlusRounded1c(fontWeight: FontWeight.bold, fontSize: 40.sp)),
        ),
        Center(child: Text("Balance",style: TextStyle(color: Color(0xffe46b10),fontSize: 30.0.sp),),),
        SizedBox(height: 20.h,),
        Center(child: Text("${accountNumber}",style: TextStyle(fontSize: 20.0.sp))),
        Center(child: Text("Account number",style: TextStyle(color: Color(0xffe46b10),fontSize: 30.0.sp),),),
      ],
    ),
  );
}

Widget SettingsSection(double height, double screenWidth)
{
  return Container(
    height: height,
    width: screenWidth,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xfffbb448),Color(0xffe46b10)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    ),
  );
}



