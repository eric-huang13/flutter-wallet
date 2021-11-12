import 'package:alan/alan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:grpc/grpc.dart';

class BaseEnv {
  late NetworkInfo _networkInfo;
  late String _baseApiUrl;
  late String _baseEthUrl;
  late String _baseFaucetUrl;
  late String _baseWsUrl;
  late String _stripeUrl;
  late String _stripePubKey;

  void setEnv({
    required String lcdUrl,
    required String grpcUrl,
    required String lcdPort,
    required String grpcPort,
    required String ethUrl,
    required String wsUrl,
    required String tendermintPort,
    String? faucetUrl,
    String? faucetPort,
    String? stripeUrl,
    String? stripePubKey

  }) {
    _networkInfo = NetworkInfo(
      bech32Hrp: 'pylo',
      lcdInfo: LCDInfo(host: lcdUrl, port: int.parse(lcdPort)),
      grpcInfo: GRPCInfo(
          host: grpcUrl,
          port: int.parse(grpcPort),
          credentials: (dotenv.env['ENV']! == "local")
              ? const ChannelCredentials.insecure() :
              const ChannelCredentials.insecure(),
              //: ChannelCredentials.secure(
              //    onBadCertificate: (cert, host) {
              //      debugPrint("host: $host, cert: $cert");
              //      return true;
              //    },
              //  )
              ),
    );
    _baseApiUrl = "$lcdUrl:$lcdPort";
    _baseEthUrl = ethUrl;
    _baseFaucetUrl = "$faucetUrl:$faucetPort";
    _baseWsUrl = "$wsUrl:$tendermintPort";
    _stripeUrl = stripeUrl ?? "";
    _stripePubKey = stripePubKey ?? "";
  }

  NetworkInfo get networkInfo => _networkInfo;

  String get baseApiUrl => _baseApiUrl;

  String get baseEthUrl => _baseEthUrl;

  String get baseFaucetUrl => _baseFaucetUrl;

  String get baseWsUrl => _baseWsUrl;

  String get baseStripeUrl => _stripeUrl;

  String get baseStripPubKey => _stripePubKey;
}
