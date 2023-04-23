import 'package:finditude/screens/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finditude/services/UserPreferences.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String token = "";
  String gender = "Other";
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController identifyingInfoController =
      TextEditingController();
  var genders = [
    "Male",
    "Female",
    "Transgender",
    "Other",
  ];

  void postData(String fullName, String age, String gender,
      String identifyingInfo) async {
    if (fullName == "" || age == "" || gender == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("One or more fields are empty!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
      ));
      return;
    }
    try {
      Map data = {
        "jwt": token,
        "full_name": fullName,
        "age": age,
        "gender": gender,
        "identifying_info": identifyingInfo,
      };
      Map<String, String> header = {
        "Content-Type": "application/json",
      };
      var body = jsonEncode(data);
      final response = await http.post(
          Uri.parse("http://192.168.1.168:8000/api/missingreg"),
          headers: header,
          body: body);
      if (response.statusCode == 200) {
        if (context.mounted) {
          Navigator.of(context).pop();
        }
      } else if (response.statusCode == 401) {
        //token may have expired, back to login you go!
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (Route<dynamic> route) => false,
          );
        }
      }
    } catch (err) {
      //handle when response returned states user is unauthenticated by redirecting to login page
      debugPrint(err.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    token = UserPreferences.getToken();
    debugPrint(token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Report",
          style: GoogleFonts.dmSans(
              color: const Color(0xff1cb439),
              textStyle: Theme.of(context).textTheme.headlineSmall,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 5.0,
                ),
                child: Text(
                  "Full Name",
                  style: GoogleFonts.dmSans(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff141215),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: fullNameController,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 5.0,
                ),
                child: Text(
                  "Age",
                  style: GoogleFonts.dmSans(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff141215),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 5.0,
                ),
                child: Text(
                  "Gender",
                  style: GoogleFonts.dmSans(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: const BoxDecoration(
                    color: Color(0xff141215),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: DropdownButton(
                    underline: const SizedBox(),
                    isExpanded: true,
                    value: gender,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: genders.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        gender = newValue!;
                      });
                    },
                  )),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 0.0,
                  top: 0.0,
                  bottom: 5.0,
                ),
                child: Text(
                  "Identifying Information",
                  style: GoogleFonts.dmSans(
                      color: const Color.fromARGB(255, 255, 255, 255),
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff141215),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: identifyingInfoController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      postData(fullNameController.text, ageController.text,
                          gender, identifyingInfoController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 255, 3, 3),
                      foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Center(
                        child: Text(
                      "Report As Missing",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 0, 0)),
                    )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
