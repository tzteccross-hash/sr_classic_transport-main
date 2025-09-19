import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_connection/api_connection.dart';
import '../colors/color_palette.dart';
import '../localization.dart';
import '../modal/cargo_list.dart';
import '../providers/language_provider.dart';
import '../singlePageFiles/luggageDetailHistory.dart';
class luggageHistory extends StatefulWidget {
  const luggageHistory({super.key});

  @override
  State<luggageHistory> createState() => _luggageHistoryState();
}


class _luggageHistoryState extends State<luggageHistory> {
  String loadedData = '';
  String country_code = '';
  void initState() {
    super.initState();
    phone_no();

  }
  void phone_no() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? phone_no_saved =prefs.getString('phone_no_saved');
    final String? country_code_string =prefs.getString('country_code');

    setState(() {
      loadedData = phone_no_saved!;
      country_code = country_code_string!;
    });
  }

  Future<List<CargoList>> GetCargoList() async
  {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    final String? languageCode =prefs.getString('languageCode');

    List<CargoList> allCargoItemsList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.cargo_list),
        body:{
          'phone_no':loadedData,
          'country_code':country_code,
          'languageCode':languageCode,

        },

      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if(responseBodyOfAllClothes["success"] == true)
        {
          (responseBodyOfAllClothes["cargo_list"] as List).forEach((eachRecord)
          {
            allCargoItemsList.add(CargoList.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: loadedData);
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allCargoItemsList;
  }


  @override
  Widget build(BuildContext context) {

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    String statuspadding;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    return  Scaffold(
      backgroundColor: ColorPalette().classicProject,
      body: Expanded(
        child: SingleChildScrollView(

        child: Column(


          children: [
            Container(
              padding: EdgeInsets.only(top:70,left: 10,right: 10),
               // Sets a fixed height of 150 logical pixels
              color: Colors.black54,
              child: Column(
                children: [
                  Container(

                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                       // Sets a fixed spacing between all children

                      children: [
                        // Left widget

                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            //height: 35.0,
                            //width: 45.0,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                //color: ColorPalette().emirateRed,
                                border: Border.all(color: ColorPalette().classicProject, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Text(
                              loc.translate('back'),
                              style: TextStyle(
                                color:ColorPalette().classicProject,
                              ),
                            ),
                          ),
                        ),

                        // Spacer to push next widget to center
                        GestureDetector(
                          onTap: () async{
                            final SharedPreferences prefs= await SharedPreferences.getInstance();
                            await prefs.remove("phone_no_saved");
                            await prefs.remove("country_code");
                            Navigator.of(context).pop();
                            DelightToastBar(
                              builder: (context) =>  ToastCard(
                                color: ColorPalette().classicsuccess,
                                leading: Icon(
                                  Icons.check,
                                  size: 28,
                                  color: ColorPalette().classicProject,
                                ),
                                title: Text(
                                  "Phone number has been deleted ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: ColorPalette().classicProject,
                                  ),
                                ),

                              ),
                              position: DelightSnackbarPosition.top,
                              autoDismiss: true,
                              snackbarDuration: Duration(seconds: 4),
                            ).show(context);
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              //color: ColorPalette().emirateRed,
                                border: Border.all(color: ColorPalette().classicProject, width: 2.0),
                                borderRadius: BorderRadius.circular(15.0)
                            ),
                            child: Text(
                              loc.translate('forget'),
                              style: TextStyle(
                                color:ColorPalette().classicProject,
                              ),

                            ),

                          ),
                        ),

                        // Center widget


                      ],

                    ),



                  ),
                ],
              ),
            ),
            cargolist(context,screenWidth,loc)
          ],
        ),


      ),

      ),

    );
  }
  cargolist(context,screenWidth,loc)
  {


      return Container(
        width: screenWidth,
        color: ColorPalette().classicProject,

        child: FutureBuilder(

            future: GetCargoList(),
            builder: (context, AsyncSnapshot<List<CargoList>> dataSnapShot)
            {

              if(dataSnapShot.connectionState == ConnectionState.waiting)
              {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(dataSnapShot.data == null)
              {
                return const Center(
                  child: Text(
                    "No luggage",
                  ),
                );
              }
              if(dataSnapShot.data!.length > 0)
              {


                return Container(
                  padding: EdgeInsets.only(top: 20.0), // Adds 16 pixels of padding on all sides
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [

                          Container(
                            padding: EdgeInsets.only(left: 10.0), // Adds 16 pixels of padding on all sides

                            child: Text(
                                loc.translate('history'),
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20.0,
                                    decoration: TextDecoration.none
                                )
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.only(left: 10.0),  // Adds 16 pixels of padding on all sides

                            child: Text(
                                loc.translate('List_cargo')+"+$country_code$loadedData",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ColorPalette().classicdarkgrey,
                                    fontSize: 14.0,
                                    decoration: TextDecoration.none
                                )
                            ),
                          ),
                          SizedBox(height: 10,)
                        ],
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 12.0),
                        itemCount: dataSnapShot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index)
                        {
                          CargoList itemInfo = dataSnapShot.data![index];
                          String dateString = "${itemInfo.date_insert!}";
                          DateTime  now = DateTime.parse(dateString);
                          String Date_insert = DateFormat('yMMMEd').format(now);
                          String luggage_status = "${itemInfo.store!}";
                          final EdgeInsets myPadding ;
                          final EdgeInsets margin ;

                          Color status_color;
                          (luggage_status=="out")? status_color =ColorPalette().emirateRed :status_color =ColorPalette().classicBlue ;
                          //CargoList info_data = luggageInfo.fromJson(resBodyOfLogin ["luggageData"]);
/*if(luggage_status=="out"){
  myPadding = const EdgeInsets.all(0);
  margin = const EdgeInsets.all(0);
}else{
  myPadding = const EdgeInsets.all(0);
  margin = const EdgeInsets.all(0);
}*/


                          return GestureDetector(

                            onTap: ()
                            {
                              //Get.to(luggageDetailHistory(message: itemInfo));
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => luggageDetailHistory(
                                  message: itemInfo,


                                )),
                              );
                            },



                            child: Container(

                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                                  bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),

                                ),
                              ),
                              margin: EdgeInsets.fromLTRB(
                                0,
                                index == 0 ? 0 : 0,
                                0,
                                index == dataSnapShot.data!.length - 0 ? 0 : 0,
                              ),

                              child: Container(


                                child: Container(
                                  padding: const EdgeInsets.only(left: 5,right: 5),
                                  height: 100,
                                  width: screenWidth,

                                  color:ColorPalette().classicProject,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [

                                  Container(
                                      // margin: margin,
                                      //  padding: myPadding,
                                    width: 80,
                                    height: 80,
                                        decoration: BoxDecoration(

                                          shape: BoxShape.circle,
                                          color: status_color,
                                          boxShadow: [
                                           /* BoxShadow(
                                              color: Colors.black.withOpacity(0.4),
                                              spreadRadius: 1,
                                              blurRadius: 6,
                                              offset: const Offset(0, 3),
                                            ),*/
                                          ],
                                        ),
                                        child: Center(
                                          child: Text(
                                            loc.translate(luggage_status),
                                            style:  TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                decoration: TextDecoration.none
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15,right:10,top:15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              //name and price
                                              Row(
                                                children: [

                                                  //name
                                                  Expanded(
                                                    child: Text(
                                                      itemInfo.code!,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 15,

                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                  //price
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 12, right: 12),
                                                    child: Text(
                                                      Date_insert,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: ColorPalette().classicdarkgrey,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              const SizedBox(height: 16,),

                                              //tags

                                              SizedBox(height: 3,),
                                              Row(
                                                children: [

                                                  //name
                                                  Expanded(
                                                    child: Text(
                                                      loc.translate('quantity')+"(s) : ${itemInfo.question}",
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 15,

                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                  //price
                                                  Container(


                                                    decoration: BoxDecoration(
                                                      color: status_color,

                                                      borderRadius: BorderRadius.circular(5), // Optional: for rounded corners


                                                    ),
                                                    child: Padding(

                                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                                      child: Text(
                                                        "${itemInfo.amount!} ${itemInfo.symbol!}",
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: Colors.white ,
                                                          fontWeight: FontWeight.bold,
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
                                      /*
                                        Container(
                                          padding: const EdgeInsets.all(6.0),

                                          child: Text(
                                            "Dispatch Date",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.sourceCodePro(
                                              color: Colors.black,
                                              fontSize: 16,
                                              decoration: TextDecoration.none,


                                            ),

                                          ),
                                        ),


                                        Container(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Text(
                                            "Wednesday 30th-07-2025",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.sourceCodePro(
                                                color: Colors.black,
                                                fontSize: 16,
                                                decoration: TextDecoration.none
                                            ),

                                          ),
                                        ),
                              */
                                    ],

                                  ),
                                ),

                              ),

                            ),

                          );
                        },
                      ),
                    ],
                  ),
                );
              }
              else
              {
                return const Center(
                  child: Text("Empty, No Data."),
                );
              }
            }
        ),
      );



  }
}
