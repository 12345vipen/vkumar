import 'package:flutter/material.dart';

class TransactionPage extends StatefulWidget {
  final String createdAt;
  final int amount;
  const TransactionPage({Key? key,required this.amount,required this.createdAt}) : super(key: key);

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
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
        leading: Icon(Icons.monetization_on_sharp,size: 35,),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            Text('Time: ${time}'),
        ],),
        trailing: Text("Rs ${widget.amount}"),
      ),
    );
  }
}
