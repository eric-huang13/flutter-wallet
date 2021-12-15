
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fixnum/fixnum.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/model/export.dart';
import 'package:pylons_wallet/services/repository/repository.dart';
import 'package:pylons_wallet/utils/failure/failure.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';
import 'package:easy_localization/easy_localization.dart';

class StripeHandler {

  /// handleStripePayout
  /// @param amount
  /// @return StripeFailure, String Payout Transfer id
  Future<Either<Failure, String>> handleStripePayout(String amount) async {
    final dataSource = GetIt.I.get<LocalDataSource>();
    final repository = GetIt.I.get<Repository>();
    final walletsStore = GetIt.I.get<WalletsStore>();

    var token = '';

    await dataSource.loadData();

    if(dataSource.StripeAccount == "") {
      final response = await repository.GenerateRegistrationToken(walletsStore
          .getWallets()
          .value
          .last
          .publicAddress);

      if (response.isLeft())
        return left(StripeFailure("stripe_registration_token_failed".tr()));

      token = response
          .getOrElse(() => StripeGenerateRegistrationTokenResponse())
          .token;

      if (token == "")
        return left(StripeFailure("stripe_registration_token_failed".tr()));


      dataSource.StripeToken = token;


      final register_response = await repository.RegisterAccount(StripeRegisterAccountRequest(
          Token: token,
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Address: walletsStore.getWallets().value.last.publicAddress));

      if(register_response.isLeft())
        return left(StripeFailure("stripe_register_account_failed".tr()));

      final register_info = register_response.getOrElse(() => StripeRegisterAccountResponse());

      if(register_info.account == "" || register_info.accountlink == "")
      {
        return left(StripeFailure("stripe_register_account_failed".tr()));
      }

      dataSource.StripeAccount = register_info.account;
    }

    //save stripe variables
    dataSource.saveData();

    final payoutToken_response = await repository.GeneratePayoutToken(StripeGeneratePayoutTokenRequest(
      amount: Int64.parseInt(amount.ValToUval()),
      address: walletsStore.getWallets().value.last.publicAddress, ));

    if(payoutToken_response.isLeft())
      return left(StripeFailure("stripe_payout_token_failed".tr()));

    final payoutToken = payoutToken_response.getOrElse(() => StripeGeneratePayoutTokenResponse());

    if(payoutToken.token == "") {
      return left(StripeFailure("stripe_payout_token_failed".tr()));
    }

    final payout_response = await repository.Payout(StripePayoutRequest(
      address: walletsStore.getWallets().value.last.publicAddress,
      token: payoutToken.token,
      amount: Int64.parseInt(amount.ValToUval()),
      signature: await walletsStore.signPureMessage(payoutToken.token),
    ));

    if(payout_response.isLeft())
      return left(StripeFailure("stripe_payout_request_failed".tr()));

    final payout_info = payout_response.getOrElse(() => StripePayoutResponse());


    if(payout_info.transfer_id == "") {
      return left(StripeFailure("stripe_payout_request_failed".tr()));
    }

    return right(payout_info.transfer_id);
  }

  /// handleStripeAccountLink
  /// @param
  /// @return StripeFailure, String accountLink
  Future<Either<Failure, String>> handleStripeAccountLink() async {
    final dataSource = GetIt.I.get<LocalDataSource>();
    final repository = GetIt.I.get<Repository>();
    final walletsStore = GetIt.I.get<WalletsStore>();

    await dataSource.loadData();
    var token = '';
    var accountlink = "";

    if(dataSource.StripeAccount != ""){

      //get accountlink only
      final accountlink_response = await repository.GetAccountLink(StripeAccountLinkRequest(
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Account: dataSource.StripeAccount
      ));
      if(accountlink_response.isLeft())
        return left(StripeFailure("stripe_account_link_failed".tr()));

      final accountlink_info = accountlink_response.getOrElse(() => StripeAccountLinkResponse());
      if(accountlink_info.accountlink == ""){
        return left(StripeFailure("stripe_account_link_failed".tr()));
      }
      accountlink = accountlink_info.accountlink;
    }
    else {
      final response = await repository.GenerateRegistrationToken(walletsStore.getWallets().value.last.publicAddress);
      if(response.isLeft())
        return left(StripeFailure("stripe_registration_token_failed".tr()));

      final token_info = response.getOrElse(() => StripeGenerateRegistrationTokenResponse());

      if(token_info.token == "") {
        return left(StripeFailure("stripe_registration_token_failed".tr()));
      }

      dataSource.StripeToken = token_info.token;
      token = token_info.token;

      final register_response = await repository.RegisterAccount(StripeRegisterAccountRequest(
          Token: token,
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Address: walletsStore.getWallets().value.last.publicAddress));
      if(register_response.isLeft())
        return left(StripeFailure("stripe_register_account_failed".tr()));


      final register_info = register_response.getOrElse(() => StripeRegisterAccountResponse());

      if(register_info.accountlink == ""|| register_info.account == ""){
        return left(StripeFailure("stripe_register_account_failed".tr()));
      }

      dataSource.StripeAccount = register_info.account;
      accountlink = register_info.accountlink;

    }

    dataSource.saveData();
    return right(accountlink);
  }
}