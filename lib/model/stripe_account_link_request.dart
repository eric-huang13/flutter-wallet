
class StripeAccountLinkRequest {
  final String Account;
  final String Signature;

  StripeAccountLinkRequest({required this.Account, required this.Signature});

  Map<String, dynamic> toJson() =>
      {'account': this.Account, 'signature': this.Signature};
}