import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/workers_on_site/khata_balance/transaction_page.dart';

class BalanceHome extends StatefulWidget {
  final int khataNumber;
  final String userId;

  const BalanceHome({Key? key, required this.userId, required this.khataNumber})
      : super(key: key);

  @override
  _BalanceHomeState createState() => _BalanceHomeState();
}

class _BalanceHomeState extends State<BalanceHome> {
  int amount = 0;
  String toAdd = "no";
  num firebase_balance = 0;
  final _formKey = GlobalKey<FormState>();

  Future<Null> createDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text("Amount paid..."),
              actions: [
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter Amount}",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onChanged: (val) {
                    amount = int.parse(val);
                  },
                ),
                MaterialButton(
                  onPressed: () {
                    toAdd = 'Add';
                    Navigator.pop(context);
                  },
                  elevation: 5.0,
                  child: Text('Add'),
                )
              ],
            ),
          );
        });
  }

  num workerbalance = -100000000000000000; // dummy value

  _balanceCalculator() async {
    num balance = 0;
    await FirebaseFirestore.instance
        .collection("khataCheck")
        .doc(widget.userId)
        .collection("workersData")
        .doc(widget.khataNumber.toString())
        .collection("balance")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        balance = doc["balance"];
      });
    });
    firebase_balance = balance;
    final usersRef = FirebaseFirestore.instance
        .collection("khataCheck")
        .doc(widget.userId)
        .collection("workersData")
        .doc(widget.khataNumber.toString())
        .collection("dailyData");
    await usersRef.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        balance = balance + doc["ayian"] * doc["rate"];
      });
    });
    setState(() {
      workerbalance = balance;
    });
    // print("balance: ${balance}");
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _balanceCalculator();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Balance'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
              children: [
              SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.account_balance,
                size: MediaQuery
                    .of(context)
                    .size
                    .height * .07,
                color: Colors.black,
              ),
              title: Text("Balance"),
              trailing: workerbalance == -100000000000000000
                  ? CircularProgressIndicator()
                  : Text(
                "Rs ${workerbalance.toString()}",
                style: TextStyle(
                    color: (workerbalance >= 0
                        ? Colors.green
                        : Colors.red),
                    fontWeight: FontWeight.w500,
                    fontSize: 18),
              ),
            ),
          ),
          SizedBox(height: 70),
          Container(
            child: Column(
                children: [
            Card(
            child: ListTile(
            title: Text(
                'How much money did you paid to your worker today??'),
          ),
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
          heroTag: null,
          splashColor: Colors.red,
          onPressed: () async {
            await createDialogBox(context);
            print(toAdd);
            if (toAdd == 'Add' && amount>0) {
              final usersRef = FirebaseFirestore.instance
                  .collection("khataCheck")
                  .doc(widget.userId)
                  .collection("workersData")
                  .doc(widget.khataNumber.toString()).collection("balance").doc(
                  "balance");
              await usersRef.update(
                  {'balance': -1 * (-1 * firebase_balance + amount)});
            }
            if(amount>0) {
              final usersRef = FirebaseFirestore.instance
                  .collection("khataCheck")
                  .doc(widget.userId)
                  .collection("workersData")
                  .doc(widget.khataNumber.toString())
                  .collection("transactions");
              await usersRef.add({
                'date': DateTime.parse(Timestamp.now().toDate().toString())
                    .toString(),
                'createdAt': Timestamp.now(),
                'amount': amount
              });
            }
            // initState();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => this.widget));
          },
          icon: Icon(Icons.save),
          label: Text("Give money"),
        ),
        SizedBox(height: 10),
        FloatingActionButton.extended(
            heroTag: null,
            splashColor: Colors.red,
            onPressed: () {
              showModalBottomSheet<void>(
                backgroundColor: Colors.transparent,
                context: context,
                builder: (BuildContext context) {

                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(top:Radius.circular(20),bottom: Radius.circular(8) ),
                      color: Colors.yellow[200],
                    ),
                    padding: EdgeInsets.fromLTRB(2, 8, 2, 0),
                    margin:  EdgeInsets.all(8),
                    height: MediaQuery.of(context).size.height*.7,

                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: [
                            Text('  Transaction history',style: TextStyle(color: Colors.indigo,fontSize: 20,fontWeight: FontWeight.bold),),
                            Spacer(),
                            IconButton(
                              onPressed: () => Navigator.pop(context), icon: Icon(Icons.close),
                            ),
                          ],
                        ),
                        Flexible(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection("khataCheck")
                                .doc(widget.userId)
                                .collection("workersData")
                                .doc(widget.khataNumber.toString())
                                .collection("transactions")
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
                                          SizedBox(height: 50),
                                          Text('No Transactions yet!',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.black),),
                                          SizedBox(height: 50),
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

                                  return TransactionPage(
                                    amount: document["amount"],
                                      createdAt: document["date"]
                                  );
                                },
                                itemCount: snapshot.data!.docs.length,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            icon: Icon(Icons.monetization_on_sharp),
        label: Text("Transaction History"),
      ),
      ],
    ),
    )
    ],
    ),
    ),
    ));
  }
}
