import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttersimplecalculator/main.dart';

class HistoryList extends StatefulWidget {
  @override
  _HistoryListState createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {

  deleteHistory(item){
    DocumentReference documentReference = Firestore.instance.collection("MyHistory").document(item);

    documentReference.delete().whenComplete((){
      print("$item Deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("My History"),
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder(
        stream: Firestore.instance.collection("MyHistory").snapshots(),
        builder: (context, snapshots){
          return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(0, 100.0, 0, 0),
              itemCount: snapshots.data.documents.length,
              itemBuilder: (context, index){
                DocumentSnapshot documentSnapshot = snapshots.data.documents[index];
                return Dismissible(
                    onDismissed: (direction) {
                      deleteHistory(documentSnapshot["historyTitle"]);
                    },
                    key: Key(documentSnapshot["historyTitle"]),
                    child: Card(
                      elevation: 4,
                      color: Colors.black,
                      margin: EdgeInsets.fromLTRB(20, 8, 20, 8),
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: Colors.white
                        ),
                      ),
                      child: ListTile(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SimpleCalculator(documentSnapshot["historyTitle"])
                            ));
                        },
                        title: Text(
                          documentSnapshot["historyTitle"] + " = " + documentSnapshot["historyResult"],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.normal,
                            color: Colors.white
                          ),
                        ),
                      ),
                    )
                );
              }
          );
        },
      )
    );
  }
}
