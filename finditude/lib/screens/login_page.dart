import 'dart:convert';

import 'package:finditude/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'package:finditude/screens/register_page.dart';
import 'package:finditude/services/UserPreferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String token = "";

  void postData(String email, String password) async {
    if (email == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email or password cannot be empty!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
      ));
      return;
    }
    Map data = {
      "email": email,
      "password": password,
    };
    Map<String, String> header = {
      "Content-Type": "application/json",
    };
    var body = jsonEncode(data);
    try {
      final response = await http.post(
        Uri.parse("http://192.168.1.168:8000/api/login"),
        body: body,
        headers: header,
      );
      if (response.statusCode == 200) {
        UserPreferences.setToken(jsonDecode(response.body)['jwt']);
        //Go to the homepage now
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (Route<dynamic> route) => false);
        } else if (response.statusCode == 401) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Incorrect email or password!",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Color.fromARGB(255, 59, 59, 59),
            ));
          }
        }
      }
    } catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("There was an unexpected error!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
      ));
    }
  }

  @override
  initState() {
    super.initState();
    //do stuff here to run during initialization
    //get the token first!
    token = UserPreferences.getToken();
    //print(token);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "finditude",
          style: GoogleFonts.dmSans(
              color: const Color(0xff1cb439),
              textStyle: Theme.of(context).textTheme.headlineSmall,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: size.height * 0.2,
              top: size.height * 0.05),
          color: Colors.black,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 120,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff141215),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: emailController,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Email",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff141215),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  autocorrect: false,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Password",
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text("Forgot Password?",
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () =>
                        postData(emailController.text, passwordController.text),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Center(
                        child: Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(loginToRegister());
                    },
                    child: Text("Create Account",
                        style: Theme.of(context).textTheme.bodyLarge),
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

Route loginToRegister() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        const RegisterPage(),
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
