import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddDailyWork extends StatefulWidget {
  final int khataNumber;

  const AddDailyWork({Key? key, required this.khataNumber}) : super(key: key);

  @override
  _AddDailyWorkState createState() => _AddDailyWorkState();
}

class _AddDailyWorkState extends State<AddDailyWork> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";

  _AddDailyWorkState() {
    // very important if u wana change Future<String> into String
    getId().then((val) => setState(() {
          userId = val;
        }));
  }

  bool isShirt = false; // by default shirt
  bool isLower = false;
  double _enteredRate = 0.0;
  var _enteredQuantity = 0;
  final myControllerRate = TextEditingController();
  final myControllerQuantity = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final usersRef = FirebaseFirestore.instance
        .collection("khataCheck")
        .doc(userId)
        .collection("workersData")
        .doc(widget.khataNumber.toString())
        .collection("dailyData");
    await usersRef.add({
      'rate': _enteredRate,
      'quantity': _enteredQuantity,
      'createdAt': Timestamp.now(),
      'date': DateTime.parse(Timestamp.now().toDate().toString()).toString(),
      'isShirt': isShirt,
      'isLower': isLower,
      'ayian': 0,
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Daily Data'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Card(
        margin: EdgeInsets.all(12.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25.0),
                    image: DecorationImage(
                        image: NetworkImage(
                            'https://images.hindustantimes.com/img/2021/09/11/550x309/093e2998-b888-11eb-9ee8-2b7e240d8f0f_1621418116674_1631323168434.jpg'),
                        fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text('Choose Category!', style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: isShirt,
                      onChanged: (bool? value) {
                        setState(() {
                          isShirt = !isShirt;
                          isLower = !isShirt;
                        });
                      }),
                  Text('Shirt'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                      value: isLower,
                      onChanged: (bool? value) {
                        setState(() {
                          isLower = !isLower;
                          isShirt = !isLower;
                        });
                      }),
                  Text('Lower'),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: myControllerRate,
                    decoration: InputDecoration(
                      labelText: 'Rate',
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    // onChanged:
                    onChanged: (value) {
                      setState(() {
                        _enteredRate = double.parse(value);
                      });
                    }),
              ),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: myControllerQuantity,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    // onChanged:
                    onChanged: (value) {
                      setState(() {
                        _enteredQuantity = int.parse(value);
                      });
                    }),
              ),
              RaisedButton(
                onPressed: _sendMessage,
                child: Text(
                  'Add',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
                color: Colors.deepPurple,
              ),
            ],
          )),
        ),
      ),
    );
  }

  Future<String> getId() async {
    final user = await FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
