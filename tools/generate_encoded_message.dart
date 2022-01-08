import 'dart:convert';
import 'dart:io';
import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

Future<void> main(List<String> args) async {
  //const createCookbook = false;
  //const createRecipe = true;

  String arg = args.isNotEmpty ? args[0] : 'createCookbook';

  if (arg == 'createCookbook') {
    final file = await getProjectFile("cookbook.json");
    final jsonContent = await file.readAsString();
    final sdkipcMessage =
        SDKIPCMessage(action: 'txCreateCookbook', json: jsonContent, sender: 'example');

    final msg = sdkipcMessage.createMessage();
    execute(msg);
  }
  if (arg == 'createRecipe') {
    final file = await getProjectFile("recipe.json");
    final jsonContent = await file.readAsString();
    final sdkipcMessage =
        SDKIPCMessage(action: 'txCreateRecipe', json: jsonContent, sender: 'example');
    execute(sdkipcMessage.createMessage());
  }

  if (arg == 'purchase_nft') {
    final cookbook_id = args.length > 3 ? args[1] : 'cookbook_for_test_stripe_1111';
    final recipe_id =
        args.length > 3 ? args[2] : 'cookbook_for_test_stripe_1111';

    final msg =
        "?action=purchase_nft&cookbook_id=${cookbook_id}&recipe_id=${recipe_id}&nft_amount=1";
    execute(msg);
  }

  if (arg == 'purchase_trade') {
    final trade_id = args.length > 2 ? args[1] : '123456';
    final msg = "?action=purchase_trade&trade_id=${trade_id}";
    execute(msg);
  }
}

Future<void> execute(msg) async {
  print("pylons://wallet/$msg");
  Process.run("adb", [
    'shell',
    'am',
    'start',
    '-W',
    '-a',
    'android.intent.action.VIEW',
    '-c',
    'android.intent.category.BROWSABLE',
    '-d',
    '"pylons://wallet/$msg"'
  ]);
}

/// Get a stable path to a test resource by scanning up to the project root.
Future<File> getProjectFile(String path) async {
  var dir = Directory.current.path;
  return File('$dir/tools/json/$path');
}
