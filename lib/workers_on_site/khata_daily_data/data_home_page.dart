import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/workers_on_site/add_khata/worker_id_decoration.dart';
import 'package:med_tracker/workers_on_site/khata_balance/balance_home.dart';
import 'package:med_tracker/workers_on_site/khata_daily_data/daily_data_decoration.dart';

import 'add_daily_work.dart';

class DataHomePage extends StatefulWidget {
  final int khataNumber;

  const DataHomePage({Key? key, required this.khataNumber}) : super(key: key);

  @override
  _DataHomePageState createState() => _DataHomePageState();
}

class _DataHomePageState extends State<DataHomePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = " ";

  _DataHomePageState() {
    // very important if u wana change Future<String> into String
    getId().then((val) => setState(() {
          userId = val;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text('Khata: ${widget.khataNumber}'),
        actions: [
          InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddDailyWork(khataNumber: widget.khataNumber),
                  ));
            },
            child: Row(
              children: [
                Center(
                    child: Text(
                  "Daily Entry",
                  style: TextStyle(fontSize: 16),
                )),
                SizedBox(
                  width: 8,
                ),
                Icon(Icons.create),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("khataCheck")
                  .doc(userId)
                  .collection("workersData")
                  .doc(widget.khataNumber.toString())
                  .collection("dailyData")
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (BuildContext context, snapshot) {
                int countId = snapshot.data?.docs.length ?? 0;
                if (countId == 0) {
                  return SingleChildScrollView(
                    child: Container(
                        margin: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 30),
                            Image(
                              image: AssetImage("assets/Add Khata.png"),
                              width: MediaQuery.of(context).size.width * .9,
                              height: MediaQuery.of(context).size.height * .6,
                            ),
                            SizedBox(height: 10),
                            Center(child: CircularProgressIndicator()),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .1),
                          ],
                        )),
                  );
                }
                return ListView.builder(
                  itemBuilder: (context, index) {
                    Map<String, dynamic> document = snapshot.data!.docs[index]
                        .data() as Map<String, dynamic>;
                    return DailyDataDecoration(
                        rate: document["rate"],
                        quantity: document["quantity"],
                        isShirt: document["isShirt"],
                        isLower: document["isLower"],
                        ayian: document["ayian"],
                        userId: userId,
                        khataNumber: widget.khataNumber,
                        docId: snapshot.data!.docs[index].id,
                        createdAt: document["date"]);
                  },
                  itemCount: snapshot.data!.docs.length,
                );
              },
            ),
          ),
          InkWell(
            onTap: () async {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BalanceHome(
                        khataNumber: widget.khataNumber, userId: userId),
                  ));
            },
            child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.indigo,
              child: Row(
                children: [
                  Spacer(),
                  Text(
                    '   Balance',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: 28,
                    color: Colors.white,
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<String> getId() async {
    final user = await FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}

/*
rate: document["rate"],
                quantity: document["quantity"],
                isShirt: document["isShirt"],
                isLower: document["isLower"],
 */
