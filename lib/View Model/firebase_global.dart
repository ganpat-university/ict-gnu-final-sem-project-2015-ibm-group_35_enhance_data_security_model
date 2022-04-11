import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:enhance_security_model/Model/CustomerSupportModel.dart';
import 'package:enhance_security_model/Model/User.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'app_colors.dart';

class Database {
  /// The main Firestore user collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final CollectionReference customerSupportCollection = FirebaseFirestore.instance.collection('customer_support');

  storeUserData({
    required String? uid,
    required String name,
    required String userName,
    required String mobileNo,
    required String gender,
    required String email,
    required String dateOfBirth,
  }) async {
    DocumentReference documentReferencer = userCollection.doc(uid);

    User user = User(
      uid: uid,
      name: name,
      userName: userName,
      mobileNo: mobileNo,
      gender: gender,
      email: email,
      dateOfBirth: dateOfBirth,
    );

    var data = user.toJson();

    try {
      await documentReferencer.set(data).whenComplete(() {
        print("User data added");
      }).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

  storeCustomerSupportData({
    required String? uid,
    required String name,
    required String email,
    required String message,
  }) async {
    CollectionReference<Object?> documentReferencer = customerSupportCollection;

    CustomerSupportModel customerSupport = CustomerSupportModel(
      uid: uid,
      name: name,
      email: email,
      message: message,
    );

    var data = customerSupport.toJson();

    try {
      await documentReferencer.add(data).whenComplete(() {
        Fluttertoast.showToast(
          msg: 'Message is been Successfully Recoded. \n Will get back to you soon. \n Have a Wonderfull Day Ahead...!',
          textColor: AppColors.white,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: AppColors.white,
        );
      }).catchError((e) => print(e));
    } catch (e) {
      print(e);
    }
  }

}
