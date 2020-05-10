import 'package:credrixapp/enums/connectivity_status.dart';
import 'package:credrixapp/home_screen.dart';
import 'package:credrixapp/movie_detail.dart';
import 'package:credrixapp/service/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return StreamProvider<ConnectivityStatus>(
      builder: (context) => ConnectivityService().connectionStatusController,
      child: MaterialApp (
        title: "Movies",
        initialRoute: '/',
        routes: {
          '/' : (context) => MyHomePage(),
          MovieDetail.routeName: (context) => MovieDetail()
        },
        theme: ThemeData(
            primarySwatch: Colors.orange,
          visualDensity: VisualDensity.adaptivePlatformDensity)
        ),
    );
  }
}
