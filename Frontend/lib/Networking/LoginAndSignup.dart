// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;

String baseUrl = "https://popular-cheetah-11.loca.lt";

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