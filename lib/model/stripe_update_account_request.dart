class StripeUpdateAccountRequest {
  final String Address;
  final String Token;
  final String Signature;

  StripeUpdateAccountRequest(
      {required this.Address, required this.Token, required this.Signature});

  Map<String, dynamic> toJson() => {
    'address': this.Address,
    'token': this.Token,
    'signature': this.Signature
  };
}