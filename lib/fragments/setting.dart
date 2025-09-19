import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sr_classic_transport/changes/language.dart';

import '../colors/color_palette.dart';
import '../localization.dart';
import '../onboarding_screen.dart';
import '../providers/language_provider.dart';

class setting extends StatefulWidget {
  const setting({super.key});

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations(Provider.of<LanguageProvider>(context).languageCode);

    return  Scaffold(

      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top:70,left: 10,right: 10,bottom: 20),
                child: Text(
                    loc.translate("settings"),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20.0,
                        decoration: TextDecoration.none
                    )
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                   Row(
                     children: [
                       Container(
                         height: 30,
                         width: 30,
                         decoration: BoxDecoration(
                           image: DecorationImage(
                             image: AssetImage('assets/images/language_icon.png'),
                             fit: BoxFit.cover,
                           ),
                         ),
                       ),
                       Container(
                         padding: EdgeInsets.only(left:8.0),
                           child: Text(
                             loc.translate("change_language"),

                             style: const TextStyle(
                               fontSize: 15,

                               fontWeight: FontWeight.bold,
                             ),
                           )
                       ),
                     ],
                   ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return const language();
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                  transitionDuration: const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/right_arrow.png'),
                                              fit: BoxFit.cover,
                                            ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                   Row(
                     children: [
                       Container(
                         height: 30,
                         width: 30,
                         decoration: BoxDecoration(
                           image: DecorationImage(
                             image: AssetImage('assets/images/telephones.png'),
                             fit: BoxFit.cover,
                           ),
                         ),
                       ),
                       Container(
                         padding: EdgeInsets.only(left:8.0),
                           child: Text(
                              loc.translate("forget_saved_number"),
                             style: const TextStyle(
                               fontSize: 15,

                               fontWeight: FontWeight.bold,
                             ),
                           )
                       ),
                     ],
                   ),
                          GestureDetector(
                            onTap: (){
                              PanaraConfirmDialog.show(
                                context,
                                title: loc.translate('forget'),
                                message: loc.translate('forget_saved_number'),
                                confirmButtonText: loc.translate('forget'),
                                cancelButtonText: loc.translate('cancel'),
                                onTapCancel: () {
                                  Navigator.of(context, rootNavigator: true).pop();

                                },
                                onTapConfirm: () async {
                                  Navigator.of(context, rootNavigator: true).pop();
                                  final SharedPreferences prefs= await SharedPreferences.getInstance();
                                  await prefs.remove("phone_no_saved");
                                  await prefs.remove("country_code");
                                  DelightToastBar(
                                    builder: (context) => ToastCard(
                                      color: ColorPalette().classicsuccess,
                                      leading:  Icon(
                                        Icons.check,
                                        size: 28,
                                        color: ColorPalette().classicProject,
                                      ),
                                      title:  Text(
                                        "saved_number_forgotten",
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
                              Navigator.of(context).pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) {
                                    return DashboardOfFragments(

                                    );
                                  },
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                  transitionDuration: const Duration(milliseconds: 500),
                                ),
                              );
                            },
                            child: Container(
                              height: 17,
                              width: 17,
                              decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage('assets/images/right_arrow.png'),
                                              fit: BoxFit.cover,
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
    );
  }
}
