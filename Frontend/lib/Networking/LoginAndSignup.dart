// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

String baseUrl = "https://phonework-backend.herokuapp.com";

Future<String> AttemptLogin(String email, String password) async
{
  var url = Uri.parse(baseUrl+"/api/user/login");
  Map data =
  {
    "email": email,
    "password":password
  };
  var body = jsonEncode(data);
  var result = await http.post(
      url,
      headers: <String,String>{"Content-type":"application/json"},
      body: body
  );
  if(result.statusCode == 200)
  {
    return result.body;
  }
  else
  {
    print(result.reasonPhrase);
    return "400";
  }
}

Future<String> AttemptSignUp(String name, String email, String password, String nationality, String dateOfBirth) async
{
  var url = Uri.parse(baseUrl+"/api/user/register");
  Map data =
  {
    "name" : name,
    "email" : email,
    "password" : password,
    "nationality" : nationality,
    "dateOfBirth" : dateOfBirth
  };
  var body = jsonEncode(data);
  var result = await http.post(
      url,
      headers: <String,String>{"Content-type":"application/json"},
      body: body
  );
  if(result.statusCode == 200)
  {
    return result.body;
  }
  else
  {
    print(result.reasonPhrase);
    return "400";
  }
}

Future<String> GetWorkurl(String jwt) async
{
  var url = Uri.parse(baseUrl+"/api/getWork");
  try {
    var result = await http.get(
        url,
        headers: <String, String>{
          "Content-type": "application/json",
          "auth-token": jwt
        }
    );
    if(result.statusCode == 200)
    {
      return result.body;
    }
    else
    {
      //print(result.reasonPhrase);
      return "400";
    }
  }on Exception{
    return "Failed";
  }
}

Future<int> SubmitWork(double sliderValue, String emailAddress, String imageID, String jwt) async
{
  var url = Uri.parse(baseUrl+"/api/submitWork");
  Map data =
  {
    "email" : emailAddress,
    "imageID" : imageID + " " + sliderValue.toString()
  };
  var body = jsonEncode(data);
  try {
    var result = await http.put(
      url,
      headers: <String, String>{
        "Content-type": "application/json",
        "auth-token": jwt
      },
      body: body

    );
    return result.statusCode;
  }on Exception{
    return 400;
  }
}