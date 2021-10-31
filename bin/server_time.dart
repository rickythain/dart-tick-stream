import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'dart:io';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

// Connect to Deriv API, accept a symbol id as input, then fetch and subscribe to the tick history data and print it to the console.
final channel = IOWebSocketChannel.connect(
    'wss://ws.binaryws.com/websockets/v3?app_id=1089');
void main(List<String> arguments) {
  channel.stream.listen((message) {
    final decodedMessage = jsonDecode(message);

    final streamItem = decodedMessage['tick'];

    final itemSymbol = streamItem['symbol'];
    final itemPrice = streamItem['quote'];
    final itemTime =
        DateTime.fromMillisecondsSinceEpoch(streamItem['epoch'] * 1000);

    print('name: ' +
        itemSymbol +
        ' price: ' +
        itemPrice.toString() +
        ' date: ' +
        itemTime.toString());

    // channel.sink.close(status.goingAway);
  });

  print("Enter a symbol: ('R_50' / 'R_25' / 'R_10' / 'JD75' / etc.");
  var inputSymbol = stdin.readLineSync(encoding: utf8);

  if (inputSymbol != null) {
    channel.sink.add('{"ticks": "' + inputSymbol + '", "subscribe": 1}');
  }

  // channel.sink.add('{"ticks": "R_50", "subscribe": 1}');

// channel.sink.add('{"ticks": "R_50", "subscribe": 1}');
//   channel.sink.add('{"active_symbols": "brief", "product_type": "basic"}');
}
