import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../api_connection/api_connection.dart';
import '../colors/color_palette.dart';
import '../localization.dart';
import '../modal/contact.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/language_provider.dart';


class ContactFragmentScreen extends StatefulWidget {
  const ContactFragmentScreen({super.key});

  @override
  State<ContactFragmentScreen> createState() => _ContactFragmentScreenState();
}

class _ContactFragmentScreenState extends State<ContactFragmentScreen> {
  Future<List<contactInfo>> GetContactList() async
  {
    List<contactInfo> allContactList = [];

    try
    {
      var res = await http.post(
        Uri.parse(API.contact_list),


      );

      if(res.statusCode == 200)
      {
        var responseBodyOfAllContacts = jsonDecode(res.body);
        if(responseBodyOfAllContacts["success"] == true)
        {
          (responseBodyOfAllContacts["contactInfo"] as List).forEach((eachRecord)
          {
            allContactList.add(contactInfo.fromJson(eachRecord));
          });
        }
      }
      else
      {
        Fluttertoast.showToast(msg: "Data no found");
      }
    }
    catch(errorMsg)
    {
      print("Error:: " + errorMsg.toString());
    }

    return allContactList;
  }
  Future<void> _callPhoneNumber(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
  void _launchWhatsApp(phone_no) async {
    final uri = Uri.parse('https://wa.me/$phone_no');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  void _instagram() async {
    final uri = Uri.parse('https://www.instagram.com/sr.classic_coach/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
  void _facebook() async {
    final uri = Uri.parse('https://web.facebook.com/groups/893594024777489/');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
              Container(
                padding: EdgeInsets.only(top:70,left: 10,right: 10,bottom: 20),
                child: Text(
                 loc.translate("contact"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0,
                        decoration: TextDecoration.none
                    )
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: BoxDecoration(
                  color: ColorPalette().lightred,

                  borderRadius: BorderRadius.circular(10.0),
                ),

                child: Row(

                  children: [

                    Container(
                      width:250,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text(
                            loc.translate("contact_text"),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/telephones.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              contactList(context,screenWidth)
            ],
          ),
        ),
      ),
    );
  }
  contactList(context,screenWidth)
  {


    return Container(
      width: screenWidth,
      color: ColorPalette().classicProject,

      child: FutureBuilder(

          future: GetContactList(),
          builder: (context, AsyncSnapshot<List<contactInfo>> dataSnapShot)
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

                    ListView.builder(
                      padding: const EdgeInsets.only(top: 12.0),
                      itemCount: dataSnapShot.data!.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index)
                      {
                        contactInfo itemInfo = dataSnapShot.data![index];
                        //contactInfo info_data = luggageInfo.fromJson(resBodyOfLogin ["luggageData"]);

                        return GestureDetector(

                          onTap: ()
                          {

                          },



                          child: Container(


                            margin: EdgeInsets.fromLTRB(
                              0,
                              index == 0 ? 0 : 0,
                              0,
                              index == dataSnapShot.data!.length - 0 ? 0 : 0,
                            ),

                            child: Container(


                              child: Column(


                                children: [

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start, // Aligns children to the right


                                      children: [
                                        Container(



                                          color:ColorPalette().classicProject,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                            children: [
                                              Container(

                                                child: Text(
                                                  itemInfo.location!,
                                                  style: const TextStyle(
                                                    fontSize: 15,

                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),

                                        //padding: const EdgeInsets.all(8.0),




                                            ],

                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            "${itemInfo.status!} ${itemInfo.description!}",
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            itemInfo.country!,
                                          ),
                                        ),
                                        Container(
                                          child: Text(
                                            itemInfo.phone_no!,
                                          ),
                                        ),
Row(

  children: [
    Padding(
      padding: const EdgeInsets.only(bottom: 5.0,top: 5.0),
      child: GestureDetector(
        onTap: () {
          //final Uri phoneNumber = Uri.parse('tel:+255715511420');
          // Handle the tap event here
          _callPhoneNumber("${itemInfo.phone_no!}");
        },
       child: Container(
         height: 25,
         width: 25,
         decoration: BoxDecoration(
           image: DecorationImage(
             image: AssetImage("assets/images/call.png"),
             fit: BoxFit.cover,
           ),
         ),
       ),
      ),
    ),
    GestureDetector(
      onTap: ()
      {
        _launchWhatsApp("${itemInfo.phone_no!}");
      },

      child: Padding(
        padding: const EdgeInsets.only(left: 5.0,bottom: 5.0,top: 5.0),
        child: Container(

          height: 25,
          width: 25,
          decoration: BoxDecoration(

            image: DecorationImage(
              image: AssetImage("assets/images/whatsapp.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: ()
      {
        _instagram();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0,bottom: 5.0,top: 5.0),
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/instagram.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
    GestureDetector(
      onTap: ()
      {
        _facebook();
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 5.0,bottom: 5.0,top: 5.0),
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/facebook.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  ],
)

                                      ],
                                    ),
                                  ),

                                  Container(
                                    width: (screenWidth - 50.0),
                                    decoration: BoxDecoration(

                                      border: Border(

                                        top: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),
                                        bottom: BorderSide(color:ColorPalette().classicgreyborder, width: 1.0),

                                      ),
                                    ),
                                  )
                                ],
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
