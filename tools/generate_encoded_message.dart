import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  //const createCookbook = false;
  //const createRecipe = true;

  String arg = args.length > 0 ? args[0] : 'createCookbook';

  if (arg == 'createCookbook') {
    final file = File("json/cookbook.json");
    final jsonContent = await file.readAsString();
    print(jsonContent);
    final msg = encodeMessage(["pylo1np6w3qwugamt8yzqyns5wr5e500239sf7gw6l5", "txCreateCookbook", jsonContent]);
    execute(msg);
  }
  if (arg == 'createRecipe') {
    final file = File("json/recipe.json");
    final jsonContent = await file.readAsString();
    final msg = encodeMessage(["pylo1np6w3qwugamt8yzqyns5wr5e500239sf7gw6l5", "txCreateRecipe", jsonContent]);
    execute(msg);
  }

  if (arg == 'purchase_nft'){
    final cookbook_id = args.length > 3 ? args[1] : 'cookbook_for_test';
    final recipe_id = args.length > 3 ? args[2] : 'cookbook_for_test_2021_10_22_09_13_58';

    final msg = "?action=purchase_nft&cookbook_id=${cookbook_id}&recipe_id=${recipe_id}&nft_amount=1";
    execute(msg);
  }
}
Future<void> execute(msg) async {
  print(msg);
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
    '"pylons://wallet/$msg"']);
}

String encodeMessage(List<String> msg) {
  final encodedMessageWithComma = msg.map((e) => base64Url.encode(utf8.encode(e))).join(',');
  return base64Url.encode(utf8.encode(encodedMessageWithComma));
}