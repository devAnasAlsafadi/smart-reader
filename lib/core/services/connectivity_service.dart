import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
