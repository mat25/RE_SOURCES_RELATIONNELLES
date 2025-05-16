import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/session_provider.dart';
import 'pages/main_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => SessionProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SessionProvider _sessionProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sessionProvider = Provider.of<SessionProvider>(context, listen: false);
      _sessionProvider.checkSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Lato',
        //bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          //selectedLabelStyle: TextStyle(fontFamily: 'Inter'),
          //unselectedLabelStyle: TextStyle(fontFamily: 'Inter'),
        // ),
      ),
      home: Consumer<SessionProvider>(
        builder: (context, session, _) {
          return MainPage(session: session);
        },
      ),
    );
  }
}
