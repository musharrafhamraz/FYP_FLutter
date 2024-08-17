import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkUtils {
  static Future<bool> isConnected() async {
    bool result = await InternetConnectionCheckerPlus().hasConnection;
    return result;
  }
}
