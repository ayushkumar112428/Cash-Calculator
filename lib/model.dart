import 'package:cloud_firestore/cloud_firestore.dart';

class CashModel {
  final String? id;
  final String? title;
  final String? date;
  final String? time;
  final int? notes2000;
  final int? notes500;
  final int? notes200;
  final int? notes100;
  final int? notes50;
  final int? totalAmount;
  final int? notesCount2000;
  final int? notesCount500;
  final int? notesCount200;
  final int? notesCount100;
  final int? notesCount50;
  final int? totalNotes;

  CashModel(
      {required this.id,
      required this.title,
      required this.date,
      required this.time,
      required this.notes2000,
      required this.notes500,
      required this.notes200,
      required this.notes100,
      required this.notes50,
      required this.totalAmount,
      required this.notesCount2000,
      required this.notesCount500,
      required this.notesCount200,
      required this.notesCount100,
      required this.notesCount50,
      this.totalNotes});

  static CashModel fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    return CashModel(
      id: snapshot['id'],
      title: snapshot['title'],
      date: snapshot['date'],
      time: snapshot['time'],
      notes2000: snapshot['notes2000'],
      notes500: snapshot['notes500'],
      notes200: snapshot['notes200'],
      notes100: snapshot['notes100'],
      notes50: snapshot['notes50'],
      totalAmount: snapshot['totalAmount'],
      notesCount2000: snapshot['notesCount2000'],
      notesCount500: snapshot['notesCount500'],
      notesCount200: snapshot['notesCount200'],
      notesCount100: snapshot['notesCount100'],
      notesCount50: snapshot['notesCount50'],
      totalNotes: snapshot['totalNotes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "date": date,
      "time": time,
      "notes2000": notes2000,
      "notes500": notes500,
      "notes200": notes200,
      "notes100": notes100,
      "notes50": notes50,
      "totalAmount": totalAmount,
      "notesCount2000": notesCount2000,
      "notesCount500": notesCount500,
      "notesCount200": notesCount200,
      "notesCount100": notesCount100,
      "notesCount50": notesCount50,
      'totalNotes': totalAmount,
    };
  }
}
