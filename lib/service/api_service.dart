import '../utils/exports.dart';

class ApiService{
  void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
       // backgroundColor: Colors.indigo,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

}