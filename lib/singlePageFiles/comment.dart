import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../api_connection/api_connection.dart';
import '../colors/color_palette.dart';
import '../localization.dart';
import '../providers/language_provider.dart';
import 'package:get/get.dart';
import '../colors/color_palette.dart';

class comment extends StatefulWidget {
  const comment({super.key});

  @override
  State<comment> createState() => _commentState();
}

class _commentState extends State<comment> {
  final TextEditingController commentController = TextEditingController();
  var ContactController = TextEditingController();
  var formkey = GlobalKey<FormState>();
  bool isLoading= false;
  uploadComment(context,loc) async {
    setState(() {
      isLoading=true;
    });
    try {
      var res = await http.post(
        Uri.parse(API.comment_upload),
        body:{
          'contact':ContactController.text.trim(),
          'comment':commentController.text.trim(),

        },
      );

      if (res.statusCode== 200){


        var resBodyOfLogin= jsonDecode(res.body);
        if(resBodyOfLogin['success']==true)
        {
          ContactController.clear();
          commentController.clear();
          setState(() {
            isLoading= false;
          });
          DelightToastBar(
            builder: (context) => ToastCard(
              color: ColorPalette().classicsuccess,
              leading:  Icon(
                color: ColorPalette().classicProject,

                Icons.check,
                size: 28,
              ),
              title:  Text(
                "Comment submited",
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

        }else{
          DelightToastBar(
            builder: (context) => ToastCard(
              color: ColorPalette().emirateRed,
              leading:  Icon(
                color: ColorPalette().classicProject,

                Icons.error_outline,
                size: 28,
              ),
              title:  Text(
                "Something Went Wrong",
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
          setState(() {
            isLoading= false;
          });
          //registerAndSaveUserRecord();
        }
      }
    }
    catch(e){
      DelightToastBar(
        builder: (context) => ToastCard(
          color: ColorPalette().emirateRed,
          leading: const Icon(
            Icons.error_outline,
            size: 28,
          ),
          title:  Text(
            "Something went wrong.  Please check your internet or try later",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: ColorPalette().classicProject,

            ),
          ),

        ),
        position: DelightSnackbarPosition.top,
        autoDismiss: true,
        snackbarDuration: Duration(seconds: 2),
      ).show(context);
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
              Align(
          alignment: Alignment.centerLeft,
                child: Container(
                  padding: EdgeInsets.only(top:70,left: 10,right: 10,bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      height: 35.0,
                      width: 45.0,
                    
                      decoration: BoxDecoration(
                        //color: ColorPalette().emirateRed,
                          border: Border.all(color: ColorPalette().searchBarFill, width: 1.0),
                          borderRadius: BorderRadius.circular(15.0)
                      ),
                      child: Center(
                        child: Text(
                          loc.translate('back'),
                          style: TextStyle(
                        
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(

                child: Text(
                    loc.translate("comment_name"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0,
                        decoration: TextDecoration.none
                    )
                ),
              ),

             Container(
               padding: EdgeInsets.all(10),
               child: Column(

                 children: [
                   Form(
                     key: formkey,
                     child: Column(
                       children: [
                         TextFormField(
                           controller: ContactController,
                           validator: (val) => val == ""
                               ? loc.translate("enter_contact")
                               : null,
                           decoration: InputDecoration(
                             labelText: loc.translate("enter_your_contact"),
                             hintText: loc.translate("email_phone"),
                             border: OutlineInputBorder(),
                           ),
                           onChanged: (text) {
                             // print('Current text: $text');
                           },
                         ),
                         SizedBox(height: 18,),
                         TextFormField(
                           controller: commentController,
                           validator: (val) => val == ""
                               ? loc.translate("comment")
                               : null,
                           maxLines: 7,
                           decoration: InputDecoration(
                             labelText: loc.translate("comment"),
                             hintText: loc.translate("leave_comment"),
                             border: OutlineInputBorder(),

                           ),


                         ),
                         SizedBox(height: 18),
                         Material(
                           color: ColorPalette().emirateRed,
                           borderRadius: BorderRadius.circular(6),
                           child: InkWell(
                             onTap: () {


                               if(formkey.currentState!.validate()){
                                 //final phone_value = '${country.phoneCode}';
                                 //luggageAuthetication(phone_value,context,loc);
                                 uploadComment(context,loc);

                               }else{
                                 // Fluttertoast.showToast(msg:"Please all field please");
                                 DelightToastBar(
                                   builder: (context) => ToastCard(
                                     color: ColorPalette().emirateRed,
                                     leading:  Icon(
                                       Icons.error_outline,
                                       size: 28,
                                       color: ColorPalette().classicProject,
                                     ),
                                     title:  Text(
                                       "Please fill all Entries",
                                       style: TextStyle(
                                         fontWeight: FontWeight.w700,
                                         fontSize: 14,
                                         color: ColorPalette().classicProject,

                                       ),
                                     ),

                                   ),
                                   position: DelightSnackbarPosition.top,
                                   autoDismiss: true,
                                   snackbarDuration: Duration(seconds: 2),
                                 ).show(context);
                               }
                             },
                             borderRadius: BorderRadius.circular(10),
                             child: Padding(
                               padding: EdgeInsets.symmetric(
                                 vertical: 10,
                                 horizontal: 28,
                               ),
                               child: isLoading ?CircularProgressIndicator(color: ColorPalette().classicProject,):Text(
                                 loc.translate('comment_name'),
                                 style: TextStyle(
                                   color: Colors.white,
                                   fontSize: 16,
                                 ),
                               ),
                             ),
                           ),
                         ),
                       ],
                     ),
                   )
                 ],
               ),
             )
            ],
          ),
        ),
      ),
    );
  }
}
