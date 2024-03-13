import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class MyFancyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Set status bar color to transparent
    ));
    return MaterialApp(
      home: FancyPage(),
    );
  }
}

class FancyPage extends StatefulWidget {
  @override
  _FancyPageState createState() => _FancyPageState();
}

class _FancyPageState extends State<FancyPage> {
  double _width = 200;
  double _height = 200;
  Color _color = Colors.blue;
  BorderRadiusGeometry _borderRadius = BorderRadius.circular(8);

  void _randomize() {
    setState(() {
      // Generate random values for the animated container
      _width = 100 + (200 * (1 + 0.5));
      _height = 100 + (200 * (1 + 0.5));
      _color = Color.fromRGBO(
        (1 + 100) % 255,
        (1 + 150) % 255,
        (1 + 200) % 255,
        1,
      );
      _borderRadius = BorderRadius.circular((1 + 0.5) * 64);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fancy Flutter Page'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.pinkAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              AnimatedContainer(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: _color,
                  borderRadius: _borderRadius,
                ),
                // Set the duration of the animation
                duration: Duration(seconds: 1),
                curve: Curves.easeInOutBack, // Use any animation curve you like
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _randomize,
                child: Text('Randomize'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.deepPurple,
                  textStyle: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}