

import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

extension TrimZeroString on String {
  String trimZero(){
    //RegExp regex = RegExp(r"([.]*0)(?!.*d)");
    //final str = this.toString().replaceAll(RegExp(r"([.]*0)(?!.*d)"), "");
    //return str == "" ? "0" : str;
    return num.parse(this).toString();
  }
}


extension AmountValue on String {
  String UvalToVal() {
    return (num.parse(this)  / 1000000).toString();
  }
  String ValToUval() {
    return (Decimal.parse(this) * Decimal.fromInt(1000000)).toInt().toString();
  }
}

extension DenomValue on String {
  String UdenomToDenom() {
    if (this == "upylon"){
      return "pylon";
    }
    else if(this == "ustripeusd"){
      return "USD";
    }
    else if(this.startsWith("u")) {
      return this.substring(1);
    }
    return this;
  }

  String DenomToUdenom() {
    if (this.toLowerCase() == "pylon"){
      return "upylon";
    }
    else if(this.toLowerCase() == "usd"){
      return "ustripeusd";
    }
    else if(!this.toLowerCase().startsWith("u")) {
      return "u${this.toLowerCase()}";
    }
    return this;
  }
}

