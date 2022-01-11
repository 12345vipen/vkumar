import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/workers_on_site/khata_balance/transaction_page.dart';

import 'daily_transactions_page.dart';

class DailyDataDecoration extends StatefulWidget {
  final double rate;
  final int quantity;
  final bool isShirt;
  final bool isLower;
  final int ayian;
  final int khataNumber;
  final String userId;
  final String docId;
  final String createdAt;
  const DailyDataDecoration({Key? key,
    required this.rate,
    required this.quantity,
    required this.isShirt,
    required this.isLower,required this.createdAt,required this.ayian,required this.khataNumber,required this.userId,
  required this.docId})
      : super(key: key);

  @override
  State<DailyDataDecoration> createState() => _DailyDataDecorationState();
}

class _DailyDataDecorationState extends State<DailyDataDecoration> {
  String kiniAayi = "0";
  String toAdd = "no";
  String date=" kar reha";
  final _formKey = GlobalKey<FormState>();
  Future<Null> createDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Form(
            key: _formKey,
            child: AlertDialog(
              title: Text("Kinni Aayiyan?"),
              actions: [
                TextFormField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: "Enter no of ${widget.isShirt?"shirts":"Lower"}",
                    contentPadding: EdgeInsets.all(10),
                  ),
                  onChanged: (val) {
                    kiniAayi = val;

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
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = TextButton(
      child: Text("Delete"),
      onPressed: () {
        // Delete the Medications detail also
        final usersRef = FirebaseFirestore.instance
            .collection("khataCheck")
            .doc(widget.userId)
            .collection("workersData")
            .doc(widget.khataNumber.toString()).collection("dailyData").doc(widget.docId);

        usersRef.collection("transactions").get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs){
            ds.reference.delete();
          };
        });
        usersRef.delete();
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm delete"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  // Converting timeStamp into date
  @override
  void initState() {
    // TODO: implement initState
    String ans = "";
    for(int i=0;i<widget.createdAt.length;i++) {
      if(widget.createdAt[i]==" "){
          break;
      }
      ans = ans + widget.createdAt[i];
    }
    date = ans;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 8,
          ),
          Card(
            color: Colors.transparent,
            shadowColor: Colors.transparent,
            child: ListTile(
              leading: Image.network (widget.isShirt ? "https://vinikafashions.com/wp-content/uploads/2018/06/Denim-Shirt-300x300.png " : "https://m.media-amazon.com/images/I/717ndVMuDQL._UX466_.jpg"
              , fit: BoxFit.contain),

              trailing: Text(
                date,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Quantity: ${widget.quantity}",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Text(
                    "Rate: ${widget.rate}",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                  Text(
                    "Ayyian: ${widget.ayian}",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          Row(
            children: [
              SizedBox(width:MediaQuery.of(context).size.width*.1),
              InkWell(
                  onTap: ()async{
                    await createDialogBox(context);
                    print(toAdd);
                    if (toAdd == 'Add') {
                      final usersRef =  FirebaseFirestore.instance
                          .collection("khataCheck")
                          .doc(widget.userId)
                          .collection("workersData")
                          .doc(widget.khataNumber.toString()).collection("dailyData").doc(widget.docId);
                      await usersRef.update({'ayian': widget.ayian + int.parse(kiniAayi)});
                      final transcRef = FirebaseFirestore.instance
                          .collection("khataCheck")
                          .doc(widget.userId)
                          .collection("workersData")
                          .doc(widget.khataNumber.toString()).collection("dailyData").doc(widget.docId).collection("transactions");
                      await transcRef.add({'ayian':int.parse(kiniAayi),
                        'date': DateTime.parse(Timestamp.now().toDate().toString())
                            .toString(),
                        'createdAt': Timestamp.now(),
                        });
                    }
                    toAdd="";
                  },
                  child: Container(
                      color: Colors.black,
                      padding: EdgeInsets.fromLTRB(12,8, 12, 8),
                      child: Text('Kinni ayyian?',style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700,fontSize: 16),))),
              SizedBox(width:MediaQuery.of(context).size.width*.005),
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
                                    .doc(widget.khataNumber.toString()).collection("dailyData").doc(widget.docId).collection("transactions")
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

                                      return DailyTransactionPage(
                                          amount: document["ayian"],
                                          createdAt: document["date"],
                                        total:widget.ayian,
                                          khataNumber :widget.khataNumber,
                                          userId :widget.userId,
                                          docId :widget.docId,

                                        transcdocId: snapshot.data!.docs[index].id,

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
                icon: Icon(Icons.store),
                label: Text("History"),
              ),
              Spacer(),
              IconButton(onPressed: ()async{
                await showAlertDialog(context);
              }, icon: Icon(
                Icons.delete,
                color: Colors.red,
                size: MediaQuery.of(context).size.width*.07,
              ),),

            ],
          )
        ],
      ),
    );
  }
}
