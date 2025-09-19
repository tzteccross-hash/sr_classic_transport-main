import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api_connection/api_connection.dart';
import '../localization.dart';
import '../modal/cargo_list.dart';
import '../colors/color_palette.dart';
import '../modal/DispatchInfo.dart';
import '../providers/language_provider.dart';
class luggageDetailHistory extends StatefulWidget {

  final CargoList? message;

  luggageDetailHistory({this.message});
  @override
  State<luggageDetailHistory> createState() => _luggageDetailHistoryState();
}

class _luggageDetailHistoryState extends State<luggageDetailHistory> {
  Future<List<DispatchInfo>> getAllLuggages(code_no) async
  {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    final String? languageCode =prefs.getString('languageCode');
    List<DispatchInfo> allLuggageList = [];

    try
    {
      var res = await http.post(
          Uri.parse(API.dispatch_info),
        body:{
          'code_no':code_no,
          'languageCode':languageCode,

        },
      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if(responseBodyOfAllClothes["success"] == true)
        {
          (responseBodyOfAllClothes["arraival_response"] as List).forEach((eachRecord)
          {
            allLuggageList.add(DispatchInfo.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allLuggageList;
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    String luggage_status = widget.message!.store!;
    String code_no = widget.message!.code!;
    String response_sms = widget.message!.status!;
    String dateString = "${widget.message!.date_insert}";
    DateTime  now = DateTime.parse(dateString);
    String Trip_date = DateFormat('yMMMEd').format(now);
    Color status_color;
    bool _isVisible;

    (luggage_status=="out")? status_color =ColorPalette().emirateRed :status_color =ColorPalette().classicBlue ;
    (luggage_status=="out")? _isVisible=true :_isVisible=false ;

    return Scaffold(
        backgroundColor: status_color,
            body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,

                children: [
                  Hero(
                    tag: "null",
                    child: Container(
                      height: (screenHeight / 4) + 50.0,
                      width: screenWidth,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/classichighway.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 75.0,
                    left: 10.0,
                    child: Container(
                      color: Colors.transparent,
                      height: 50.0,
                      width: screenWidth - 10.0,

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 35.0,
                              width: 45.0,
                              decoration: BoxDecoration(
                                  color: status_color,
                                  border: Border.all(
                                      color: ColorPalette().coffeeUnselected, width: 1.0),
                                  borderRadius: BorderRadius.circular(15.0)),
                              child: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: ColorPalette().classicProject,
                                size: 17.0,
                              ),
                            ),
                          ),


                        ],
                      ),

                    ),


                  ),




                  Positioned(
                      top: 232,

                      child: Container(

                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(15),
                             //padding: const EdgeInsets.all(20),
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: status_color,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.4),
                                    spreadRadius: 1,
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  loc.translate(luggage_status),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      decoration: TextDecoration.none
                                  ),
                                ),
                              ),
                            ),

                          ],
                        ),
                      )



                  ),
                ],
              ),
            //  allItemWidget(context,_isVisible,screenWidth),
              Container(
                height: 120,
                width: screenWidth,
                child: Column(
                  children: [
                    const SizedBox(height: 13),
                    Container(
                      width: screenWidth,
                      child: Center(
                        child: Text(
                            "$Trip_date",
                            style: GoogleFonts.sourceCodePro(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0,
                                decoration: TextDecoration.none
                            )
                        ),

                      ),

                    ),
                    Container(
                      width: screenWidth,
                      child: Center(
                        child: Text(
                            "${widget.message!.code}",
                            style: GoogleFonts.sourceCodePro(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 27.0,
                                decoration: TextDecoration.none
                            )
                        ),

                      ),

                    ),
                    Container(
                      width: screenWidth,
                      child: Center(
                        child: Text(
                            "${widget.message!.account}",
                            style: GoogleFonts.sourceCodePro(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 18.0,
                                decoration: TextDecoration.none
                            )
                        ),

                      ),

                    ),

                  ],
                ),
              ),
              allItemWidget(context,_isVisible,screenWidth,code_no,loc),
              Container(
                color: ColorPalette().classicProject,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                       loc.translate('cargo_info'),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20.0,
                            decoration: TextDecoration.none
                        )
                    ),
                  ),
                ),
              ),


              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('date_registerd'),
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
                          "$Trip_date",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('sender'),
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
                          "${widget.message!.s_name}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('receiver'),
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
                          "${widget.message!.r_name}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('sender_no'),
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
                          "${widget.message!.s_no}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('receiver_no'),
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
                          "${widget.message!.r_no}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('payment_option'),
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
                          "${widget.message!.status}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('paid_price'),
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
                          "${widget.message!.payed} ${widget.message!.symbol}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('to_be_paid_price'),
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
                          "${widget.message!.to_be} ${widget.message!.symbol}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
              Container(
                width: screenWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                    bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                  ),
                ),
                child: Container(
                  height: 50,
                  width: screenWidth,

                  color:ColorPalette().classicProject,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          loc.translate('total_price'),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                            color: Colors.black,
                            fontSize: 16,
                            decoration: TextDecoration.none,
                         fontWeight: FontWeight.bold,

                          ),

                        ),
                      ),


                      Container(
                        padding: const EdgeInsets.all(6.0),
                        child: Text(
                          "${widget.message!.amount} ${widget.message!.symbol}",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.sourceCodePro(
                              color: Colors.black,
                              fontSize: 16,
                              decoration: TextDecoration.none,
                            fontWeight: FontWeight.bold,
                          ),

                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
    ),
    );
  }
  allItemWidget(context,_isVisible,screenWidth,code_no,loc)
  {

    if(_isVisible==true){
      return Container(
        width: screenWidth,
        color: ColorPalette().classicProject,

        child: FutureBuilder(

            future: getAllLuggages(code_no),
            builder: (context, AsyncSnapshot<List<DispatchInfo>> dataSnapShot)
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
                    "No Luggage found",
                  ),
                );
              }
              if(dataSnapShot.data!.length > 0)
              {


                return Container(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Column(
                    children: [
                      Container(
                        child: Text(
                            loc.translate('dispatch_info'),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 20.0,
                                decoration: TextDecoration.none
                            )
                        ),
                      ),
                      ListView.builder(
                        padding: const EdgeInsets.only(top: 12.0),
                        itemCount: dataSnapShot.data!.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index)
                        {

                          DispatchInfo eachLuggageItemRecord = dataSnapShot.data![index];
                          String response_sms = "${eachLuggageItemRecord.short_response}";
                         String response_status ="${eachLuggageItemRecord.arraival} ";


                          String dateString = "${eachLuggageItemRecord.date}";
                          DateTime  now = DateTime.parse(dateString);
                          String Trip_date = DateFormat('yMMMEd').format(now);


                          return GestureDetector(

                            onTap: ()
                            {
                              // Get.to(ItemDetailsScreen(itemInfo: eachClothItemRecord));
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
                                  height: 130,
                                  width: screenWidth,

                                  color:ColorPalette().classicProject,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [

                                      /* Padding(
                                          padding: EdgeInsets.only(bottom: 30.0),
                                          child: ClipRRect(

                                            borderRadius: BorderRadius.circular(50),
                                            child: FadeInImage(
                                              height: 50,
                                              width: 50,
                                              fit: BoxFit.cover,
                                              placeholder: const AssetImage("assets/placeholder.jpg"),
                                              image:  AssetImage('assets/images/clock.png'),

                                            ),
                                          ),
                                        ),*/
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [

                                              //name and price
                                              Row(
                                                children: [

                                                  //name
                                                  Expanded(
                                                    child: Text(
                                                      generateMessage(response_sms,eachLuggageItemRecord,response_status),
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
                                                      eachLuggageItemRecord.status!,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        color: ColorPalette().espresso ,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),

                                                ],
                                              ),

                                              const SizedBox(height: 16,),

                                              //tags
                                              Text(
                                                "$Trip_date",
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Padding(

                                                    padding: const EdgeInsets.only(top: 5),

                                                  ),
                                                  //name
                                                  Expanded(
                                                    child: Text(
                                                      loc.translate('dispatch_qty')+": ${eachLuggageItemRecord.q_left}",
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
                                                      color: Colors.white,

                                                      borderRadius: BorderRadius.circular(2), // Optional: for rounded corners
                                                      boxShadow: const [
                                                        BoxShadow(
                                                          color: Colors.grey, // Shadow color
                                                          offset: Offset(1, 1), // X and Y offset
                                                          blurRadius: 5, // Blur radius
                                                          spreadRadius: 1, // Spread radius
                                                        ),
                                                      ],
                                                    ),
                                                    child: Padding(

                                                      padding: const EdgeInsets.only(left: 12, right: 12),
                                                      child: Text(
                                                        eachLuggageItemRecord.amount!,
                                                        maxLines: 2,
                                                        overflow: TextOverflow.ellipsis,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: ColorPalette().classicdark ,
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
    }else{
      return Container(
        child: SizedBox(),
      );
    }


  }
   generateMessage(response_sms,eachLuggageItemRecord,response_status) {


     if(response_sms=="Taken"){
       return  response_status ="${eachLuggageItemRecord.arraival} ✅";


     }else if (response_sms=="left"){
       return response_status ="${eachLuggageItemRecord.arraival} 🚗";

     }else if(response_sms=="exceed"){
       return  response_status ="${eachLuggageItemRecord.arraival} 🕓";

     }else if(response_sms=="Arrived"){
       return response_status ="${eachLuggageItemRecord.arraival} 📍";


     }else{
       return response_status ="${eachLuggageItemRecord.arraival} ";
     }
}
}