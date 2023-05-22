import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //All TextEditingControllers
  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  void postData(String firstName, String lastName, String email,
      String password, String confirmPassword) async {
    if (firstName == "" || lastName == "" || email == "" || password == "") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("One or more fields are empty!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
      ));
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Passwords must match!",
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromARGB(255, 59, 59, 59),
      ));
      return;
    }
    try {
      Map data = {
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "password": password,
      };
      Map<String, String> header = {
        "Content-Type": "application/json",
      };
      var body = jsonEncode(data);
      final response = await http.post(
          Uri.parse("http://20.2.65.191:8000/api/register"),
          headers: header,
          body: body);
      if (response.statusCode == 403) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("A user with this email already exists!",
                style: TextStyle(color: Colors.white)),
            backgroundColor: Color.fromARGB(255, 59, 59, 59),
          ));
        }
        return;
      } else {
        if (context.mounted) {
          Navigator.of(context).pop();
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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          "Register",
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
                  controller: firstNameController,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "First Name",
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
                  controller: lastNameController,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Last Name",
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
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                decoration: const BoxDecoration(
                  color: Color(0xff141215),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                child: TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  autocorrect: false,
                  cursorColor: const Color(0xff1cb439),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Confirm Password",
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => postData(
                        firstNameController.text,
                        lastNameController.text,
                        emailController.text,
                        passwordController.text,
                        confirmPasswordController.text),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color.fromARGB(255, 34, 182, 46),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.all(18),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    child: const Center(
                        child: Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text("Already Have an Account?",
                        style: Theme.of(context).textTheme.bodyLarge),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
