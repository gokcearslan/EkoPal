import 'package:ekopal/HomePage.dart';
import 'package:ekopal/services/UserManager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'advertisements.dart';
import 'announcements.dart';
import 'bottom_bar.dart';
import 'create_page.dart';
import 'events_page.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await UserManager().loadUserId(); // Load user ID from shared_preferences
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      supportedLocales: [
        const Locale('en', 'US'), // English
        const Locale('tr', 'TR'), // Turkish
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],


      home:MainApp(),

    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  //widgets of bottom bar
  final List<Widget> _pages = [
    HomePage(),
    ViewAdvertisements(),
    AnnouncementsPage(),
    EventsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}