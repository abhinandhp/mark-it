import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mark_it/firebase/dbservices.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class Subdetailspage extends StatefulWidget {
  final String docID;
  const Subdetailspage({super.key, required this.docID});

  @override
  State<Subdetailspage> createState() => _SubdetailspageState();
}

class _SubdetailspageState extends State<Subdetailspage> {
  final FireDb _fireDb=FireDb();

  void present(DocumentSnapshot<Map<String,dynamic>> datamap)async{
    int att=int.parse(datamap['attend']);
    att++;
    int ctn=int.parse(datamap['clstilnow']);
    ctn++;
    Map<String,dynamic> map={
      'name':datamap['name'],
      'attend':att.toString(),
      'tot':datamap['tot'],
      'clstilnow':ctn.toString()
    };
    await _fireDb.updateDoc('subjects', widget.docID, map);
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: StreamBuilder<DocumentSnapshot<Map<String,dynamic>>>(
            stream: FirebaseFirestore.instance.collection('subjects').doc(widget.docID).snapshots(),
            builder: (context, snapshot) {
              if(snapshot.connectionState==ConnectionState.waiting){
                return const CircularProgressIndicator();
              }

              final map=snapshot.data;
              final att=int.parse(map!['attend']);
              final ctn=int.parse(map['clstilnow']);
              final tot=int.parse(map['tot']);
              final currperc=((att/ctn)*1000).round();
              final expperc=((att/tot)*1000).round();
              return Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
              children: [
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    map['name'],
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  )),
                ),
                Container(
                  padding:const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      CircularPercentIndicator(
                        radius: 65,
                        animation: true,
                        animationDuration: 800,
                        lineWidth: 10,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.deepPurple,
                        percent: currperc/1000,
                        center: Text("${(currperc/10).toString()}%"),
                        backgroundColor: Colors.deepPurple.shade100,
                      )
                    ],
                  ),
                ),
                Text("ctn: ${map['clstilnow']}"),
                Text(
                    "att: ${map['attend']}",
                    style:
                        const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                   CircularPercentIndicator(
                        radius: 65,
                        animation: true,
                        animationDuration: 800,
                        lineWidth: 10,
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: Colors.deepOrange,
                        percent: expperc/1000,
                        center: Text("${(expperc/10).toString()}%"),
                        backgroundColor: Colors.deepOrange.shade100,
                      ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Container(
                        padding: const EdgeInsets.all(19),
                        decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(28)),
                        child: const Column(
                          children: [Icon(Icons.minimize_rounded), Text('Absent')],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        present(map);
                        setState(() {
                          
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(19),
                        decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            borderRadius: BorderRadius.circular(28)),
                        child: const Column(
                          children: [
                            Icon(Icons.add_circle_outline),
                            Text('Present')
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
                      ),
                    );
            }
          )),
    );
  }
}
