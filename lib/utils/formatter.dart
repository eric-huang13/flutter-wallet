import 'package:decimal/decimal.dart';
import 'package:pylons_wallet/constants/constants.dart' as Constants;

extension TrimZeroString on String {
  String trimZero() {
    return num.parse(this).toString();
  }
}

extension AmountValue on String {
  String UvalToVal() {
    final amount = this == "" ? "0" : this;
    return (num.parse(amount) / Constants.kBigIntBase).toString();
  }

  String ValToUval() {
    return (Decimal.parse(this) * Decimal.fromInt(Constants.kBigIntBase))
        .toInt()
        .toString();
  }
}

extension DenomValue on String {
  String UdenomToDenom() {
    if (this == Constants.kPylonDenom) {
      return Constants.kPylonCoinName;
    } else if (this == Constants.kUSDDenom) {
      return Constants.kUSDCoinName;
    } else if (startsWith("u")) {
      return substring(1);
    }
    return this;
  }

  String DenomToUdenom() {
    if (toLowerCase() == Constants.kPylonCoinName) {
      return Constants.kPylonDenom;
    } else if (toLowerCase() == Constants.kUSDCoinName) {
      return Constants.kUSDDenom;
    } else if (!toLowerCase().startsWith("u")) {
      return "u${toLowerCase()}";
    }
    return this;
  }
}
