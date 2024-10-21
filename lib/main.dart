import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:osva2/screen/home.dart';
import 'package:osva2/screen/chat.dart';
import 'package:osva2/screen/location_screen.dart';
import 'package:osva2/screen/qr_scanner_screen.dart';
import 'package:osva2/screen/sensor_screen.dart';
import 'package:osva2/screen/speech_to_text_screen.dart';
import 'package:osva2/screen/text_to_speech_screen.dart';

final Uri _url = Uri.parse('https://github.com/Osvaldo2003/APP_PRACTICA2.git');

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey.shade900),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late PageController _pageController;

  // Lista de pantallas
  final List<Widget> _screens = [
    const ContactsScreen(),
    const ChatScreen(),
    const LocationScreen(),
    const QRScannerScreen(),
    const SensorScreen(),
    const SpeechToTextScreen(),
    const TextToSpeechScreen(),
  ];

  // Función para abrir la URL
  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw Exception('No se pudo abrir la URL $_url');
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.link),
            onPressed: _launchUrl,
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        physics: const NeverScrollableScrollPhysics(),
        children: _screens, // Desactivar deslizamiento manual
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.messenger), label: 'ChatBot'),
          BottomNavigationBarItem(
              icon: Icon(Icons.location_on), label: 'GPS'),
          BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner), label: 'QR Scanner'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sensors), label: 'Sensores'),
          BottomNavigationBarItem(
              icon: Icon(Icons.mic), label: 'Speech to Text'),
          BottomNavigationBarItem(
              icon: Icon(Icons.speaker), label: 'Text to Speech'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
