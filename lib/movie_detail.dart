import 'package:credrixapp/enums/connectivity_status.dart';
import 'package:credrixapp/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:provider/provider.dart';


class MovieDetail extends StatefulWidget {
  static const routeName = '/movieDetail';

  @override
  _MovieDetailState createState() => _MovieDetailState();
}

class _MovieDetailState extends State<MovieDetail> {



  MovieDetailModel _movies = new MovieDetailModel("","","","");

  Future<MovieDetailModel> _getMovieDetail(int id) async {
    var data = await http.get(
        "http://api.themoviedb.org/3/movie/"+id.toString()+"?api_key=802b2c4b88ea1183e50e6b285a27696e",
        headers: {"Accept":"application/json"}
    );

    var convertDataToJson = json.decode(data.body);
    var model = MovieDetailModel.fromJson(convertDataToJson);
    return model;
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;

    var connectionStatus = Provider.of<ConnectivityStatus>(context);


    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: new FutureBuilder(future: _getMovieDetail(arguments.id),builder: (context, snapshot){
          if(connectionStatus == ConnectivityStatus.WIFI || connectionStatus == ConnectivityStatus.CELLULAR) {
            if(snapshot.hasData) {
              var data = snapshot.data;
              return  SingleChildScrollView(
                child: new Container(
                    child: Column(
                      children: <Widget>[
                        Image.network(
                          "https://image.tmdb.org/t/p/w500" +
                              data.poster_path,
                          loadingBuilder: (context, child, progress) {
                            return progress == null ? child
                                : Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: LinearProgressIndicator(
                                    backgroundColor: Colors.red));
                          },
                        ),
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                "https://image.tmdb.org/t/p/w500" +
                                    data.poster_path,
                                height: 250,
                                loadingBuilder: (context, child, progress) {
                                  return progress == null ? child
                                      : Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: LinearProgressIndicator(
                                          backgroundColor: Colors.red));
                                },
                              ),
                            ),
                            Flexible(
                              child: Container(
                                height: 200,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0,top: 8.0),
                                      child:Text(data.original_title,
                                          style: TextStyle(fontWeight:FontWeight.bold,fontSize: 32.0))),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(
                           color: Colors.grey,
                           height: 1,
                           thickness: 1,
                        ),
                        Padding(
                            padding: const EdgeInsets.all(16.0),
                            child:Text(data.overview,
                                style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16.0))),
                      ],
                    )
                ),
              );
            } else {
              return new Center(child: Text("Loading....",style: TextStyle(fontSize: 16.0),));
            }
          } else {
            return new Center(child: Text("Something Went Wrong",style: TextStyle(fontSize: 16.0),),);
          }
        }),
      )
    );
  }
}



class MovieDetailModel {

  String original_title;
  String overview;
  String poster_path;
  String release_date;


  MovieDetailModel(this.original_title,this.overview,this.poster_path,this.release_date);

  MovieDetailModel.fromJson(Map<String,dynamic> json) {
    original_title = json['original_title'];
    overview = json['overview'];
    poster_path = json['poster_path'];
    release_date = json['release_date'];
  }

}
