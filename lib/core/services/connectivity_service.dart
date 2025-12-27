// import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

// class ConnectivityService {
//   static Future<bool> isOnline() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//
//     if (connectivityResult.contains(ConnectivityResult.mobile) ||
//         connectivityResult.contains(ConnectivityResult.wifi)) {
//       print('Connected to Network (Wi-Fi/Mobile)!');
//       return true;
//     } else {
//       print('No Network connection.');
//       return false;
//     }
//   }
// }
class ConnectivityService {
  static Future<bool> isOnline() async {
    final bool isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      print('Connected!');
      return true;
    } else {
      print('No internet connection.');

      return false;
    }
  }
}
