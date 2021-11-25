import 'package:transaction_signing_gateway/model/transaction_hash.dart';

TransactionHash MOCK_TRANSACTION = TransactionHash(txHash: '64CFE19786363B8C6AB10D865A5C570C3999AB0B95E5723BE584F574FC58F99E');


String MOCK_USERNAME = "Jawad";
String SENDER_APP = 'Sending app';


var MOCK_COOKBOOK = """
{
  "creator": "pylo1akzpu26f36pgxr636uch8evdtdjepu93v5y9s2",
  "ID": "$MOCK_COOKBOOK_ID",
  "name": "Legend of the Undead Dragon",
  "nodeVersion": "v0.1.3",
  "description": "Cookbook for running pylons recreation of LOUD",
  "developer": "Pylons Inc",
  "version": "v0.0.1",
  "supportEmail": "alex@shmeeload.xyz",
  "costPerBlock": {"denom":  "upylon", "amount":  "1000000"},
  "enabled": true
}""";


const String MOCK_COOKBOOK_ID = 'cookbookLOUD';

const String MOCK_STRIPEURL='';
const String MOCK_STRIPEPUBKEY = '';
const MOCK_ADDRESS = "";
