import 'package:cashcalculator/cash_calculator.dart';
import 'package:cashcalculator/search.dart';
import 'package:cashcalculator/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  final CollectionReference cashItem =
      FirebaseFirestore.instance.collection('cash');
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cash Calculator",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 1),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CashCalculator()));
              },
              icon: const Icon(
                Icons.add,
                size: 40,
                color: Colors.white,
              ))
        ],
        backgroundColor: primereColors,
      ),
      body: Stack(
        children: [
          StreamBuilder(
            stream: cashItem.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {
                return ListView.builder(
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return moneyBox(
                      documentSnapshot['title'],
                      documentSnapshot['totalAmount'].toString(),
                      documentSnapshot['date'],
                      documentSnapshot['time'].toString(),
                      documentSnapshot['id'],
                    );
                  },
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: CircleAvatar(
                  backgroundColor: primereColors,
                  maxRadius: 28,
                  child: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SearchData()));
                      },
                      icon: const Icon(
                        Icons.search,
                        size: 40,
                        color: Colors.white,
                      ))))
        ],
      ),
    );
  }

  Widget moneyBox(
      String name, String amount, String date, String time, String id) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Container(
        height: 80,
        color: const Color.fromARGB(255, 210, 210, 240),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Amount : ₹$amount",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "Date : $date , Time : $time",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, color: Colors.black54),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CashCalculator(
                                    id: id,
                                  )));
                    },
                    icon: const Icon(Icons.edit, size: 30),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Future<List<CashModel>> fetchCashData() async {
  //   try {
  //     QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection('cash').get();

  //     List<CashModel> dataList = snapshot.docs.map((doc) {
  //       return CashModel.fromSnapshot(doc);
  //     }).toList();

  //     return dataList;
  //   } catch (e) {
  //     print("Error fetching data: $e");
  //     return [];
  //   }
  // }
}
