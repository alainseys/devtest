import 'package:flutter/material.dart';
import 'radio_page.dart';

class FavRadiosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //open template en roep de favoriet functie aan.
    return new RadioPage(isFavouriteOnly: true);
  }
}