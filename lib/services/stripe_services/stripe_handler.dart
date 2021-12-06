
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';

class StripeHandler {

  /// handleStripePayout
  /// @param amount
  /// @return StripeFailure, String Payout Transfer id
  Future<Either<Failure, String>> handleStripePayout(String amount) async {
    final dataSource = GetIt.I.get<LocalDataSource>();
    final stripeServices = GetIt.I.get<StripeServices>();
    final walletsStore = GetIt.I.get<WalletsStore>();

    var token = '';
    var accountlink = "";
    var errMsg = "";

    await dataSource.loadData();

    if(dataSource.StripeAccount == ""){
      final response = await stripeServices.GenerateRegistrationToken(walletsStore.getWallets().value.last.publicAddress);

      if(response.token == ""){
        return left(StripeFailure("stripe_registration_token_failed".tr()));
      }
      dataSource.StripeToken = response.token;
      token = response.token;

      final register_response = await stripeServices.RegisterAccount(StripeRegisterAccountRequest(
          Token: token,
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Address: walletsStore.getWallets().value.last.publicAddress));

      if(register_response.account == "" || register_response.accountlink == "")
      {
        return left(StripeFailure("stripe_register_account_failed".tr()));
      }

      dataSource.StripeAccount = register_response.account;
      accountlink = register_response.accountlink;
    }

    //save stripe variables
    dataSource.saveData();

    final payoutToken_response = await stripeServices.GeneratePayoutToken(StripeGeneratePayoutTokenRequest(
      amount: Int64.parseInt(amount.ValToUval()),
      address: walletsStore.getWallets().value.last.publicAddress, ));

    if(payoutToken_response.token == "") {
      return left(StripeFailure("stripe_payout_token_failed".tr()));
    }

    final payout_response = await stripeServices.Payout(StripePayoutRequest(
      address: walletsStore.getWallets().value.last.publicAddress,
      token: payoutToken_response.token,
      amount: Int64.parseInt(amount.ValToUval()),
      signature: await walletsStore.signPureMessage(payoutToken_response.token),
    ));

    if(payout_response.transfer_id == "") {
      return left(StripeFailure("stripe_payout_request_failed".tr()));
    }

    return right(payout_response.transfer_id);
  }

  /// handleStripeAccountLink
  /// @param
  /// @return StripeFailure, String accountLink
  Future<Either<Failure, String>> handleStripeAccountLink() async {
    final dataSource = GetIt.I.get<LocalDataSource>();
    final stripeServices = GetIt.I.get<StripeServices>();
    final walletsStore = GetIt.I.get<WalletsStore>();

    await dataSource.loadData();
    var token = '';
    var accountlink = "";
    print(dataSource.StripeAccount);
    print(dataSource.StripeToken);
    dataSource.StripeAccount = "";
    dataSource.StripeToken = "";

    if(dataSource.StripeAccount != ""){

      //get accountlink only
      final accountlink_response = await stripeServices.GetAccountLink(StripeAccountLinkRequest(
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Account: dataSource.StripeAccount
      ));
      if(accountlink_response.accountlink == ""){
        return left(StripeFailure("stripe_account_link_failed".tr()));
      }
      accountlink = accountlink_response.accountlink;
    }
    else {
      final response = await stripeServices.GenerateRegistrationToken(walletsStore.getWallets().value.last.publicAddress);
      if(response.token == "") {
        return left(StripeFailure("stripe_registration_token_failed".tr()));
      }

      dataSource.StripeToken = response.token;
      token = response.token;

      final register_response = await stripeServices.RegisterAccount(StripeRegisterAccountRequest(
          Token: token,
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Address: walletsStore.getWallets().value.last.publicAddress));

      if(register_response.accountlink == ""|| register_response.account == ""){
        return left(StripeFailure("stripe_register_account_failed".tr()));
      }

      dataSource.StripeAccount = register_response.account;
      accountlink = register_response.accountlink;

    }

    dataSource.saveData();
    return right(accountlink);
  }
}