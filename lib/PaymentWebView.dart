import 'package:first_app/PaymentRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:convert';


class PaymentWebView extends StatefulWidget {
  final PaymentRequest paymentRequest;
  PaymentWebView({Key key, this.paymentRequest}) : super(key: key);
  @override
  _PaymentWebViewState createState() => new _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  InAppWebViewController webView;
  String url = "";
  String _hostUrl = "https://api-staging.pay.asia/";
  double progress = 0;


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Container(
          padding: EdgeInsets.all(10.0),
          child: progress < 1.0
              ? LinearProgressIndicator(value: progress)
              : Container()),
      Expanded(
        child: Container(
          margin: const EdgeInsets.all(10.0),
          decoration:
              BoxDecoration(border: Border.all(color: Colors.blueAccent)),
          child: InAppWebView(
            initialUrl: _hostUrl + 'api/PaymentForm.aspx',
            initialHeaders: {},
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              webView = controller;
              var data = (
                "version=" + Uri.encodeComponent(widget.paymentRequest.version ?? "") +
                "&CID=" + Uri.encodeComponent(widget.paymentRequest.cid ?? "") +
                "&v_currency=" + Uri.encodeComponent(widget.paymentRequest.currency ?? "") +
                "&v_amount=" + Uri.encodeComponent(widget.paymentRequest.amount ?? "") +
                "&v_cartid=" + Uri.encodeComponent(widget.paymentRequest.cartid ?? "") +
                "&v_firstname=" + Uri.encodeComponent(widget.paymentRequest.firstName ?? "") +
                "&v_lastname=" + Uri.encodeComponent(widget.paymentRequest.lastName ?? "") +
                "&v_billemail=" + Uri.encodeComponent(widget.paymentRequest.email ?? "") +
                "&v_billstreet=" + Uri.encodeComponent(widget.paymentRequest.billingStreet ?? "") +
                "&v_billpost=" + Uri.encodeComponent(widget.paymentRequest.billingPostCode ?? "") +
                "&v_billcity=" + Uri.encodeComponent(widget.paymentRequest.billingCity ?? "") +
                "&v_billstate=" + Uri.encodeComponent(widget.paymentRequest.billingState ?? "") +
                "&v_billcountry=" + Uri.encodeComponent(widget.paymentRequest.billingCountry ?? "") +
                "&v_billphone=" + Uri.encodeComponent(widget.paymentRequest.mobileNo ?? "") +
                "&returnurl=" + Uri.encodeComponent(widget.paymentRequest.returnurl ?? "") +
                "&callbackurl=" + Uri.encodeComponent(widget.paymentRequest.callbackurl?? "") +
                "&v_productdesc=" + Uri.encodeComponent(widget.paymentRequest.productDescription ?? "") +
                "&signature=" + Uri.encodeComponent(widget.paymentRequest.generateSignature() ?? ""));

              debugPrint("data:" + data);

              controller.postUrl(
                  url: _hostUrl + "api/PaymentForm.aspx",
                  postData: utf8.encode(data)); 
            },
            onLoadStart: (InAppWebViewController controller, String url) {
              setState(() {
                this.url = url;
              });
            },
            onLoadStop: (InAppWebViewController controller, String url) async {
              setState(() {
                this.url = url;
              });
            },
            onProgressChanged:
                (InAppWebViewController controller, int progress) {
              setState(() {
                this.progress = progress / 100;
              });
            },
          ),
        ),
      ),
	  Container(
		width: double.infinity,
		child: RaisedButton(
              child: Text("Return To Merchant"),
              onPressed: () {
				          Navigator.pop(context, url);
              },
            ),
	  ),
    ]));
    
  }
}
