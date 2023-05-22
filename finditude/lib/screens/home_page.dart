import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finditude/services/UserPreferences.dart';
import 'package:finditude/screens/report_page.dart';
import 'package:finditude/screens/volunteer.dart';
import 'package:finditude/screens/login_page.dart';
import 'package:http/http.dart' as http;
import 'package:finditude/screens/finding_page.dart';
import 'package:finditude/screens/myreport_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String token = "";
  List<dynamic> reports = [];
  List<dynamic> findings = [];
  Map<int, String> reportImages = {};
  Map<int, String> findingImages = {};

  @override
  void initState() {
    super.initState();
    //fetch token from persistent storage
    token = UserPreferences.getToken();
    fetchReports(); //fetch the reports
    fetchFindings(); //fetch the currently finding
  }

  Future<void> fetchReports() async {
    try {
      final response = await http.post(
        Uri.parse("http://20.2.65.191:8000/api/getreports"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "jwt": token,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<int> fetchedReports = List<int>.from(data['reports']);
        setState(() {
          reports = fetchedReports;
        });
        await fetchReportImages(); // Fetch the images for each report
      } else {
        // Handle other HTTP status codes
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> fetchReportImages() async {
    try {
      for (int reportId in reports) {
        final response = await http.post(
          Uri.parse("http://20.2.65.191:8000/api/missingimageget"),
          headers: {"Content-Type": "application/json"},
          body: '{"jwt": "$token", "id": "$reportId"}',
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.containsKey('images') &&
              data['images'] is List &&
              data['images'].isNotEmpty) {
            setState(() {
              reportImages[reportId] = data['images'][0];
            });
          }
        } else {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> fetchFindings() async {
    try {
      final response = await http.post(
        Uri.parse("http://20.2.65.191:8000/api/getfindings"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "jwt": token,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<int> fetchedFindings = List<int>.from(data['findings']);
        setState(() {
          findings = fetchedFindings;
        });
        await fetchFindingImages();
      } else {
        // Handle other HTTP status codes
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  Future<void> fetchFindingImages() async {
    try {
      for (int reportId in reports) {
        final response = await http.post(
          Uri.parse("http://20.2.65.191:8000/api/missingimageget"),
          headers: {"Content-Type": "application/json"},
          body: '{"jwt": "$token", "id": "$reportId"}',
        );
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          if (data.containsKey('images') &&
              data['images'] is List &&
              data['images'].isNotEmpty) {
            setState(() {
              findingImages[reportId] = data['images'][0];
            });
          }
        } else {
          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
              (Route<dynamic> route) => false,
            );
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
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
                  child: Container(
                    width: 340,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/report.png'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black
                              .withOpacity(0.7), // Adjust the opacity as needed
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.of(context).push(homeToReportMissing());
                      },
                      child: Center(
                        child: Text(
                          "Report",
                          style: GoogleFonts.dmSans(
                              color: const Color.fromARGB(255, 211, 7, 7),
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
                  child: Container(
                    width: 340,
                    height: 160,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage('assets/search.jpg'),
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                          Colors.black
                              .withOpacity(0.7), // Adjust the opacity as needed
                          BlendMode.darken,
                        ),
                      ),
                    ),
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onTap: () {
                        Navigator.of(context).push(homeToVolunteerPage());
                      },
                      child: Center(
                        child: Text(
                          "Volunteer",
                          style: GoogleFonts.dmSans(
                              color: const Color(0xff1cb439),
                              textStyle:
                                  Theme.of(context).textTheme.headlineMedium,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
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
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: reports
                      .length, // Replace with the actual number of reports
                  itemBuilder: (BuildContext context, int index) {
                    int reportId = reports[index];
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(homeToMyReportPage(reportId));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            image: reportImages.containsKey(reportId)
                                ? DecorationImage(
                                    image:
                                        NetworkImage(reportImages[reportId]!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 0, bottom: 0, top: 0),
                child: Text(
                  "Currently Finding",
                  style: GoogleFonts.dmSans(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    textStyle: Theme.of(context).textTheme.headlineSmall,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: findings
                      .length, // Replace with the actual number of reports
                  itemBuilder: (BuildContext context, int index) {
                    int reportId = findings[index];
                    return Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context)
                              .push(homeToFindingPage(reportId));
                        },
                        child: Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                            image: findingImages.containsKey(reportId)
                                ? DecorationImage(
                                    image:
                                        NetworkImage(findingImages[reportId]!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
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

Route homeToVolunteerPage() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const VolunteerPage(),
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

Route homeToFindingPage(int missingid) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        FindingPage(id: missingid),
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

Route homeToMyReportPage(int missingid) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        MyReportPage(id: missingid),
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
