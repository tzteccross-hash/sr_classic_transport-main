import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api_connection/api_connection.dart';
import '../colors/color_palette.dart';
import '../localization.dart';
import '../modal/ads.dart';
import '../providers/language_provider.dart';
import '../singlePageFiles/single_feed.dart';

class adsScreen extends StatefulWidget {
  const adsScreen({super.key});

  @override
  State<adsScreen> createState() => _adsScreenState();
}

class _adsScreenState extends State<adsScreen> {

  Future<List<ads>> GetAdsList() async
  {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    final String? languageCode =prefs.getString('languageCode');
    List<ads> allClothItemsList = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.ads_list),
        body:{

          'languageCode':languageCode,

        },

      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllClothes = jsonDecode(res.body);
        if(responseBodyOfAllClothes["success"] == true)
        {
          (responseBodyOfAllClothes["Adsinfo"] as List).forEach((eachRecord)
          {
            allClothItemsList.add(ads.fromJson(eachRecord));
          });
        }
      }
      else
      {
       // Fluttertoast.showToast(msg: loadedData);
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allClothItemsList;
  }
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    return  Scaffold(

      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [

              adsList(context,screenWidth,loc)
            ],
          ),
        ),
      ),
    );
  }
  adsList(context,screenWidth,loc)
  {


    return Container(
      width: screenWidth,
      color: ColorPalette().classicProject,

      child: FutureBuilder(

          future: GetAdsList(),
          builder: (context, AsyncSnapshot<List<ads>> dataSnapShot)
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
                padding: EdgeInsets.only(top: 60.0), // Adds 16 pixels of padding on all sides
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [

                        Container(
                          padding: EdgeInsets.only(left: 10.0), // Adds 16 pixels of padding on all sides

                          child: Text(
                              loc.translate('news_feed'),
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
                              loc.translate('check_up'),
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
                        ads itemInfo = dataSnapShot.data![index];

                        return GestureDetector(

                          onTap: ()
                          {

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => singleFeed(
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

                                      padding: const EdgeInsets.all(8.0),

                                      child: Container(

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.3), // Shadow color with opacity
                                              offset: Offset(0, 4), // X, Y offset
                                              blurRadius: 8, // Blur radius
                                              spreadRadius: 0, // Spread radius
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(


                                          child: FadeInImage(

                                            height: 130,
                                            width: 130,
                                            fit: BoxFit.cover,
                                            placeholder: const AssetImage("assets/images/placeholder.png"),
                                            image: NetworkImage(
                                              itemInfo.image!,
                                            ),
                                            imageErrorBuilder: (context, error, stackTraceError)
                                            {
                                              return const Center(
                                                child: Icon(
                                                  Icons.broken_image_outlined,
                                                ),
                                              );
                                            },

                                          ),
                                        ),

                                      ),

                                    ),
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


                                                //price
                                                Expanded(

                                                  child: Text(

                                                     itemInfo.title!,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style:  TextStyle(
                                                      fontSize: 15,
                                                      color: ColorPalette().emirateRed,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),

                                              ],
                                            ),
                                            Text(
                                              itemInfo.description!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style:  TextStyle(
                                                fontSize: 12,

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
                child: Column(
                  children: [
                    SizedBox(height: 100,),
                    Text("Empty, No Ads."),
                  ],
                ),
              );
            }
          }
      ),
    );



  }
}
