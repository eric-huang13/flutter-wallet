import 'dart:convert';
import 'dart:io';

import 'package:pylons_wallet/ipc/models/sdk_ipc_message.dart';

Future<void> main() async {
  const createCookbook = false;
  const createRecipe = true;

  if (createCookbook) {
    final file = await getProjectFile("cookbook.json");
    final jsonContent = await file.readAsString();
    final sdkipcMessage  = SDKIPCMessage('txCreateCookbook', jsonContent, 'example');

    final msg = sdkipcMessage.createMessage();
    execute(msg);
  }
  if (createRecipe) {
    final file = await getProjectFile("recipe.json");
    final jsonContent = await file.readAsString();

    final sdkipcMessage  = SDKIPCMessage('txCreateRecipe', jsonContent, 'example');
    execute(sdkipcMessage.createMessage());
  }
}
Future<void> execute(msg) async {
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
    'pylons://wallet/$msg']);
}




/// Get a stable path to a test resource by scanning up to the project root.
Future<File> getProjectFile(String path) async {
  var dir = Directory.current.path;
  return File('$dir/tools/json/$path');
}