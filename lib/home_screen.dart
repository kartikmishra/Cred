

import 'package:credrixapp/enums/connectivity_status.dart';
import 'package:credrixapp/movie_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Movies> _movies =  List<Movies>();

  Future<List<Movies>> _getMovies() async {
    var data = await http.get(
        "http://api.themoviedb.org/3/movie/popular?api_key=802b2c4b88ea1183e50e6b285a27696e",
        headers: {"Accept":"application/json"}
    );

    var movies = List<Movies>();

    if(data.statusCode == 200) {
      var convertDataToJson = json.decode(data.body);
      var jsonData = convertDataToJson['results'];
      for(var j in jsonData) {
        movies.add(Movies.fromJson(j));
      }
    }
    return movies;
  }

  @override
  void initState() {
    _getMovies().then((value) {
         setState(() {
             _movies.addAll(value);
         });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Movies"),
        ),
        body: GridView.builder (
                  shrinkWrap: true,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                      childAspectRatio:  MediaQuery.of(context).size.width / 500),
                  itemCount: _movies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return new GestureDetector(
                        child: Card(
                          child: Container(
                            color: Colors.transparent,
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: <Widget>[
                                Image.network(
                                  "https://image.tmdb.org/t/p/w500" +
                                      _movies[index].poster_path,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  loadingBuilder: (context, child, progress) {
                                    return progress == null ? child
                                        : Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: LinearProgressIndicator(
                                            backgroundColor: Colors.grey));
                                  },
                                ),
                                Container(
                                  color: Colors.black.withOpacity(0.8),
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Flexible(child: Text(_movies[index].title,
                                          style: TextStyle(fontSize: 12.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      onTap: () {
                             Navigator.pushNamed(context,
                                 MovieDetail.routeName,
                                 arguments: ScreenArguments(_movies[index].id));
                      },
                    );
                  }
        ));
  }
}


class Movies {
  String poster_path;
  int id;
  String title;
  String overview;

  Movies(this.poster_path,this.id,this.title);

  Movies.fromJson(Map<String,dynamic> json) {
    poster_path = json['poster_path'];
    id = json['id'];
    title = json['title'];
//    vote_average = json['vote_average'];
//    overview = json['overview'];
//    release_date = json['realease_date'];
  }

}

class ScreenArguments {
  final int id;
  ScreenArguments(this.id);
}
