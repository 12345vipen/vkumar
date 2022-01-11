import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateWorkerId extends StatefulWidget {
  @override
  _CreateWorkerIdState createState() => _CreateWorkerIdState();
}

class _CreateWorkerIdState extends State<CreateWorkerId> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = " ";

  _CreateWorkerIdState() {
    // very important if u wana change Future<String> into String
    getId().then((val) => setState(() {
          userId = val;
        }));
  }

  var _enteredName = '';
  var _enteredPhoneNo = '';
  var _enteredKhataNumber = 0;
  var _enteredAddress = '';
  final myControllerName = TextEditingController();
  final myControllerPhoneNo = TextEditingController();
  final myControllerKhataNumber = TextEditingController();
  final myControllerAddress = TextEditingController();

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final usersRef = FirebaseFirestore.instance
        .collection("khataCheck")
        .doc(userId)
        .collection("workersData")
        .doc(_enteredKhataNumber.toString());
    await FirebaseFirestore.instance
        .collection("khataCheck")
        .doc(userId)
        .collection("workersData")
        .doc(_enteredKhataNumber.toString())
        .collection("balance")
        .doc('balance')
        .set({'balance': 0.0});
    await usersRef.get().then((docSnapshot) => {
          if (docSnapshot.exists)
            {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Color(0xffc5cae9),
                  content: Row(
                    children: [
                      Icon(
                        Icons.sentiment_neutral,
                        color: Colors.redAccent,
                      ),
                      Text(
                        " Khata number must be Unique!",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * .05),
                      ),
                    ],
                  )))
            }
          else
            {
              if (_enteredName == '' ||
                  _enteredPhoneNo == '' ||
                  _enteredKhataNumber == 0 ||
                  _enteredAddress == '' ||
                  _enteredPhoneNo.length != 10)
                {

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      backgroundColor: Color(0xffc5cae9),
                      content: Row(
                        children: [
                          Icon(
                            Icons.sentiment_neutral,
                            color: Colors.redAccent,
                          ),
                          Text(' Please fill every field correctly!' ,
                            style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.width * .05),
                          ),
                        ],
                      )))
                }
              else
                {
                  usersRef.set({
                    'name': _enteredName,
                    'phoneNo': _enteredPhoneNo,
                    'khataNumber': _enteredKhataNumber,
                    'createdAt': Timestamp.now(),
                    'address': _enteredAddress,
                  }),
                  Navigator.pop(context)
                }
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Id'),
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
                height: 10,
              ),
              Expanded(
                child: TextField(
                    controller: myControllerName,
                    decoration: InputDecoration(
                      labelText: "Worker's name",
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    // onChanged:
                    onChanged: (value) {
                      setState(() {
                        _enteredName = value;
                      });
                    }),
              ),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: myControllerPhoneNo,
                    decoration: InputDecoration(
                      labelText: 'Phone number',
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    // onChanged:
                    onChanged: (value) {
                      setState(() {
                        _enteredPhoneNo = value;
                      });
                    }),
              ),
              Expanded(
                child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: myControllerKhataNumber,
                    decoration: InputDecoration(
                      labelText: 'Khata number',
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    // onChanged:
                    onChanged: (value) {
                      setState(() {
                        _enteredKhataNumber = int.parse(value);
                      });
                    }),
              ),
              Expanded(
                child: TextField(
                    controller: myControllerAddress,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      border: OutlineInputBorder(),
                    ),
                    // onChanged:
                    onChanged: (value) {
                      setState(() {
                        _enteredAddress = value;
                      });
                    }),
              ),
              RaisedButton(
                onPressed: _sendMessage,
                child: Text(
                  'Create',
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
