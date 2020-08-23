import 'package:flutter/material.dart';
import 'package:doobeedoo/utils/hex_color.dart';
import 'package:screen/screen.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor("#7cc0bf"),
        title: Text(
          'Doobeedoo App',
          style: TextStyle(
            fontSize: 30,
            color: HexColor("#ffffff"),
          ),
        ),
      ),
      body: Center(
        child: SwitchListTile(
          title: const Text('Sherm actief ja/nee'),
          subtitle: const Text('dit is een feature die nog moet worden afgewerkt!!!'),
          value: isSwitched,
          onChanged: (value) {
            setState(() {
              isSwitched = value;

              //controle aan of uit
              print(isSwitched);
              if(isSwitched == true){
                Screen.keepOn(true);
              }
              if(isSwitched == false){
                Screen.keepOn(false);
              }
            });
          },
          activeTrackColor: Colors.lightBlueAccent,
          activeColor: Colors.blue,
          secondary: const Icon(Icons.lightbulb_outline),
        ),

      ),
    );
  }
}
