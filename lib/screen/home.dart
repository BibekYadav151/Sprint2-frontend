import 'dart:async';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:Sprint2/widgets/mydrawer.dart';


import 'package:Sprint2/ipaddress.dart' as ip;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    super.initState();
    listenSensor();

    ///
  }

  @override
  void dispose() {
    super.dispose();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
        print(_isNear);
      });
      _isNear
          ? (Navigator.pushNamed(context, '/login'))
          : print('object'); //afno afno
    });
  }

  String baseurl = ip.main();

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sprint 2"),
      ),
      drawer: Mydrawer(context),
      backgroundColor: const Color(0xffe5e4e4),
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: FutureBuilder(
              
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            
                            Container(
                              height: 130,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 13, vertical: 8),
                              width: MediaQuery.of(context).size.width,
                              child: GestureDetector(
                                onTap: () {
                                 
                                },
                                child: Card(
                                  child: Stack(
                                    children: <Widget>[
                                      Container(
                                        height: 130,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: NetworkImage(baseurl +
                                                snapshot.data[index]
                                                    ['deimage']),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        left: 8,
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                            Text(
                                              snapshot.data[index]['dname'],
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(child: const Text("no data"));
              })),
    );
  }
}
