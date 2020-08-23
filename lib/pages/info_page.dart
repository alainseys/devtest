import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
import 'package:doobeedoo/utils/hex_color.dart';

class infoRadiosPage extends StatelessWidget {
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
      body: ListView(
        children: <Widget>[
          // ...
          // A title for the subsection:
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
              ),
              Divider(),
            ],
          ),
          // The version tile :
          ListTile(
            enabled: false,
            title: Text("Versie"),
            trailing: FutureBuilder(
              future: getVersionNumber(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  Text(
                snapshot.hasData ? snapshot.data : "Loading ...",
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          ListTile(
            enabled: false,
            title: Text("Build"),
            trailing: FutureBuilder(
              future: getbuild(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  Text(
                snapshot.hasData ? snapshot.data : "Loading ...",
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          ListTile(
            enabled: false,
            title: Text("Pakket"),
            trailing: FutureBuilder(
              future: packagenumber(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  Text(
                snapshot.hasData ? snapshot.data : "Loading ...",
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          ListTile(
            enabled: false,
            title: Text("Developer"),
            trailing: FutureBuilder(
              future: developer(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  Text(
                snapshot.hasData ? snapshot.data : "Loading ...",
                style: TextStyle(color: Colors.black38),
              ),
            ),
          ),
          // ...
        ],
      ),
    );
  }

//functies om gegevens op te vragen
  Future<String> getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildnumber = packageInfo.buildNumber;

    return version;
  }

  Future<String> getbuild() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String buildnumber = packageInfo.buildNumber;
    return buildnumber;
  }

  Future<String> packagenumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String package = packageInfo.packageName;
    return package;
  }

  Future<String> developer() async {
    //PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String dev = "Seys Alain";
    return dev;
  }
}
