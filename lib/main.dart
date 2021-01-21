import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Weather Aoo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'The Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  
  List<Widget> weatherCards = [];
  final String API_KEY = "ce762617a85ee096abe013baa1985d7e";
  TextEditingController tec = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView(
          children: weatherCards,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showDialog,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text("Add City"),
              content: TextField(
                controller: tec,
                decoration: InputDecoration(
                    border: InputBorder.none, hintText: 'Enter a search term'),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Add'),
                  onPressed: () {
                    _getWeather(tec.value.text);
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Future<List<void>> _getWeather(var city) async {
    print('city is ${city}');
    var res = await http.get('https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${API_KEY}');
    Map<String, dynamic> body = jsonDecode(res.body);
    setState(() {
      weatherCards = [
        ...weatherCards,
        Padding(
          padding: const EdgeInsets.fromLTRB(64,10,64,10),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),            
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text('${city} has a current temperature of ${body['main']['temp'].toString()}'),
            )
          ),
        )
      ];
    });
  }
}
