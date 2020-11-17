import 'package:first_app/PaymentWebView.dart';
import 'package:first_app/PaymentRequest.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: PaymentPage(title: 'Gkash App Integration'),
    );
  }
}

class PaymentPage extends StatefulWidget {
  PaymentPage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _PaymentPageState createState() => new _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController _amountController = new TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Gkash App Integration"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
        child: Form(
          key: _formKey,
          //autovalidate: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Amount",
                    hintText: "Please enter payment amount",
                  ),
                  validator: (v) {
                    return v.trim().length > 0 ? null : "Amount cannot be null";
                  }),
              Padding(
                padding: const EdgeInsets.only(top: 28.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        padding: EdgeInsets.all(15.0),
                        child: Text("Submit"),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async {
                          if ((_formKey.currentState as FormState).validate()) {
                            String version = "1.5.1";
                            String cid = 'M161-U-33';
                            String currency = 'MYR';
                            String signatureKey = 'oAhVwtUxfrop4cI';
                            String cartID = new DateFormat('yyyyMMddHHmmss')
                                .format(DateTime.now());
							
							String amount = double.parse(_amountController.text).toStringAsFixed(2);
							

                            final paymentRequest = PaymentRequest(
								version,
                                cid,
                                currency,
                                amount,
                                cartID,
                                signatureKey,
                                callbackurl:
                                    "https://paymentdemo.gkash.my/callback.php",
                                email: "test@example.com",
                                mobileNo: "0123456789");

                            var urlLink = await Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return PaymentWebView(
                                  paymentRequest: paymentRequest);
                            }));

                            var urlData = "";
           
                            Uri url = Uri.parse(urlLink);
                            //Get All Data
                            // url.queryParameters.forEach((key, value) {
                            //   urlData += (key + ': ' + value + '\n');
                            // });

                            urlData = "Status:" + url.queryParameters['status'] + 
                                      "\nDescription: " + url.queryParameters['description'] + 
                                      "\nCID: " + url.queryParameters['CID'] + 
                                      "\nPOID: " + url.queryParameters['POID'] + 
                                      "\nCartID: " + url.queryParameters['cartid'] + 
                                      "\nAmount: " + url.queryParameters['amount'] + 
                                      "\nCurrency: " + url.queryParameters['currency'] + 
                                      "\nPaymentType: " + url.queryParameters['PaymentType'];
                            print('\n------------------------------------------------------------');
                            print(urlLink);
                            print(urlData);
                            print('------------------------------------------------------------\n');
                     
                            Fluttertoast.showToast(
                                msg: urlData,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 7,
                                toastLength: Toast.LENGTH_LONG
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
