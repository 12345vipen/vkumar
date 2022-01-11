import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:med_tracker/workers_on_site/khata_daily_data/data_home_page.dart';

class WorkerIdDecoration extends StatefulWidget {
  final String name;
  final String userId;
  final String phoneNo;
  final String address;
  final int khataNumber;

  const WorkerIdDecoration(
      {Key? key,
        required this.name,
        required this.khataNumber,
        required this.address,
        required this.phoneNo,
      required this.userId})
      : super(key: key);

  @override
  _WorkerIdDecorationState createState() => _WorkerIdDecorationState();
}

class _WorkerIdDecorationState extends State<WorkerIdDecoration> {
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
            .doc(widget.khataNumber.toString());
         usersRef.delete();
        usersRef.collection("balance").doc("balance").delete();
        usersRef.collection("dailyData").get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs){
            usersRef.collection("dailyData").doc(ds.id).collection("transactions").get().then((snapshot) {
              for (DocumentSnapshot ds in snapshot.docs){
                ds.reference.delete();
              };
            });
            ds.reference.delete();
          };
        });
        usersRef.collection("transactions").get().then((snapshot) {
          for (DocumentSnapshot ds in snapshot.docs){
            ds.reference.delete();
          };
        });
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DataHomePage(khataNumber:widget.khataNumber),
            ));
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("https://media.istockphoto.com/photos/purple-abstract-background-picture-id1265139669?b=1&k=20&m=1265139669&s=170667a&w=0&h=e8ZdL5cBRj1Tk6fiYcAHJin78_bbFGuUX3f9t_eYdjQ="),
            fit: BoxFit.cover,
          ),
          color: Colors.white,
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
                leading: Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 40,
                ),
                title: Text(
                  widget.name,
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
                trailing: Text(
                  "Khata: ${widget.khataNumber.toString()}",
                  style: TextStyle(color: Colors.black, fontSize: 18),
                ),
                subtitle: Text(
                  "Address: ${widget.address}",
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
            Container(
              child:
              Row(

                children: [
                  SizedBox(width: 20,),
                  InkWell(
                    splashColor: Colors.indigo,
                    onTap: ()async{
                      await showAlertDialog(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      color: Colors.green,
                      child: Row(
                        children: [
                          Text('Delete Khata'),
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: Colors.black,
                    size: 20,
                  ),
                  SizedBox(width: 20,),
                ],
              ),
            ),
            SizedBox(height: 10,),
          ],
        ),
      ),
    );
  }
}
