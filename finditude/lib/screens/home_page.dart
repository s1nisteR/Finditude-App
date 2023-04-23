import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finditude/services/UserPreferences.dart';
import 'package:finditude/screens/report_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = "";

  @override
  void initState() {
    super.initState();
    //fetch token from persistent storage
    token = UserPreferences.getToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text(
            "Good Evening",
            style: GoogleFonts.dmSans(
                color: const Color(0xff1cb439),
                textStyle: Theme.of(context).textTheme.headlineSmall,
                fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      Navigator.of(context).push(homeToReportMissing());
                    },
                    child: const SizedBox(
                        width: 340,
                        height: 160,
                        child: Center(child: Text("Report Missing"))),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: InkWell(
                    splashColor: Colors.blue.withAlpha(30),
                    onTap: () {
                      //for testing only, will cause the user preferences to clear up
                      UserPreferences.setToken("");
                    },
                    child: const SizedBox(
                        width: 340,
                        height: 160,
                        child: Center(child: Text("Volunteer"))),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 0, bottom: 0, top: 0),
                child: Text(
                  "Your Reports",
                  style: GoogleFonts.dmSans(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    textStyle: Theme.of(context).textTheme.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

Route homeToReportMissing() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => const ReportPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
