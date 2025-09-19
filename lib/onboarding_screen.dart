import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'colors/color_palette.dart';
import 'fragments/Contact_Fragment_Screen.dart';
import 'fragments/setting.dart';
import 'providers/language_provider.dart';
import 'localization.dart';
import 'fragments/home_fragment_Screen.dart';
import 'fragments/Booking_fragment_screen.dart';
import 'fragments/adsScreen.dart';
 // App home page

/// Simple onboarding flow that lets the user choose a language.

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String? selectedLanguage;
  final List<String> languages = ['English', 'Swahili', 'Français'];
  final Map<String, String> languageCodes = {
    'English': 'en',
    'Swahili': 'sw',
    'Français': 'fr',
  };
  final Color brandColor = Color(0xFFD32F2F); // Example brand color

  /// Marks onboarding as finished and saves the selected language.

  Future<void> completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    if (selectedLanguage != null) {
      await prefs.setString('languageCode', languageCodes[selectedLanguage!]!);
    }
  }

  /// Alerts the user when they attempt to continue without choosing a language.

  void showLanguageSelectionPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final loc = AppLocalizations(Provider.of<LanguageProvider>(context, listen: false).languageCode);
        return AlertDialog(
          title: Text(loc.translate('no_language_selected'),
            style: TextStyle(
              color: ColorPalette().scaffoldBg,
            ),
          ),
          content: Text(loc.translate('please_select_language')),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final loc = AppLocalizations(languageProvider.languageCode);

    return Scaffold(
      backgroundColor:  ColorPalette().classicProject,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(

            children: <Widget>[
              const SizedBox(height: 60),
              Image.asset(
                'assets/images/language_icon.png', // Path to your image asset
                height: 100,
              ),
              SizedBox(height: 40),
              Text(
                loc.translate('select_language'),
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 30),
              ...languages.map((language) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedLanguage == language ? Colors.white : ColorPalette().emirateRed,
                    foregroundColor: selectedLanguage == language ? brandColor : Colors.white,
                    shadowColor: Colors.black,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      side: BorderSide(color: Colors.white),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    final code = languageCodes[language]!;
                    Provider.of<LanguageProvider>(context, listen: false).setLanguage(code);
                    setState(() {
                      selectedLanguage = language;
                    });
                  },
                  child: Text(language),
                ),
              )).toList(),
              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: brandColor,
                  shadowColor: Colors.black,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                onPressed: () async {
                  if (selectedLanguage != null) {
                    Provider.of<LanguageProvider>(context, listen: false)
                        .setLanguage(languageCodes[selectedLanguage!]!);
                    await completeOnboarding();
                    Navigator.of(context).pushReplacement(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) {
                          return const DashboardOfFragments();
                        },
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                        transitionDuration: const Duration(milliseconds: 500),
                      ),
                    );
                    print(languageCodes[selectedLanguage!]);
                  } else {
                    showLanguageSelectionPrompt(context);
                  }
                },
                child: Text(loc.translate('continue')),
              ),
            ],
          ),
        ),
      ),
    );

  }

}
class DashboardOfFragments extends StatefulWidget {
  const DashboardOfFragments({super.key});

  @override
  State<DashboardOfFragments> createState() => _DashboardOfFragmentsState();
}
class _DashboardOfFragmentsState extends State<DashboardOfFragments> {

  int _currentIndex =0;
  final _items = [
    SalomonBottomBarItem(icon: const Icon(Icons.home), title: const Text('Home'),
        selectedColor: Colors.black,
        unselectedColor: ColorPalette().classicyellow
    ),
    SalomonBottomBarItem(icon: const Icon(Icons.book), title: const Text('Booking'),
        selectedColor: Colors.black,
        unselectedColor: ColorPalette().classicyellow
    ),
    SalomonBottomBarItem(icon: const Icon(Icons.notification_add_sharp), title: const Text('Ads'),
        selectedColor: Colors.black,
        unselectedColor: ColorPalette().classicyellow
    ),

    SalomonBottomBarItem(icon: const Icon(Icons.contact_phone), title: const Text('Contact'),
        selectedColor: Colors.black,
        unselectedColor: ColorPalette().classicyellow

    ),
    SalomonBottomBarItem(icon: const Icon(Icons.settings_applications_sharp), title: const Text('Settings'),
        selectedColor: Colors.black,
        unselectedColor: ColorPalette().classicyellow

    ),
  ];
  final _screens=[
    MyApp(),
    bookingFragmentScreen(),
    adsScreen(),
    ContactFragmentScreen(),
    setting(),




  ];
  @override
  Widget build(BuildContext context){

    return Scaffold(

      //backgroundColor: ColorPalette().classicProject,
      body: _screens[_currentIndex],
      bottomNavigationBar: Card(
        elevation: 9,


        child: Container(

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(

                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 0),

              ),

            ],
          ),
          child: ClipRRect(

            borderRadius: BorderRadius.only(
              topRight: Radius.circular(15),
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),

            ),

            child: SalomonBottomBar(

              backgroundColor: ColorPalette().classicProject,
              duration: Duration(seconds: 1),
              items: _items,
              currentIndex: _currentIndex,
              onTap: (index)=>setState(() {
                _currentIndex = index;
              }),

            ),
          ),
        ),
      ),
    );
  }


}