import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finditude/services/UserPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finditude/screens/login_page.dart';
import 'package:finditude/screens/start_finding_page.dart';

class VolunteerPage extends StatefulWidget {
  const VolunteerPage({super.key});

  @override
  State<VolunteerPage> createState() => _VolunteerPageState();
}

class _VolunteerPageState extends State<VolunteerPage> {
  String token = "";
  //List<MissingPerson> _dataList = [];
  Future<List<dynamic>>? _futureData;

  Future<List<dynamic>> fetchMissingPerson(
      String token, BuildContext context) async {
    Map data = {"jwt": token};
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var body = jsonEncode(data);
    final response = await http.post(
        Uri.parse("http://192.168.1.168:8000/api/missingrandom"),
        headers: header,
        body: body);
    if (response.statusCode == 200) {
      //String stuff =
      """[{"id": 1, "full_name": "Matthews Ankon Baroi"}, {"id": 8, "full_name": "hshshs"}, {"id": 5, "full_name": "test"}, {"id": 11, "full_name": "final_test"}, {"id": 2, "full_name": "Ankon Baroi"}, {"id": 7, "full_name": "sjsjsjs"}, {"id": 6, "full_name": "sjsjs"}, {"id": 9, "full_name": "shajjajssjsjjsjjsjajajaua"}, {"id": 4, "full_name": "Shex Sami"}, {"id": 3, "full_name": "Shex Shafi-Ul Hasan Sami"}, {"id": 10, "full_name": "a"}]""";
      return jsonDecode(response.body) as List<dynamic>;
      //final jsonData = json.decode(response.body);
      /*
      final dataList = (jsonData as List)
          .map((json) => MissingPerson.fromJson(json))
          .toList();
      setState(() {
        _dataList = dataList;
      });
      */
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
    }
    return jsonDecode(
        ""); //TODO: Could cause some issues, see if there are better ways to handle nullable stuff
  }

  @override
  void initState() {
    super.initState();
    token = UserPreferences.getToken();
    _futureData = fetchMissingPerson(token, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Volunteer",
          style: GoogleFonts.dmSans(
              color: const Color(0xff1cb439),
              textStyle: Theme.of(context).textTheme.headlineSmall,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<dynamic>>(
          future: _futureData,
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<dynamic> dataList = snapshot.data!;

              return SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                  ),
                  itemCount: dataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map<String, dynamic> item = dataList[index];
                    return GestureDetector(
                      onTap: () => Navigator.of(context)
                          .push(volunteerToStartFinding(item['id'])),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item['full_name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 8),
                              //Text("ID: ${item['id']}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            // By default, show a loading spinner
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class MissingPerson {
  final int id;
  final String fullName;

  const MissingPerson({
    required this.id,
    required this.fullName,
  });

  factory MissingPerson.fromJson(Map<String, dynamic> json) {
    return MissingPerson(
      id: json['id'],
      fullName: json['full_name'],
    );
  }
}

Route volunteerToStartFinding(int id) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        StartFindingPage(id),
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
