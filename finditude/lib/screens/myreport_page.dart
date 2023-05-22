import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:finditude/services/UserPreferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:finditude/screens/login_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MyReportPage extends StatefulWidget {
  final int id;
  const MyReportPage({super.key, required this.id});

  @override
  State<MyReportPage> createState() => _MyReportPageState();
}

class _MyReportPageState extends State<MyReportPage> {
  String token = "";
  List<String> imageUrls = [];
  late Future<MissingPerson> futureMissingPerson;
  late Future<List<LatLng>> futureLocations;

  Future<List<String>> fetchMissingImages(int id) async {
    const url = 'http://20.2.65.191:8000/api/missingimageget';
    final body = jsonEncode({'jwt': token, 'id': id.toString()});
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    final response =
        await http.post(Uri.parse(url), headers: header, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final List<dynamic> imageList = jsonResponse['images'];
      final List<String> images = imageList.cast<String>().toList();
      return images;
    } else {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
    return [];
  }

  Future<List<LatLng>> fetchLocations(int id) async {
    const url = 'http://20.2.65.191:8000/api/getlocation';
    final body = jsonEncode({'jwt': token, 'id': id.toString()});
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    final response =
        await http.post(Uri.parse(url), headers: header, body: body);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      //final List<dynamic> latitudes = jsonResponse['latitudes'];
      final dynamic latitudeData = jsonResponse['lattitudes'];
      final List<dynamic> latitudes =
          latitudeData != null ? List<dynamic>.from(latitudeData) : [];

      final dynamic longitudeData = jsonResponse['longitudes'];

      //final List<dynamic> longitudes = jsonResponse['longitudes'];
      final List<dynamic> longitudes =
          longitudeData != null ? List<dynamic>.from(longitudeData) : [];
      //print(latitudes[0]);
      final List<LatLng> locations = [];
      for (int i = 0; i < latitudes.length; i++) {
        final double latitude = double.parse(latitudes[i]);
        final double longitude = double.parse(longitudes[i]);
        final LatLng location = LatLng(latitude, longitude);
        locations.add(location);
      }
      return locations;
    } else {
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    }
    return [];
  }

  @override
  void initState() {
    super.initState();
    token = UserPreferences.getToken();
    futureMissingPerson = fetchMissingPerson(token, widget.id, context);
    fetchMissingImages(widget.id).then((images) {
      setState(() {
        imageUrls = images;
      });
    }).catchError((error) {
      // Handle any error that occurred during API call
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
        );
      }
    });
    futureLocations = fetchLocations(widget.id);
  }

  void openImageSlider(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            child: ListView.builder(
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
                return Image.network(imageUrls[index]);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "My Report",
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            openImageSlider(context);
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            color: Colors.grey,
                            child: imageUrls.isNotEmpty
                                ? Image.network(
                                    imageUrls[0],
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.fullName,
                                style: GoogleFonts.dmSans(
                                  textStyle:
                                      Theme.of(context).textTheme.titleLarge,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Age: ${snapshot.data!.age}",
                                    style: GoogleFonts.dmSans(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                  Text(
                                    "Gender: ${snapshot.data!.gender}",
                                    style: GoogleFonts.dmSans(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const SizedBox(height: 16),
                  FutureBuilder<List<LatLng>>(
                    future: futureLocations,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final List<LatLng> locations = snapshot.data!;
                        if (locations.isEmpty) {
                          return const Text("No Reports were Found");
                        } else {
                          return SizedBox(
                            height: 300,
                            child: GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: locations.first,
                                zoom: 12.0,
                              ),
                              markers: Set<Marker>.from(
                                locations.map(
                                  (LatLng location) => Marker(
                                    markerId: MarkerId(location.toString()),
                                    position: location,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
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
      Uri.parse("http://20.2.65.191:8000/api/missingget"),
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
