

import 'package:intl/intl.dart';

extension TrimZeroString on String {
  String trimZero(){
    //RegExp regex = RegExp(r"([.]*0)(?!.*d)");
    //final str = this.toString().replaceAll(RegExp(r"([.]*0)(?!.*d)"), "");
    //return str == "" ? "0" : str;
    return num.parse(this).toString();
  }
}
