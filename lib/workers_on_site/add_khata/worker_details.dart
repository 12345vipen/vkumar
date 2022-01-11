import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/workers_on_site/add_khata/worker_id_decoration.dart';

import 'create_worker_id.dart';


class WorkerDetails extends StatefulWidget {
  const WorkerDetails({Key? key}) : super(key: key);

  @override
  _WorkerDetailsState createState() => _WorkerDetailsState();
}

class _WorkerDetailsState extends State<WorkerDetails> {
  FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";

  _WorkerDetailsState() {
    // very important if u wana change Future<String> into String
    getId().then((val) => setState(() {
      userId = val;
    }));
  }

  @override
  Widget build(BuildContext context) {
    return (userId == "")
        ? CircularProgressIndicator()
        : Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Row(
          children: [
            Text(
              "khata",
              style: TextStyle(color: Colors.white),
            ),
            Text("Check",
                style: TextStyle(color: Colors.amber, fontSize: 23)),
          ],
        ),
        actions: [
          InkWell(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateWorkerId(),
                  ));
            },
            child: Row(
              children: [
                Center(
                    child: Text(
                      "Add Khata",
                      style: TextStyle(fontSize: 18),
                    )),
                SizedBox(width: 8,),
                Icon(Icons.create),
                SizedBox(width: 5,),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("khataCheck")
            .doc(userId)
            .collection("workersData").orderBy('name', descending: false)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          int countId = snapshot.data?.docs.length??0;
          if (countId==0) {
            return SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height:100),
                  Text("Nothing Added Yet!",style: TextStyle(color: Colors.blue,fontSize: 22),),
                  SizedBox(height:10),
                  Text("Click on Create Id button on top."),
                  SizedBox(height:100),
                  Center(child: CircularProgressIndicator()),
                ],
              )),
            );
          }
          return ListView.builder(
            itemBuilder: (context, index) {
              Map<String,dynamic> document = snapshot.data!.docs[index].data() as Map<String,dynamic>;
              return WorkerIdDecoration(
                name:document["name"],
                khataNumber:document["khataNumber"],
                address:document["address"],
                phoneNo:document["phoneNo"],
                userId:userId
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }

  Future<String> getId() async {
    final user = await FirebaseAuth.instance.currentUser!;
    return user.uid;
  }
}
