import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DailyTransactionPage extends StatefulWidget {
  final String createdAt;
  final int amount;
  final int khataNumber;
  final String userId;
  final String docId;
  final int total;
  final String transcdocId;
  const DailyTransactionPage({Key? key,required this.transcdocId,
    required this.khataNumber,required this.userId,required this.docId,
    required this.amount,required this.createdAt,required this.total}) : super(key: key);

  @override
  State<DailyTransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<DailyTransactionPage> {
  String date= "";
  String time= "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String ans = "";
    for(int i=0;i<widget.createdAt.length;i++) {
      if(i==18){
        break;
      }
      ans = ans + widget.createdAt[i];
    }

    for(int i=0;i<ans.length;i++){
      if(ans[i]==" "){
        for(int j=i+1;j<=i+5 && j<ans.length;j++){
          time = time + ans[j];
        }
        break;
      }
      date = date + ans[i];
    }
  }
  @override
  Widget build(BuildContext context) {

    return Card(
      child: ListTile(
        title: Text('Date: ${date}'),
        leading: Icon(Icons.shopping_bag,size: 35,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text('Time: ${time}'),
          ],),
        trailing: Column(
          children: [
            Text("Quantity ${widget.amount}",style: TextStyle(fontWeight: FontWeight.bold),),
            SizedBox(height: MediaQuery.of(context).size.height*.02,),
            InkWell(
                onTap: ()async{
                  print(widget.total);
                  print(widget.amount);
                  final usersRef =  FirebaseFirestore.instance
                      .collection("khataCheck")
                      .doc(widget.userId)
                      .collection("workersData")
                      .doc(widget.khataNumber.toString()).collection("dailyData").doc(widget.docId);
                  await usersRef.update({'ayian': widget.total-widget.amount});
                  final transcusersRef =  FirebaseFirestore.instance
                      .collection("khataCheck")
                      .doc(widget.userId)
                      .collection("workersData")
                      .doc(widget.khataNumber.toString()).collection("dailyData").doc(widget.docId).collection("transactions").doc(widget.transcdocId);
                  await transcusersRef.delete();
                },
                child: Icon(Icons.delete,size: 24,color: Colors.red,)),
          ],
        ),
      ),
    );
  }
}
