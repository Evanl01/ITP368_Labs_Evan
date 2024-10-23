// Barrett Koster 2024
// demo of pinging a database of images

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
// from command line> flutter pub add http
// > flutter pub add flutter_bloc
// > flutter pub add http
// > flutter pub add web_socket_channel


void main() // PingLob
{ runApp(const PingLob());
}

// just holds a string.  In Ping1, it is the URL of a 
// picture.
class MsgState
{ String msg;
  MsgState( this.msg );
}
class MsgCubit extends Cubit<MsgState>
{ MsgCubit() : super( MsgState("zip") );
  MsgCubit.s(String s ) : super( MsgState(s));
  void update(String m) { emit(MsgState(m)); }
}

class PingLob extends StatelessWidget
{
 const PingLob({super.key});

  @override
  Widget build( BuildContext context )
  { return MaterialApp
    ( title: "Ping Lob",
      home: Scaffold
      ( appBar: AppBar( title: Text("Ping Lob") ),
        body: Row
        ( children:
          [ Ping1(),
          ],
        ),
      ),
    );
  }
}

class BB extends Container
{
  BB( String s ) : super
      ( decoration: BoxDecoration
      ( border: Border.all(width:2),),
      width:100, height:50,
      child: Text(s, style: const TextStyle(fontSize: 20) ),
    );
}

class Ping1 extends StatelessWidget {
  const Ping1({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController zipController = TextEditingController();
    String weatherInfo = "Enter a Zip Code to get weather information";

    return BlocProvider<MsgCubit>(
      create: (context) => MsgCubit.s(""),
      child: BlocBuilder<MsgCubit, MsgState>(
        builder: (context, state) {
          return Builder(
            builder: (context) {
              MsgCubit mc = BlocProvider.of<MsgCubit>(context);
              return Padding(
                padding: const EdgeInsets.all(16.0), // Add padding here
                child: Column(
                  children: [
                    SizedBox(
                      width: 200, height: 50, // Set a finite width
                      child: TextField(
                        controller: zipController,
                        decoration: InputDecoration(
                          labelText: "Enter Zip Code",
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Container(
                      width: 150, height: 30,
                      margin: EdgeInsets.only(top: 10), // Add margin if needed
                      child: ElevatedButton(
                        onPressed: () async {
                          String zip = zipController.text;
                          if (_isValidZip(zip)) {
                            weatherInfo = await _getWeather(zip);
                            mc.update(weatherInfo);
                          } else {
                            mc.update("Invalid Zip Code");
                          }
                        },
                        child: Text("Get Weather"),
                      ),
                    ),
                    Text(mc.state.msg),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  bool _isValidZip(String zip) {
    final zipRegExp = RegExp(r'^\d{5}$');
    return zipRegExp.hasMatch(zip);
  }

  Future<String> _getWeather(String zip) async {
    final apiKey = '4b85af927c254d3da3044236242310';
    final url = Uri.parse('https://api.weatherapi.com/v1/current.json?key=$apiKey&q=$zip');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      String location = data['location']['name'];
      String temp = data['current']['temp_c'].toString();
      String condition = data['current']['condition']['text'];
      return "Location: $location\nTemperature: $temp°C\nCondition: $condition";
    } else {
      return "Failed to get weather information";
    }
  }
}