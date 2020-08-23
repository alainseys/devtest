import 'package:doobeedoo/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:doobeedoo/pages/radio_page.dart';
import 'package:provider/provider.dart';
import 'package:screen/screen.dart';
import 'pages/home_page.dart';
import 'services/player_provider.dart';
import 'package:package_info/package_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Screen.keepOn(true);
    Screen.setBrightness(100);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => PlayerProvider(),
          child: RadioPage(),
        ),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(fontFamily: 'Montserrat'),
        home: SafeArea(
          bottom: false,
          child: Scaffold(
            primary: false,
            body: SplashPage(),
            //body: HomePage(),
          ),
        ),
      ),
    );
  }


}
