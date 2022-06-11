import 'dart:convert';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:Sprint2/screen/login.dart';
import 'package:http/http.dart' as http;
import 'package:Sprint2/ipaddress.dart' as ip;

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formkey = GlobalKey<FormState>();
  // String baseurl = "http://127.0.0.1:90/customer";
  String baseurl = ip.main() + "customer";

  String firstname = '';
  String lastname = '';
  String username = '';
  String password = '';

  Future<bool> resUser() async {
    Map<String, dynamic> userdata = {
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'password': password,
    };
    try {
      final response =
          await http.post(Uri.parse(baseurl + '/register'), body: userdata);
      //using the token in the headers
      print("hello");
      var data = jsonDecode(response.body) as Map;
      print(data);
      bool success = data['success'];
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
          padding: const EdgeInsets.all(25),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                Image.asset(
                  'imag/signup.jpg',
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  onSaved: (newValue) => {firstname = newValue!},
                  validator: MultiValidator(
                      [RequiredValidator(errorText: '*Required')]),
                  decoration: const InputDecoration(
                    labelText: 'Firstname',
                    hintText: 'Enter your first name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onSaved: (newValue) => {lastname = newValue!},
                  validator: MultiValidator(
                      [RequiredValidator(errorText: '*Required')]),
                  decoration: const InputDecoration(
                    labelText: 'Lastname',
                    hintText: 'Enter your last name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onSaved: (newValue) => {username = newValue!},
                  validator: MultiValidator(
                      [RequiredValidator(errorText: '*Required')]),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Enter your Username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  onSaved: (newValue) => {password = newValue!},
                  validator: MultiValidator(
                      [RequiredValidator(errorText: '*Required')]),
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your Password',
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
                      bool success = await resUser();
                      if (success == true) {
                        // token save
                        Navigator.pushNamed(context, '/login');
                        MotionToast.success(
                                description: const Text('Registration success'))
                            .show(context);
                      } else {
                        MotionToast.error(
                                description:
                                    const Text('Username already exist.'))
                            .show(context);
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
                const SizedBox(height: 30),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: RichText(
                      text: const TextSpan(children: [
                    TextSpan(
                      text: "Already have an account?",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.blue,
                        // ,
                      ),
                    ),
                    TextSpan(
                      text: '  Login',
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
