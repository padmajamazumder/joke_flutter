import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Joke Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JokeScreen(),
    );
  }
}

class JokeScreen extends StatefulWidget {
  @override
  _JokeScreenState createState() => _JokeScreenState();
}
class _JokeScreenState extends State<JokeScreen> {
  String hey = ''; 
  String punchline = '';

  Future<void> fetchJoke() async {
    try {
      final response = await http.get(Uri.parse('https://official-joke-api.appspot.com/random_joke'));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          hey = data['setup']; // Update variable assignment to 'hey'
          punchline = data['punchline'];
        });

        // Added print statement to log the API response
        print('API Response: $data');
      } else {
        throw Exception('Failed to load joke');
      }
    } catch (e) {
      print('Error making API request: $e');
      
    }
  }

  @override
  void initState() {
    super.initState();
    fetchJoke();
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Random Joke Generator'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '😄 Joke of the Day 😄',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Hey!!', // Change the text to 'Hey!!'
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                '$hey', // Update variable reference to 'hey'
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Punchline:',
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
              ),
              Text(
                '$punchline',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: fetchJoke,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Button color
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text('Get Another Joke'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}