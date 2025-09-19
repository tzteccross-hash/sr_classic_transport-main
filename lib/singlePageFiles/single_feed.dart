import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../localization.dart';
import '../modal/ads.dart';
import '../colors/color_palette.dart';
import 'package:flutter_html/flutter_html.dart';

import '../providers/language_provider.dart';
class singleFeed extends StatefulWidget {
  final ads? message;

  singleFeed({this.message});

  @override
  State<singleFeed> createState() => _singleFeedState();
}

class _singleFeedState extends State<singleFeed> {
  
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    return Scaffold(
      body:Expanded(
        child: SingleChildScrollView(
         child: Column(
           children: [
             Stack(
               clipBehavior: Clip.none,
               children: [
                 Hero(
                   tag: "null",
                   child: FadeInImage(
                     height: (screenHeight / 4) + 50.0,
                     width: screenWidth,
                     fit: BoxFit.cover,
                     placeholder: const AssetImage("assets/images/placeholder.png"),
                     image: NetworkImage(
                       widget.message!.image!,
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
Positioned(
  top: 75.0,
  left: 10.0,
  child: GestureDetector(
    onTap: () {
      Navigator.of(context).pop();
    },
    child: Container(
      height: 35.0,
      width: 45.0,
      decoration: BoxDecoration(
          color: ColorPalette().emirateRed,
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
),

                 
               ],
             ),
             Column(
               children: [
                 Container(
                   padding: EdgeInsets.all(10),
                   child: Text(
                     widget.message!.title!,
                       style: TextStyle(
                           fontWeight: FontWeight.bold,
                           color: Colors.black,
                           fontSize: 20.0,
                           decoration: TextDecoration.none
                       )
                   ),
                 ),

                 Container(
                   padding: EdgeInsets.all(5),
                   margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                   decoration: BoxDecoration(
                     color: ColorPalette().classicProject,

                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start, // Aligns children to the top vertically
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [


                      Container(
                        padding: EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          color: ColorPalette().classicgreen,
                          borderRadius: BorderRadius.circular(3.0),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(1, 1),
                              blurRadius: 2,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        child: Text(
                          widget.message!.status!,
                        style: TextStyle(
                          color: ColorPalette().classicProject,
                          fontWeight: FontWeight.bold,

                        ),
                        ),
                      ),
                     Container(
                        child: Html(
                         data:  widget.message!.description!,
                        ),
                      ),
                    ],
                   ),
                 )
               ],
             ),
           ],
         ),

        ),
      ),
    );
  }
}
