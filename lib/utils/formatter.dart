

import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';

extension TrimZeroString on String {
  String trimZero(){
    return num.parse(this).toString();
  }
}


extension AmountValue on String {
  String UvalToVal() {
    var amount = this == "" ? "0" : this;
    return (num.parse(amount) / 1000000).toString();
  }
  String ValToUval() {
    var amount = this == "" ? "0" : this;
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

