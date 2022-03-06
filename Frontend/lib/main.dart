// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, non_constant_identifier_names, sized_box_for_whitespace, use_key_in_widget_constructors

import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jpegtran_ffi/jpegtran_ffi.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:version2/Screens/HomeScreen.dart';
import 'package:version2/Screens/LoginScreen.dart';

import 'Providers/Data.dart';
import 'Providers/Settings.dart';
import 'Screens/ImageScreen.dart';

Future<void> main ()
async {

  runApp(
      MultiProvider(providers:[
        ChangeNotifierProvider(create: (context) => Settings(),),
        ChangeNotifierProvider(create: (context) => Data(),),
      ],
        child: MyApp(),
      ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(390, 844),//iphone 12 dimensions
      builder:() => MaterialApp(

        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.orange,
            textTheme: GoogleFonts.creteRoundTextTheme().copyWith(
              bodyText1: GoogleFonts.montserrat(),
            )
        ),
        home: LoginScreen(),
      ),
    );
  }
}




