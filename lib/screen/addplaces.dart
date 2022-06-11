import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:Sprint2/ipaddress.dart' as ip;


class AddPlaces extends StatefulWidget {
  const AddPlaces({Key? key}) : super(key: key);

  @override
  State<AddPlaces> createState() => _AddPlacesState();
}

class _AddPlacesState extends State<AddPlaces> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String dename = '';
  String description = '';
  File? _thumbnail;
  static String token = '';
  static String userId = '';
  static String un = '';

  late SharedPreferences prefs;

  getTok() async {
    prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId")!;
    token = prefs.getString("token")!;
    un = prefs.getString("username")!;
    print("Token " + token);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _thumbnail = null;
    getTok();
  }

  Future<bool> insertPlace() async {
    print("hello");
    try {
      var postUri = Uri.parse(ip.main() + "add-destination");
      var request = new http.MultipartRequest("post", postUri);
      // print(request);
      //Header....
      // request.headers['Authorization'] = 'Bearer ${token}';
      request.fields['dname'] = dename;
      request.fields['description'] = description;

      // image
      request.files
          .add(await http.MultipartFile.fromPath('ff', _thumbnail!.path));
      http.StreamedResponse response = await request.send();
      print(response);
      final respStr = await response.stream.bytesToString();
      var jsonData = jsonDecode(respStr);
      print(jsonData['data']);
      return jsonData['success'];
    } catch (e) {
      return false;
    }
  }

  // open image from camera
  _thumbnailFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      _thumbnail = File(image!.path);
    });
  }

  // open image from gallery
  _thumbnailFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      _thumbnail = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Place"),
          // title: Text("${token}"),
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Center(
                    child: _buildThumbnail(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Place Name';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        dename = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Place name',
                        prefixIcon: Icon(Icons.title),
                        hintText: "Place name",
                      ),
                      maxLength: 200,
                    ),
                  ),
                  TextFormField(
                    onChanged: (value) {
                      description = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Description';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      // enabledBorder: OutlineInputBorder(
                      //   borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      //   borderSide: BorderSide(color: Colors.black, width: 1.0),
                      // ),
                      labelText: 'Description',
                      prefixIcon: Icon(Icons.explore),
                    ),
                    maxLines: 5,
                  ),
                  Padding(
                    padding: EdgeInsets.all(50),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          bool SS = await insertPlace();
                          if (SS) {
                            // token save
                           
                            MotionToast.success(
                                    description: Text('Place added '))
                                .show(context);
                          } else {
                            MotionToast.error(
                                    description: Text('Something is wrong!'))
                                .show(context);
                          }
                        }
                      },
                      child: Text("Add"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

// thumbnail
  Widget _buildThumbnail() {
    return Stack(
      children: [
        CircleAvatar(
            radius: 50,
            backgroundImage: _thumbnail == null
                ? const AssetImage('imag/hello.jpg') as ImageProvider
                : FileImage(_thumbnail!),
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                    context: context, builder: (builder) => bottomSheet());
              },
              child: const Icon(
                Icons.camera,
                color: Colors.white,
                size: 30,
              ),
            ))
      ],
    );
  }

  // bottomsheet
  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            "Choose photo from",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    _thumbnailFromCamera();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.camera),
                  label: Text('Camera')),
              SizedBox(
                width: 30,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    _thumbnailFromGallery();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.image),
                  label: Text('Gallery')),
            ],
          )
        ],
      ),
    );
  }
}
