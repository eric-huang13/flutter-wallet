import 'package:fixnum/fixnum.dart';

import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:pylons_wallet/components/pylons_blue_button.dart';
import 'package:pylons_wallet/components/pylons_text_input_widget.dart';
import 'package:pylons_wallet/components/space_widgets.dart';
import 'package:pylons_wallet/services/stripe_services/stripe_services.dart';
import 'package:pylons_wallet/stores/wallet_store.dart';
import 'package:pylons_wallet/utils/formatter.dart';
import 'package:pylons_wallet/utils/third_party_services/local_storage_service.dart';

class StripePayoutWidget {
  BuildContext context;
  String amount;

  StripePayoutWidget({required this.context, required this.amount});

  Future show() {
    return showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        builder: (context) => Wrap(children: [
          StripePayoutForm(
            maxAmount: amount
          )
        ]));
  }
}


// Define a custom Form widget.
class StripePayoutForm extends StatefulWidget {
  final String maxAmount;


  const StripePayoutForm({Key? key, required this.maxAmount}) : super(key: key);

  @override
  StripePayoutFormState createState() => StripePayoutFormState();
}

class StripePayoutFormState extends State<StripePayoutForm> {
  final _formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 50,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [

                  const VerticalSpace(30),
                  Text("Request Payout to Current Stripe Account", style: const TextStyle(color: Colors.black, fontSize: 16)),
                  const VerticalSpace(30),
                  Text("Available Amount: ${widget.maxAmount.UvalToVal() } USD", textAlign: TextAlign.start),

                  const VerticalSpace(30),
                  PylonsTextInput(
                    controller: amountController, label: "Amount",
                    inputType: TextInputType.number,
                    errorText: (textValue){
                      if (textValue == null || textValue.isEmpty) {
                        return 'Amount cannot be empty';
                      }else{
                        if(Decimal.parse(textValue) > Decimal.parse(widget.maxAmount.UvalToVal())){
                          return 'Current value exceeds available amount';
                        }
                      }
                      return null;
                    },
                  ),
                  const VerticalSpace(50),
                  PylonsBlueButton(
                    onTap: onPayoutPressed,
                    text: "Payout"
                  ),
                  const VerticalSpace(30)
                ],
              )) // Add TextFormFields and ElevatedButton here.
        ],
      ),
    );
  }

  void onPayoutPressed() {
    if(_formKey.currentState!.validate()){
      handleStripePayout(amountController.text);
    }
  }

  Future<void> handleStripePayout(String amount) async {
    final dataSource = GetIt.I.get<LocalDataSource>();
    final stripeServices = GetIt.I.get<StripeServices>();
    final walletsStore = GetIt.I.get<WalletsStore>();
    await dataSource.loadData();
    var token = '';
    var accountlink = "";
    print(dataSource.StripeAccount);

    if(dataSource.StripeAccount == ""){
      final response = await stripeServices.GenerateRegistrationToken(walletsStore.getWallets().value.last.publicAddress);
      if(response.token != ""){
        dataSource.StripeToken = response.token;
        token = response.token;
      }

      final register_response = await stripeServices.RegisterAccount(StripeRegisterAccountRequest(
          Token: token,
          Signature: await walletsStore.signPureMessage(dataSource.StripeToken),
          Address: walletsStore.getWallets().value.last.publicAddress));

      dataSource.StripeAccount = register_response.account;
      accountlink = register_response.accountlink;
    }
    dataSource.saveData();

      final response = await stripeServices.GeneratePayoutToken(StripeGeneratePayoutTokenRequest(
        amount: Int64.parseInt(amount.ValToUval()),
        address: walletsStore.getWallets().value.last.publicAddress, ));
      print(response.token);

  }
}
