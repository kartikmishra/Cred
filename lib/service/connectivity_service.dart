import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:credrixapp/enums/connectivity_status.dart';

class ConnectivityService {

  StreamController<ConnectivityStatus> connectionStatusController = StreamController<ConnectivityStatus>();

  ConnectivityService() {
     Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
           var connectionStatus = _getConnectivityStatus(result);
           connectionStatusController.add(connectionStatus);
     });
  }

  ConnectivityStatus _getConnectivityStatus(ConnectivityResult result) {
       switch(result) {
         case ConnectivityResult.mobile:
           return ConnectivityStatus.CELLULAR;
         case ConnectivityResult.wifi:
           return ConnectivityStatus.WIFI;
         case ConnectivityResult.none:
           return ConnectivityStatus.OFFLINE;
         default:
           return ConnectivityStatus.OFFLINE;
       }
  }
}