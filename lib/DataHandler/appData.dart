import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:putra_cab/Models/address.dart';

class AppData extends ChangeNotifier
{
   Address? pickUpLocation;//letak ?

  void updatePickUpLocationAddress(Address picUpkAddress)
  {
    pickUpLocation = picUpkAddress;
    notifyListeners();
  }
}