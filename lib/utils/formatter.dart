import 'package:intl/intl.dart';
import 'package:decimal/decimal.dart';
import 'package:pylons_wallet/constants/constants.dart' as Constants;

extension TrimZeroString on String {
  String trimZero() {
    return num.parse(this).toString();
  }
}

extension AmountValue on String {
  String UvalToVal() {
    var amount = this == "" ? "0" : this;
    return (num.parse(amount) / Constants.kBigIntBase).toString();
  }

  String ValToUval() {
    var amount = this == "" ? "0" : this;
    return (Decimal.parse(this) * Decimal.fromInt(Constants.kBigIntBase)).toInt().toString();
  }
}

extension DenomValue on String {
  String UdenomToDenom() {
    if (this == Constants.kPylonDenom) {
      return Constants.kPylonCoinName;
    } else if (this == Constants.kUSDDenom) {
      return Constants.kUSDCoinName;
    } else if (this.startsWith("u")) {
      return this.substring(1);
    }
    return this;
  }

  String DenomToUdenom() {
    if (this.toLowerCase() == Constants.kPylonCoinName) {
      return Constants.kPylonDenom;
    } else if (this.toLowerCase() == Constants.kUSDCoinName) {
      return Constants.kUSDDenom;
    } else if (!this.toLowerCase().startsWith("u")) {
      return "u${this.toLowerCase()}";
    }
    return this;
  }
}
