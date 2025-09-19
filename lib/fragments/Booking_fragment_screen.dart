import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../localization.dart';

class bookingFragmentScreen extends StatefulWidget {
  const bookingFragmentScreen({super.key});

  @override
  State<bookingFragmentScreen> createState() => _bookingFragmentScreenState();
}

class _bookingFragmentScreenState extends State<bookingFragmentScreen> {
  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations(languageProvider.languageCode);
    return  Scaffold(

      body: Center(
        child: Expanded(
          child: SingleChildScrollView(
            child: Column(

              children: [
                Center(
                  child: Text(
                      loc.translate("coming"),
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                      )
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
