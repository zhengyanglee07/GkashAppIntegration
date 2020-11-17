

import 'package:crypto/crypto.dart';
import 'dart:convert';

class PaymentRequest{
  final String version;
  final String cid;
  final String currency;
  final String amount;
  final String cartid;
  final String signatureKey;
  final String callbackurl;
  final String returnurl;
  final String email;
  final String mobileNo;
  final String firstName;
  final String lastName;
  final String productDescription;
  final String billingStreet;     
  final String billingPostCode;
  final String billingCity;
  final String billingState;
  final String billingCountry;

  PaymentRequest(
    this.version,
    this.cid,
    this.currency,
    this.amount,
    this.cartid,
    this.signatureKey,
    {
      this.callbackurl,
      this.returnurl,
      this.email,
      this.mobileNo,
      this.firstName,
      this.lastName,
      this.productDescription,
      this.billingStreet,
      this.billingPostCode,
      this.billingCity,
      this.billingState,
      this.billingCountry,
    }
  );


  String generateSignature(){
    String sign = (signatureKey + ";" +
     cid + ";" + cartid + ";" + amount.replaceAll(".", "") + ";" + currency).toUpperCase();
    var signaureHash = sha512.convert(utf8.encode(sign));

    return signaureHash.toString().toLowerCase();
  }
}
