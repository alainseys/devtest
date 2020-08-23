import 'package:flutter/material.dart';
import 'package:doobeedoo/models/radio.dart';
import 'package:doobeedoo/services/player_provider.dart';
import 'package:doobeedoo/utils/hex_color.dart';
import 'package:provider/provider.dart';

class RadioRowTemplate extends StatefulWidget {
  final RadioModel radioModel;
  final bool isFavouriteOnlyRadios;

  RadioRowTemplate({
    Key key,
    this.radioModel,
    this.isFavouriteOnlyRadios,
  }) : super(key: key);

  @override
  _RadioRowTemplateState createState() => _RadioRowTemplateState();
}

class _RadioRowTemplateState extends State<RadioRowTemplate> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _buildSongRow();
  }

  Widget _buildSongRow() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: false);

    final bool _isSelectedRadio =
        this.widget.radioModel.id == playerProvider.currentRadio.id;

    return ListTile(
      title: new Text(
        this.widget.radioModel.radioName,
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          color: HexColor("#7cc0bf"),
        ),
      ),
      leading: _image(this.widget.radioModel.radioPic),
      subtitle: new Text(this.widget.radioModel.radioDesc, maxLines: 2),
      trailing: Wrap(
        spacing: -10.0, // gap between adjacent chips
        runSpacing: 0.0, // gap between lines
        children: <Widget>[
          _buildPlayStopIcon(
            playerProvider,
            _isSelectedRadio,
          ),
          _buildAddFavouriteIcon(),
        ],
      ),
    );
  }

  Widget _image(url, {size}) {
    return Container(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.network(url),
      ),
      height: size == null ? 55 : size,
      width: size == null ? 55 : size,
      decoration: BoxDecoration(
        color: HexColor("#ffffff"),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
          bottomRight: Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }

  Widget _buildPlayStopIcon(
      PlayerProvider playerProvider, bool _isSelectedSong) {
    return IconButton(
      icon: _buildAudioButton(playerProvider, _isSelectedSong),
      onPressed: () {
        if (!playerProvider.isStopped() && _isSelectedSong) {
          playerProvider.stopRadio();
        } else {
          if (!playerProvider.isLoading()) {
            playerProvider.initAudioPlugin();
            playerProvider.setAudioPlayer(this.widget.radioModel);

            playerProvider.playRadio();
          }
        }
      },
    );
  }

  Widget _buildAudioButton(PlayerProvider model, _isSelectedSong) {
    if (_isSelectedSong) {
      if (model.isLoading()) {
        return Center(
          child: CircularProgressIndicator(strokeWidth: 2.0),
        );
      }

      if (!model.isStopped()) {
        return Icon(Icons.stop);
      }

      if (model.isStopped()) {
        return Icon(Icons.play_circle_filled);
      }
    } else {
      return Icon(Icons.play_circle_filled);
    }

    return new Container();
  }

  Widget _buildAddFavouriteIcon() {
    var playerProvider = Provider.of<PlayerProvider>(context, listen: true);

    return IconButton(
      icon: this.widget.radioModel.isBookmarked ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
      color: HexColor("#878070"),
      onPressed: () {
        playerProvider.radioBookmarked(
          this.widget.radioModel.id,
          !this.widget.radioModel.isBookmarked,
          isFavouriteOnly: this.widget.isFavouriteOnlyRadios,
        );
      },
    );
  }
}
