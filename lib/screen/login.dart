import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:form_field_validator/form_field_validator.dart';

import 'package:Sprint2/screen/register.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'package:Sprint2/ipaddress.dart' as ip;
import 'package:awesome_notifications/awesome_notifications.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();

  // String baseurl = "http://127.0.0.1:90/customer";
  String baseurl = ip.main() + "customer";
  String token = '';
  String userId = '';
  String username = '';
  String password = '';
  String userid = '';
  late SharedPreferences prefs;
  // to save uid and token
  

  savetoken(tok, uname, uid) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("token", tok);
    prefs.setString("username", uname);
    prefs.setString("userId", uid);
  }

  Future<bool> loginUser(String username, String password) async {
    Map<String, dynamic> userdata = {
      'username': username,
      'password': password,
      // 'thumbnail': _thumbnail
    };

    try {
      final response =
          await http.post(Uri.parse(baseurl + '/login'), body: userdata);
      var data = jsonDecode(response.body) as Map;
      bool success = data['success'];
      token = data["token"];
      username = data["username"];
      userId = data["userId"];
      savetoken(token, username, userId);
      return success;
    } catch (e) {
      print(e);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                const Text(
                  "WELCOME",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                ),
                Image.asset(
                  'imag/login.jpg',
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onSaved: (newValue) => {username = newValue!},
                  validator: MultiValidator(
                      [RequiredValidator(errorText: '*Required')]),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onSaved: (newValue) => {password = newValue!},
                  validator: MultiValidator(
                      [RequiredValidator(errorText: '*Required')]),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    primary: Colors.red, // background
                    onPrimary: Colors.white,
                  ),
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      _formkey.currentState!.save();
                      bool res = await loginUser(username, password);
                       if (res == true) {
                        
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage()));
                        MotionToast.success(
                                description: const Text('Login success'))
                            .show(context);
                      } 
                    }
                  },
                  child: const Text('Login'),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterScreen()));
                  },
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                      text: "Don't have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        // ,
                      ),
                    ),
                    TextSpan(
                      text: '  Sign Up',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.grey,
                        // decoration: TextDecoration.underline,
                        // decorationThickness: 2,
                      ),
                    ),
                  ])),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
