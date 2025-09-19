import 'dart:convert';

import 'package:country_picker/country_picker.dart';
import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:glassmorphism_ui/glassmorphism_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sr_classic_transport/fragments/adsScreen.dart';
import 'package:sr_classic_transport/singlePageFiles/comment.dart';
import 'package:sr_classic_transport/singlePageFiles/luggage_history.dart';
import '../api_connection/api_connection.dart';
import '../colors/color_palette.dart';
import '../modal/ads.dart';
import '../modal/luggageInfo.dart';
import '../singlePageFiles/luggageDetails.dart';
import '../localization.dart';
import '../providers/language_provider.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../singlePageFiles/single_feed.dart';
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: '',),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});



  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();

}


var isObsecure = true.obs;

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController phoneNoController = TextEditingController();

  var codeNoController = TextEditingController();
  bool isLoading= false;
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }
  void _loadUsername() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? phone_no_saved =prefs.getString('phone_no_saved');
    phone_no_saved ==null ? print("null") :  Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => luggageHistory(

      )),
    );

  }

  luggageAuthetication(phone_value,context,loc) async {
    setState(() {
      isLoading=true;
    });
    try {
      var res = await http.post(
        Uri.parse(API.authentication),
        body:{
          'phone_no':phoneNoController.text.trim(),
          'code_no':codeNoController.text.trim(),
          'country_code':phone_value,

        },
      );

      if (res.statusCode== 200){


        var resBodyOfLogin= jsonDecode(res.body);
        if(resBodyOfLogin['success']==true)
        {
setState(() {
  isLoading= false;
});
PanaraConfirmDialog.show(
  context,
  title: loc.translate('save'),
  message: loc.translate('save_text'),
  confirmButtonText: loc.translate('save'),
  cancelButtonText: loc.translate('cancel'),
  onTapCancel: () {
    Navigator.of(context, rootNavigator: true).pop();

  },
  onTapConfirm: () async {
    Navigator.of(context, rootNavigator: true).pop();
    final SharedPreferences prefs= await SharedPreferences.getInstance();
    await prefs.setString("phone_no_saved",phoneNoController.text.trim());
    await prefs.setString("country_code",phone_value);
    DelightToastBar(
      builder: (context) => ToastCard(
        color: ColorPalette().classicsuccess,
        leading:  Icon(
          Icons.check,
          size: 28,
          color: ColorPalette().classicProject,
        ),
        title:  Text(
          "Phone number has been saved ",
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
  },
  panaraDialogType: PanaraDialogType.custom,color: ColorPalette().emirateRed,
  barrierDismissible: false, // optional parameter (default is true)
);

          luggageInfo info_data = luggageInfo.fromJson(resBodyOfLogin ["luggageData"]);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => luggageDetails(
                message: info_data,


            )),
          );

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
                "Incorrect credentials. Check phone no or Code number ",
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
      }else{
        setState(() {
          isLoading= false;
        });
        DelightToastBar(
          builder: (context) => ToastCard(
            color: ColorPalette().emirateRed,
            leading:  Icon(
              Icons.error_outline,
              size: 28,
              color: ColorPalette().classicProject,
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
    catch(e){
      setState(() {
        isLoading= false;
      });
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

  var formkey = GlobalKey<FormState>();
  Future<List<ads>> getadsItems() async {
    final SharedPreferences prefs =  await SharedPreferences.getInstance();
    final String? languageCode =prefs.getString('languageCode');
    List<ads> trendingClothItemsList = [];

    try {
      var res = await http.post(Uri.parse(API.ads_list),
        body:{
        'languageCode':languageCode,
        },
      );

      if (res.statusCode == 200) {
        var responseBodyOfTrending = jsonDecode(res.body);
        if (responseBodyOfTrending["success"] == true) {
          (responseBodyOfTrending["Adsinfo"] as List).forEach((
              eachRecord,
              ) {
            trendingClothItemsList.add(ads.fromJson(eachRecord));
          });
        }
      } else {
        Fluttertoast.showToast(msg: "Error, status code is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }

    return trendingClothItemsList;
  }
  Country country = CountryParser.parseCountryCode('CD');

  void showPicker(){
    showCountryPicker(
        context: context,
        favorite: ['TZ','CD','ZA'],
        countryListTheme: CountryListThemeData(
            bottomSheetHeight: 600,
            backgroundColor: Colors.purple.shade50,
            borderRadius: BorderRadius.circular(20),
            inputDecoration: const InputDecoration(
                prefixIcon: Icon(Icons.search,color: Colors.purple),
                hintText: 'Search your counrty here'
            )
        ),
        onSelect: (country){
          setState(() {
            this.country=country;
          });
        }
    );
  }
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;


    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: (screenHeight / 2) + 230.0,
                width: screenWidth,

              ),
              Hero(
                tag: "null",
                child: Container(
                  height: (screenHeight / 2) + 50.0,
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
                top: 60.0,
                left: 10.0,
                child: Container(
                  color: Colors.transparent,
                  height: 50.0,
                  width: screenWidth - 20.0,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: ColorPalette().emirateRed,

                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        padding: const EdgeInsets.all(6.0),

                        child: Text(
                          "Sr Classiccoach",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,
                              fontSize: 20,
                              decoration: TextDecoration.none
                          ),

                        ),
                      ),

                      GestureDetector(
                        onTap: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => comment(
                            )),
                          );
                        },
                        child: Container(
                          height: 80.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            color: ColorPalette().classicBlue,
                            border: Border.all(
                              color: ColorPalette().classicBlue,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: Icon(
                            Icons.comment,
                            color: ColorPalette().classicProject,
                            size: 17.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ), //up nav
              Positioned(
                top: (screenHeight / 2) - 110.0,
                child: Column(
                  children: [
                    GlassContainer(
                      height: 350.0,
                      width: screenWidth,
                      blur: 4,
                      border: Border.fromBorderSide(BorderSide.none),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black.withOpacity(0.6),
                      child: Container(
                        height: 140.0,
                        width: screenWidth - 20.0,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                          child: Column(
                            children: [
                              Form(
                                key: formkey,
                                child: Column(
                                  children: [
                                    Text(
                                      loc.translate('track_your_luggage'),
                                      style: GoogleFonts.sourceCodePro(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 23.0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                    Text(
                                      loc.translate('enter_phone_and_code'),                                      style: GoogleFonts.sourceCodePro(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                          decoration: TextDecoration.none
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(

                                      keyboardType: TextInputType.number,
                                      controller: phoneNoController,
                                      validator: (val) => val == ""
                                          ? "Enter Receiver or Senders phone number"
                                          : null,
                                      decoration: InputDecoration(
                                        prefixIcon: GestureDetector(
                                          onTap: showPicker,
                                          child: Container(
                                            height: 55,
                                            width: 100,
                                            alignment: Alignment.center,
                                            child: Text(
                                              '${country.flagEmoji}+${country.phoneCode}',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                  decoration: TextDecoration.none

                                              ),
                                            ),

                                          ),
                                        ),

                                        hintText: loc.translate('enter_phone_and_code'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextFormField(
                                      style: TextStyle(
                                        height: 2.7,

                                      ),
                                      controller: codeNoController,
                                      validator: (val) =>
                                      val == "" ? "Code number" : null,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.numbers,
                                          color: Colors.black,
                                        ),

                                        hintText: loc.translate('code_number'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        disabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.white60,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 6,
                                        ),
                                        fillColor: Colors.white,
                                        filled: true,
                                      ),
                                    ),
                                    SizedBox(height: 18),

                                    Material(
                                      color: ColorPalette().emirateRed,
                                      borderRadius: BorderRadius.circular(10),
                                      child: InkWell(
                                        onTap: () {


                                          if(formkey.currentState!.validate()){
                                            final phone_value = '${country.phoneCode}';
                                            luggageAuthetication(phone_value,context,loc);


                                          }else{
                                            Fluttertoast.showToast(msg:"Please all field please");

                                          }
                                        },
                                        borderRadius: BorderRadius.circular(10),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 10,
                                            horizontal: 28,
                                          ),
                                          child: isLoading ?CircularProgressIndicator(color: ColorPalette().classicProject,):Text(
                                           loc.translate('track'),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        SizedBox(height: 10,),
        Container(

  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
      Container(

        padding: const EdgeInsets.only(
          left: 20.0,
        ),

        child: Text(
          loc.translate('catch'),
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
              color: Colors.black54,
              fontSize: 14,
              decoration: TextDecoration.none,
              fontWeight: FontWeight.bold,
          ),

        ),
      ),

      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => adsScreen(
)),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            loc.translate('read_more'),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red,
                fontSize: 12,
                decoration: TextDecoration.none
            ),

          ),
        ),
      ),
    ],
  ),
),
          adsWidget(context),
        ],
      ),
    );
  }
  Widget adsWidget(context) {
    return FutureBuilder(
      future: getadsItems(),
      builder: (context, AsyncSnapshot<List<ads>> dataSnapShot) {
        if (dataSnapShot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (dataSnapShot.data == null) {
          return const Center(child: Text("No News feed"));
        }
        if (dataSnapShot.data!.length > 0) {
          return SizedBox(
            height: 260,
            child: ListView.builder(
              itemCount: dataSnapShot.data!.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                ads eachAdOnlist = dataSnapShot.data![index];
                return GestureDetector(
                  onTap: ()
                  {
                    //Get.to(luggageDetailHistory(message: itemInfo));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => singleFeed(
                        message: eachAdOnlist,


                      )),
                    );
                  },

                  child: Container(
                    width: 300,
                    margin: EdgeInsets.fromLTRB(
                      index == 0 ? 16 : 8,
                      10,
                      index == dataSnapShot.data!.length - 1 ? 16 : 8,
                      10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(1, 1),
                          blurRadius: 2,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        //item image
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),

                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),

                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [



                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(22),
                                  topRight: Radius.circular(22),
                                ),
                                child: FadeInImage(
                                  height: 160,
                                  width: 370,
                                  fit: BoxFit.cover,
                                  placeholder: const AssetImage("assets/images/placeholder.png"),
                                  image: NetworkImage(
                                    eachAdOnlist.image!,
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
                              Container(

                                decoration: BoxDecoration(
                                  color: ColorPalette().classicgreen,
                                  borderRadius: BorderRadius.circular(2.0),
                                ),
                                padding: const EdgeInsets.all(3.0),
                                child: Text(
                                  eachAdOnlist.status!,
                                  style:  TextStyle(
                                    fontSize: 12,
                                    decoration: TextDecoration.none,
                                    color: ColorPalette().classicProject,
                                  ),
                                  textAlign: TextAlign.start,
                                  textDirection: TextDirection.ltr,

                                ),
                              ),

                              SizedBox(height: 3,),
                              Container(

child: Text(
  eachAdOnlist.title!,
  style:  GoogleFonts.roboto(
    fontSize: 14,
    color: Colors.black54,
    decoration: TextDecoration.none,
fontWeight: FontWeight.bold,
  ),
),


                              ),
SizedBox(height: 5,),
Container(
  child: Text(
eachAdOnlist.description!,
   maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: GoogleFonts.roboto(
      fontSize: 16,
      color: Colors.black,
      decoration: TextDecoration.none,
      fontWeight: FontWeight.bold,
    ),
  ),
),





                            ],
                          ),
                        ),
                        //item name & price
                        //rating stars & rating numbers

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return const Center(child: Text("Empty, No Data."));
        }
      },
    );
  }
}
