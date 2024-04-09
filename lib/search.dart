import 'package:cashcalculator/cash_calculator.dart';
import 'package:cashcalculator/cash_service.dart';
import 'package:cashcalculator/model.dart';
import 'package:cashcalculator/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchData extends StatefulWidget {
  // final List<CashModel> listOfData;
  const SearchData({super.key,});

  @override
  State<SearchData> createState() => _SearchDataState();
}

class _SearchDataState extends State<SearchData> {
  final CollectionReference cashItem = FirebaseFirestore.instance.collection('cash');
  List<CashModel> listOfData =[];
  List<CashModel> searchdata = [];
  @override
  void initState() {
    loadData();
    super.initState();
    searchdata = listOfData;
    super.initState();
  }
  Future<void> loadData() async {
    var cashService = CashService(); // Assuming CashService is your class that contains the fetchCashData method
    var fetchedData = await cashService.fetchCashData();
    setState(() {
      listOfData.addAll(fetchedData);
    });
  }

  void runFilter(String enteredKeyword) {
    List<CashModel> results;
    if (enteredKeyword.isEmpty) {
      // If the search term is empty, display all data.
      results = listOfData;
    } else {
      // Filter the list based on the search term. Ignore case and null titles.
      results = listOfData.where((item) {
        final titleLower = item.title?.toLowerCase() ?? '';
        final searchLower = enteredKeyword.toLowerCase();
        return titleLower.contains(searchLower);
      }).toList();
    }

    // Update the UI with the search results.
    setState(() {
      searchdata = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 26,
            )),
        title: const Text(
          "Cash Calculator",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
              letterSpacing: 1),
        ),
        backgroundColor: primereColors,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.black,
              onChanged: (value) => runFilter(value),
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                hintText: "Search",
                suffixIcon: Icon(
                  Icons.search,
                  color: primereColors,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    gapPadding: 2,
                    borderSide: BorderSide(
                      color: primereColors,
                      width: 2,
                      style: BorderStyle.solid,
                    )),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: searchdata.isNotEmpty
                    ? ListView.builder(
                        itemCount: searchdata.length,
                        itemBuilder: (context, index) {
                          return moneyBox(
                              searchdata[index].title.toString(),
                              searchdata[index].totalAmount.toString(),
                              searchdata[index].date.toString(),
                              searchdata[index].time.toString(),
                              searchdata[index].id.toString());
                        },
                      )
                    : const Text("Not Data Found."))
          ],
        ),
      ),
    );
  }

  Stream<List<CashModel>> readData() {
    final userCollection = FirebaseFirestore.instance.collection("users");

    return userCollection.snapshots().map((qureySnapshot) => qureySnapshot.docs
        .map(
          (e) => CashModel.fromSnapshot(e),
        )
        .toList());
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
}

// Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(
//               Icons.arrow_back_ios,
//               color: Colors.white,
//               size: 26,
//             )),
//         title: const Text(
//           "Cash Calculator",
//           style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 30,
//               letterSpacing: 1),
//         ),
//         backgroundColor: primereColors,
//       ),
//       body: StreamBuilder(
//           stream: cashItem.snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//             if (streamSnapshot.hasData) {
//               int i = 0;
//               while (i < streamSnapshot.data!.docs.length) {
//                 DocumentSnapshot d = streamSnapshot.data!.docs[i];
//                 listOfData.add(d.data() as Map<String, dynamic>);
//                 i++;
//               }
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     TextField(
//                       cursorColor: Colors.black,
//                       onChanged: (value) => runFilter(value),
//                       decoration: InputDecoration(
//                         contentPadding: const EdgeInsets.symmetric(
//                             vertical: 10.0, horizontal: 15),
//                         hintText: "Search",
//                         suffixIcon: Icon(
//                           Icons.search,
//                           color: primereColors,
//                         ),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(20.0),
//                             gapPadding: 2,
//                             borderSide: BorderSide(
//                               color: primereColors,
//                               width: 2,
//                               style: BorderStyle.solid,
//                             )),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     Expanded(
//                         child: searchdata.isNotEmpty
//                             ? ListView.builder(
//                               itemCount: searchdata.length,
//                               itemBuilder: (context, index) {
//                                 return moneyBox(searchdata[index]['name'], searchdata[index]['totalAmount'].toString(), searchdata[index]['date'], searchdata[index]['time'], searchdata[index]['id']);
//                               },
//                             )
//                             : Container(
//                                 child: Text("Not Data Found."),
//                               ))
//                   ],
//                 ),
//               );
//             }
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           }),
//     );