import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:putra_cab/AllWidgets/Divider.dart';
import 'package:putra_cab/Assistants/requestAssistant.dart';
import 'package:putra_cab/DataHandler/appData.dart';
import 'package:putra_cab/Models/placePrediction.dart';
import 'package:putra_cab/configMaps.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> 
{
  TextEditingController pickUpTextEditingController = TextEditingController();
  TextEditingController dropOffTextEditingController = TextEditingController();
  List<PlacePrediction> placePredictionList = [];


  @override
  Widget build(BuildContext context) 
  {
    String placeAddress = Provider.of<AppData>(context).pickUpLocation?.placeName ?? "";
    pickUpTextEditingController.text = placeAddress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),

            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 20.0, right: 25.0, bottom: 20.0),
                child: Column(
                 children: [
                  SizedBox(height: 5.0),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: ()
                        {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Set Destination", style: TextStyle(fontSize: 18.0, fontFamily: "Brand-Bold"),),
                      ),
                    ],

                  ),

                  SizedBox(height: 16.0),

                  Row(
                    children: [
                      Image.asset("gambar PutraCab/red marker.png", height: 16.0, width: 16.0,),//pickIcon image next dia tukar desticon
                    
                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: pickUpTextEditingController,
                              decoration: InputDecoration(
                                hintText : "Pick Up location?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: [
                      Image.asset("gambar PutraCab/destination 2.png", height: 16.0, width: 16.0,),//pickIcon image next dia tukar desticon
                    
                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              controller: dropOffTextEditingController,
                              decoration: InputDecoration(
                                hintText : "Where to?",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          //title for prediction
          
           SizedBox(height: 10.0,),
          (placePredictionList.length > 0) 
          ? Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0,horizontal: 8.0),
            child: ListView.separated(
              padding: EdgeInsets.all(0.0),
              itemBuilder: (context, index){
                return PredictionTile(placePrediction: placePredictionList[index],);
              },
              separatorBuilder: (BuildContext context, int index) => DividerWidget(),
              itemCount: placePredictionList.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
            ),
          )
          :Container()
        ] 
      ),
    );
  }

  void findPlace (String placeName) async{
    if(placeName.length > 1){
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:My";

      var res = await RequestAsisstant.getRequest(autoCompleteUrl);

      if(res == "failed"){
        return;
      }
      print("Place Prediction Response :: ");
      print(res);

      if(res ["status"] == "OK"){

        var predictions = res["predictions"]; 
        var placesList = (predictions as List).map((e) => PlacePrediction.fromJson(e)).toList();
        setState(() {
          placePredictionList = placesList;
        });
      }
    }
  }
}

class PredictionTile extends StatelessWidget {
  final PlacePrediction placePrediction;

  PredictionTile({Key? key, required this.placePrediction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();

    return Container(
      child: Column(
        children: [
          SizedBox(width: 5.0,),
          Row(
            children: [
              Icon(Icons.add_location),
              SizedBox(width: 7.0,),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4.0,),
                  Text(placePrediction.main_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 7.0),),
                  SizedBox(height: 2.0,),
                  Text(placePrediction.secondary_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 5.0,color: Colors.grey),),
                  SizedBox(height: 4.0,),
                ],),
            )
        ]),
        SizedBox(width: 5.0,),
        ],
      ),
    );
  }
}