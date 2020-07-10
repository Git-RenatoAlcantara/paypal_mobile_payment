import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:paypal_mobile_payment/paypal_mobile_payment.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  String _paymentResult = "Empty";

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PaypalMobilePayment.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    var products = {
      "description": "My first purched",
      "price": "1.75",
      "currency": "USD"
    };
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              FlatButton(
                  color: Colors.blueAccent,
                  onPressed: () async {
                    var result = await PaypalMobilePayment.startCheckout(
                        clientId:
                            "AcZJTsqYlovBu9xMRsK6cXPLMHep7z2lVuFAXIn517h5NxzElQ5DdrgBbebhlWj_6ZjmIJJ2HUB0N9t9",
                        items: products);
                    setState(() {
                      _paymentResult = result;
                    });
                  },
                  child: Text("Payment")),
              Text("$_paymentResult"),
            ],
          ),
        ),
      ),
    );
  }
}