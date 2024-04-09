import 'package:cashcalculator/home_page.dart';
import 'package:cashcalculator/model.dart';
import 'package:cashcalculator/style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CashCalculator extends StatefulWidget {
  final String? id;
  const CashCalculator({super.key, this.id});

  @override
  State<CashCalculator> createState() => _CashCalculatorState();
}

class _CashCalculatorState extends State<CashCalculator> {
  int notes2000 = 0;
  int notes500 = 0;
  int notes200 = 0;
  int notes100 = 0;
  int notes50 = 0;
  int totalAmount = 0;
  int totalNotes = 0;
  final TextEditingController _title = TextEditingController();
  final TextEditingController _notes2000 = TextEditingController();
  final TextEditingController _notes500 = TextEditingController();
  final TextEditingController _notes200 = TextEditingController();
  final TextEditingController _notes100 = TextEditingController();
  final TextEditingController _notes50 = TextEditingController();
  bool _isRefreshed = false;

  String? dataTitel;
  String? data2000;
  String? data500;
  String? data200;
  String? data100;
  String? data50;

  final CollectionReference cashItem =
      FirebaseFirestore.instance.collection('cash');

  @override
  void initState() {
    super.initState();
    _notes2000.addListener(_updateNots2000);
    _notes500.addListener(_updateNots500);
    _notes200.addListener(_updateNots200);
    _notes100.addListener(_updateNots100);
    _notes50.addListener(_updateNots50);
  }

  void _updateNots2000() {
    setState(() {
      int enteredValue = int.tryParse(_notes2000.text) ?? 0;
      notes2000 = enteredValue * 2000;
      _updateNotsTotal();
      _updateNotsCount();
    });
  }

  void _updateNots500() {
    setState(() {
      int enteredValue = int.tryParse(_notes500.text) ?? 0;
      notes500 = enteredValue * 500;
      _updateNotsTotal();
      _updateNotsCount();
    });
  }

  void _updateNots200() {
    setState(() {
      int enteredValue = int.tryParse(_notes200.text) ?? 0;
      notes200 = enteredValue * 200;
      _updateNotsTotal();
      _updateNotsCount();
    });
  }

  void _updateNots100() {
    setState(() {
      int enteredValue = int.tryParse(_notes100.text) ?? 0;
      notes100 = enteredValue * 100;
      _updateNotsTotal();
      _updateNotsCount();
    });
  }

  void _updateNots50() {
    setState(() {
      int enteredValue = int.tryParse(_notes50.text) ?? 0;
      notes50 = enteredValue * 50;
      _updateNotsTotal();
      _updateNotsCount();
    });
  }

  void _updateNotsTotal() {
    setState(() {
      totalAmount = notes2000 + notes500 + notes200 + notes100 + notes50;
    });
  }

  void _updateNotsCount() {
    setState(() {
      int nots1 = int.tryParse(_notes2000.text) ?? 0;
      int nots2 = int.tryParse(_notes500.text) ?? 0;
      int nots3 = int.tryParse(_notes200.text) ?? 0;
      int nots4 = int.tryParse(_notes100.text) ?? 0;
      int nots5 = int.tryParse(_notes50.text) ?? 0;
      totalNotes = nots1 + nots2 + nots3 + nots4 + nots5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color.fromARGB(255, 210, 210, 240),
      appBar: AppBar(
        leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: const Icon(Icons.arrow_back_ios,color: Colors.white,size: 26,)),
        title: const Text("Cash Calculator",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 30,
                letterSpacing: 1)),
        backgroundColor: primereColors,
      ),
      body: StreamBuilder(
        stream: cashItem.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            int no = 0;
            int count = streamSnapshot.data!.docs.length;
            for (no; no < count; no++) {
              final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[no];
              final String indexId = documentSnapshot['id'];
              if (widget.id == indexId) {
                break;
              }
            }
            if(no < count){
              DocumentSnapshot ds = streamSnapshot.data!.docs[no];
              WidgetsBinding.instance.addPostFrameCallback((_) {
              dataget(ds);
              });
            }
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Add a Title : ",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    TextFormField(
                      controller: _title,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7)),
                        hintText: "Enter a title",
                        labelText: "Title",
                      ),
                    ),
                    const SizedBox(
                      height: 7,
                    ),
                    notsCountRow(
                        "2000", "2000 Nots", notes2000.toString(), _notes2000),
                    notsCountRow(
                        " 500", "500 Nots", notes500.toString(), _notes500),
                    notsCountRow(
                        " 200", "200 Nots", notes200.toString(), _notes200),
                    notsCountRow(
                        " 100", "100 Nots", notes100.toString(), _notes100),
                    notsCountRow(
                        "  50", "50 Nots", notes50.toString(), _notes50),
                    div(),
                    Text(
                      "  Total Amuount : $totalAmount",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    div(),
                    Text(
                      "  Total Nots Counts : $totalNotes",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    div(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              if(widget.id != null){
                                deleteData(widget.id.toString());
                                Navigator.popUntil(context, (route) => route.isFirst);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreens()));
                              }else{
                                Navigator.popUntil(context, (route) => route.isFirst);
                                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreens()));
                              }
                            },
                            child: saveAndDeletButtion(Icons.delete, " Delete"),
                          ),
                          InkWell(
                            onTap: () {
                              if(widget.id == null){
                                createData();
                                // print("**************************************");
                              }else{
                                updateData();
                                // print("--------------------------------------------");
                              }
                              Navigator.popUntil(context, (route) => route.isFirst);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreens()));
                            },
                            child: saveAndDeletButtion(Icons.save, " Save"),
                          ),
                        ],
                      ),
                    ),
                    div(),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Divider div() {
    return Divider(
      thickness: 2,
      color: primereColors,
    );
  }

  Container saveAndDeletButtion(buttionIcon, String title) {
    return Container(
      height: 50,
      width: 120,
      decoration: BoxDecoration(
        color: primereColors,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            buttionIcon,
            color: Colors.white,
          ),
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget notsCountRow(String nots, String hintTextTitle, String notsCount,
      TextEditingController controler) {
    return Row(
      children: [
        SizedBox(
          width: 50,
          child: Text(
            nots,
            style: const TextStyle(fontSize: 20),
          ),
        ),
        const Text(
          " *  ",
          style: TextStyle(fontSize: 30),
        ),
        SizedBox(
          width: 150,
          height: 60,
          child: TextFormField(
            controller: controler,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: hintTextTitle,
            ),
          ),
        ),
        const Text(
          "  = ",
          style: TextStyle(fontSize: 30),
        ),
        Text(
          notsCount,
          style: const TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  void createData() {
    final cashCollection = FirebaseFirestore.instance.collection("cash");
    String id = cashCollection.doc().id;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    final newData = CashModel(
      id: id,
      title: _title.text,
      date: formattedDate,
      time: formattedTime,
      notes2000: notes2000,
      notes500: notes500,
      notes200: notes200,
      notes100: notes100,
      notes50: notes50,
      totalAmount: totalAmount,
      notesCount2000: int.tryParse(_notes2000.text),
      notesCount500: int.tryParse(_notes500.text),
      notesCount200: int.tryParse(_notes200.text),
      notesCount100: int.tryParse(_notes100.text),
      notesCount50: int.tryParse(_notes50.text),
      totalNotes: totalNotes,
    ).toJson();

    cashCollection.doc(id).set(newData);
  }

  void updateData() {
    final cashCollection = FirebaseFirestore.instance.collection("cash");
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd-MM-yyyy').format(now);
    String formattedTime = DateFormat('HH:mm:ss').format(now);
    final newData = CashModel(
      id: widget.id,
      title: _title.text,
      date: formattedDate,
      time: formattedTime,
      notes2000: notes2000,
      notes500: notes500,
      notes200: notes200,
      notes100: notes100,
      notes50: notes50,
      totalAmount: totalAmount,
      notesCount2000: int.tryParse(_notes2000.text),
      notesCount500: int.tryParse(_notes500.text),
      notesCount200: int.tryParse(_notes200.text),
      notesCount100: int.tryParse(_notes100.text),
      notesCount50: int.tryParse(_notes50.text),
      totalNotes: totalNotes,
    ).toJson();
    cashCollection.doc(widget.id).set(newData);
  }
  void deleteData(String id) {
  final userCollection = FirebaseFirestore.instance.collection("cash");
  userCollection.doc(id).delete();
}

  void dataget(DocumentSnapshot ds) {
    dataTitel = ds['title'];
    data2000 = ds['notesCount2000'].toString();
    data500 = ds['notesCount500'].toString();
    data200 = ds['notesCount200'].toString();
    data100 = ds['notesCount100'].toString();
    data50 = ds['notesCount50'].toString();
    if (!_isRefreshed) {
      refresh();
      _isRefreshed = true; // Prevents further refresh calls
    }
    _updateNots2000();
    _updateNots500();
    _updateNots200();
    _updateNots100();
    _updateNots50();
  }

  void refresh() {
    _title.text = dataTitel.toString();
    _notes2000.text = data2000.toString();
    _notes500.text = data500.toString();
    _notes200.text = data200.toString();
    _notes100.text = data100.toString();
    _notes50.text = data50.toString();
  }

  @override
  void dispose() {
    _notes2000.dispose(); // Don't forget to dispose the controller.
    _notes500.dispose(); // Don't forget to dispose the controller.
    _notes200.dispose(); // Don't forget to dispose the controller.
    _notes100.dispose(); // Don't forget to dispose the controller.
    _notes50.dispose(); // Don't forget to dispose the controller.
    super.dispose();
  }
}

// Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Add a Title : ",
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//               ),
//               const SizedBox(
//                 height: 3,
//               ),
//               TextFormField(
//                 controller: _title,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(7)),
//                   hintText: "Enter a title",
//                   labelText: "Title",
//                 ),
//               ),
//               const SizedBox(
//                 height: 7,
//               ),
//               notsCountRow(
//                   "2000", "2000 Nots", notes2000.toString(), _notes2000),
//               notsCountRow(" 500", "500 Nots", notes500.toString(), _notes500),
//               notsCountRow(" 200", "200 Nots", notes200.toString(), _notes200),
//               notsCountRow(" 100", "100 Nots", notes100.toString(), _notes100),
//               notsCountRow("  50", "50 Nots", notes50.toString(), _notes50),
//               div(),
//               Text(
//                 "  Total Amuount : $totalAmount",
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//               ),
//               div(),
//               Text(
//                 "  Total Nots Counts : $totalNotes",
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
//               ),
//               div(),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 10),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     InkWell(
//                       onTap: () {},
//                       child: saveAndDeletButtion(Icons.delete, " Delete"),
//                     ),
//                     InkWell(
//                       onTap: () {
//                         createData();
//                         print("*************************************");
//                         print("Data is uploded.");
//                         Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreens()));
//                       },
//                       child: saveAndDeletButtion(Icons.save, " Save"),
//                     ),
//                   ],
//                 ),
//               ),
//               div(),
//             ],
//           ),
//         ),
//       ),
