// ignore_for_file: file_names
//ignore_for_file: prefer_final_fields
import 'package:flutter/material.dart';

class Settings extends ChangeNotifier
{
  String _jwt = " ";
  String _accountBalance = " ";
  String _email = " ";
  String _accountNumber = " ";

  get accountBalance => _accountBalance;
  set accountBalance(value){
    _accountBalance = value;
    notifyListeners();
  }

  void setAccountBalance(String result)
  {
    accountBalance = result;
    notifyListeners();
  }

  get email => _email;
  set email(value){
    _email = value;
    notifyListeners();
  }

  void setEmail(String result)
  {
    email = result;
    notifyListeners();
  }

  get accountNumber => _accountNumber;
  set accountNumber(value){
    _accountNumber = value;
    notifyListeners();
  }

  void setAccountNumber(String result)
  {
    accountNumber = result;
    notifyListeners();
  }

  get jwt => _jwt;
  set jwt(value){
    _jwt = value;
    notifyListeners();
  }

  void setJWT(String result)
  {
    jwt = result;
    notifyListeners();
  }

}