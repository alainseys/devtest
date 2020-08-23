import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:doobeedoo/services/db_download_service.dart';
import 'package:flutter/material.dart';
import 'package:doobeedoo/models/radio.dart';
import 'package:doobeedoo/services/player_provider.dart';
import 'package:doobeedoo/utils/hex_color.dart';
import 'package:provider/provider.dart';
import 'now_playing_template.dart';
import 'radio_row_template.dart';

class RadioPage extends StatefulWidget {
  final bool isFavouriteOnly;
  RadioPage({Key key, this.isFavouriteOnly}) : super(key: key);

  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  final _searchQuery = new TextEditingController();
  Timer _debounce;
  AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    playerProvider.initAudioPlugin();
    playerProvider.resetStreams();
    playerProvider.fetchAllRadios(isFavouriteOnly: this.widget.isFavouriteOnly);

    _searchQuery.addListener(_onSearchChanged);
  }

//test alain
  void _initAudioPlayer() {
     var audioPlayerBloc = Provider.of<PlayerProvider>(context, listen: false);

     if (audioPlayerBloc.getPlayerState() == RadioPlayerState.STOPPED) {
       _audioPlayer = new AudioPlayer();
     } else {
       _audioPlayer =
           Provider.of<PlayerProvider>(context, listen: false).getAudioPlayer();
     }
   }
//einde test
  _onSearchChanged() {
    var radiosBloc = Provider.of<PlayerProvider>(context, listen: false);

    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      radiosBloc.fetchAllRadios(
        isFavouriteOnly: this.widget.isFavouriteOnly,
        searchQuery: _searchQuery.text,
      );
    });
  }
//voorbeeld model
  RadioModel radioModel = new RadioModel(
    id: 1,
    radioName: "Test Radio 1",
    radioDesc: "Test Radio Desc",
    radioPic: "https://www.orseu-concours.com/353-506-thickbox/test-epso-de-raisonnement-numerique-3-fr.jpg",
  );
//opbouwen van template (logo, zoek, lijst van radios, nu spelen
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [_appLogo(), _searchBar(), _radiosList(), _nowPlaying()],
      ),
    );
  }
//applogo widget
  Widget _appLogo() {
    return Container(
      width: double.infinity,
      color: HexColor("#7cc0bf"),
      height: 80,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Center(
          child: new Text(
            "Doobeedoo App",
            style: TextStyle(
              fontSize: 30,
              color: HexColor("#ffffff"),
            ),
          ),
        ),
      ),
    );

  }
//zoek functie
  Widget _searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.search),
          new Flexible(
            child: new TextField(
              cursorColor: Colors.black,
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(5),
                hintText: 'Zoek Radio',
              ),
              controller: _searchQuery,
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
//als geen data kan worden geladen een fout weergeven
  Widget _noData() {
    String noDataTxt = "";
    bool showTextMessage = false;

    if (this.widget.isFavouriteOnly ||
        (this.widget.isFavouriteOnly && _searchQuery.text.isNotEmpty)) {
      noDataTxt = "Geen Favorieten";
      showTextMessage = true;
    } else if (_searchQuery.text.isNotEmpty) {
      noDataTxt = "Geen radio gevonden";
      showTextMessage = true;
    }

    return Column(
      children: [
        new Expanded(
          child: Center(
            child: showTextMessage
                ? new Text(
              noDataTxt,
              textScaleFactor: 1,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            )
                : CircularProgressIndicator(),
          ),
        ),
      ],
    );
  }
//radiolijst

  Widget _radiosList() {
    return Consumer<PlayerProvider>(
      builder: (context, radioModel, child) {
        if (radioModel.totalRecords > 0) {
          return new Expanded(
            child: Padding(
              child: ListView(
                children: <Widget>[
                  ListView.separated(
                      itemCount: radioModel.totalRecords,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return RadioRowTemplate(
                          radioModel: radioModel.allRadio[index],
                          isFavouriteOnlyRadios: this.widget.isFavouriteOnly,
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      })
                ],
              ),
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            ),
          );
        }

        if (radioModel.totalRecords == 0) {
          return new Expanded(
            child: _noData(),
          );
        }

        return CircularProgressIndicator();
      },
    );
  }

  Widget _nowPlaying() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return Visibility(
      visible: playerProvider.getPlayerState() == RadioPlayerState.PLAYING,
      child: NowPlayingTemplate(
        radioTitle: playerProvider.currentRadio.radioName,
        radioImageURL: playerProvider.currentRadio.radioPic,
      ),
    );
  }

/*Widget _radiosList() {
   return new FutureBuilder(
     future: DBDownloadService.fetchLocalDB(),
     builder: (BuildContext context, AsyncSnapshot<List<RadioModel>> radios) {
       if (radios.hasData) {
         return new Expanded(
           child: Padding(
             child: ListView(
               children: <Widget>[
                 ListView.separated(
                     itemCount: radios.data.length,
                     physics: ScrollPhysics(),
                     shrinkWrap: true,
                     itemBuilder: (context, index) {
                       return RadioRowTemplate(radioModel: radios.data[index]);
                     },
                     separatorBuilder: (context, index) {
                       return Divider();
                     })
               ],
             ),
             padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
           ),
         );
       }

       return CircularProgressIndicator();
     },
   );
 }*/
}
