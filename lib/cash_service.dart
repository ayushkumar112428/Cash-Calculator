import 'package:cashcalculator/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Adjust the import path to where your CashModel class is defined

class CashService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<CashModel>> fetchCashData() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('cash').get();

      List<CashModel> dataList = snapshot.docs.map((doc) {
        return CashModel.fromSnapshot(doc);
      }).toList();
      return dataList;
    } catch (e) {
      return [];
    }
  }
}
