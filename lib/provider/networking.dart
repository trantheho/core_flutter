import 'package:connectivity/connectivity.dart';
import 'package:core/libs/bloc.dart';
import 'package:core/provider/app_bloc.dart';

enum ConnectivityStatus { WiFi, Cellular, Offline }

class Networking extends AppBloc {
  final networkStatus = BlocDefault<ConnectivityStatus>();

  Networking._private() {
    initLogic();
  }

  static final Networking _instance = Networking._private();

  factory Networking() => _instance;

  @override
  void initLogic() async {
    // @nhancv 2019-10-28: Init network status
    ConnectivityResult result = await (Connectivity().checkConnectivity());
    networkStatus.push(_getStatusFromResult(result));
    // Subscribe to the connectivity stream
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      networkStatus.push(_getStatusFromResult(result));
    });
  }

  @override
  void dispose() {
    // ..
  }

  // Convert from the third part enum to our own enum
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.WiFi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offline;
      default:
        return ConnectivityStatus.Offline;
    }
  }
}