// ignore_for_file: unnecessary_new

//import 'dart:js';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:putra_cab/Assistants/requestAssistant.dart';
import 'package:putra_cab/DataHandler/appData.dart';
import 'package:putra_cab/Models/address.dart';
import 'package:putra_cab/configMaps.dart';
// 'package:rider_app/Assistants/requestAssistant.dart';
// 'package:rider_app/configMaps.dart';


class AssistantMethods
{
  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1, st2, st3, st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAsisstant.getRequest(url);

    if(response != "failed")
    {
      placeAddress = response["results"][0]["formatted_address"];
    
      Address userPickUpAddress = new Address();
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;
    
      Provider.of<AppData>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return placeAddress;
  }
}