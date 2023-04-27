import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finditude/services/UserPreferences.dart';
import 'package:finditude/screens/login_page.dart';

class StartFindingPage extends StatefulWidget {
  final int id;
  const StartFindingPage(this.id, {super.key});

  @override
  State<StartFindingPage> createState() => _StartFindingPageState();
}

class _StartFindingPageState extends State<StartFindingPage> {
  String token = "";
  late Future<MissingPerson> futureMissingPerson;

  @override
  void initState() {
    super.initState();
    token = UserPreferences.getToken();
    futureMissingPerson = fetchMissingPerson(token, widget.id, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "",
          style: GoogleFonts.dmSans(
              color: const Color(0xff1cb439),
              textStyle: Theme.of(context).textTheme.headlineSmall,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<MissingPerson>(
          future: futureMissingPerson,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          child: Text(
                            snapshot.data!.fullName,
                            style: GoogleFonts.dmSans(
                              textStyle:
                                  Theme.of(context).textTheme.displayLarge,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Age: ${snapshot.data!.age}",
                        style: GoogleFonts.dmSans(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Gender: ${snapshot.data!.gender}",
                        style: GoogleFonts.dmSans(
                          textStyle: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      Text("Identifying Information",
                          style: GoogleFonts.dmSans(
                            textStyle:
                                Theme.of(context).textTheme.headlineSmall,
                            color: const Color.fromARGB(255, 136, 136, 136),
                          ))
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Text(
                            snapshot.data!.identifyingInfo,
                            style: GoogleFonts.dmSans(
                              textStyle: Theme.of(context).textTheme.bodyLarge,
                            ),
                            softWrap: true,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor:
                                const Color.fromARGB(255, 34, 182, 46),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(18),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {},
                          child: const Center(
                            child: Text(
                              "Start Finding",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}

Future<MissingPerson> fetchMissingPerson(
    String token, int id, BuildContext context) async {
  Map data = {"jwt": token, "id": id};
  Map<String, String> header = {
    "Content-Type": "application/json",
  };
  var body = jsonEncode(data);
  final response = await http.post(
      Uri.parse("http://192.168.1.168:8000/api/missingget"),
      headers: header,
      body: body);
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return MissingPerson.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    if (context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    }
    return const MissingPerson(
        fullName: "", age: -1, gender: "", identifyingInfo: "");
  }
}

class MissingPerson {
  final String fullName;
  final int age;
  final String gender;
  final String identifyingInfo;

  const MissingPerson({
    required this.fullName,
    required this.age,
    required this.gender,
    required this.identifyingInfo,
  });

  factory MissingPerson.fromJson(Map<String, dynamic> json) {
    return MissingPerson(
      fullName: json['full_name'],
      age: json['age'],
      gender: json['gender'],
      identifyingInfo: json['identifying_info'],
    );
  }
}
