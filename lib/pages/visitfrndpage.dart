import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/firebase/dbservices.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class VisitFriend extends StatefulWidget {
  final String friendId;
  const VisitFriend({super.key,required this.friendId});

  @override
  State<VisitFriend> createState() => _VisitFriendState();
}

class _VisitFriendState extends State<VisitFriend> {
  final _fireDb = FireDb();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcol,
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder(
                        future: _fireDb.getUserDetails(widget.friendId),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SpinKitThreeBounce(
                              size: 25,
                              color: pricol,
                            );
                          }
        
                          var data = snapshot.data;
                          return Text(data!['username'],
                              style: GoogleFonts.quicksand(
                                textStyle: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  color: pricol,
                                ),
                              ));
                        },
                      ),
            Expanded(
              child: StreamBuilder(
                stream: _fireDb.getsubs(widget.friendId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SpinKitThreeBounce(
                      size: 25,
                      color: pricol,
                    );
                  }
                  if (snapshot.hasError) {
                    return const Text("Error loading data");
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const Text("No data");
                  }
                  final docs = snapshot.data!.docs;
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: docs.length,
                    itemBuilder: (context, index) {
                      final data = docs[index];
                      var att = int.parse(data['attend']);
                      var tot = int.parse(data['tot']);
                      var perc = ((att / tot) * 1000).roundToDouble();
                      perc = perc / 10;
                      return GestureDetector(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => Subdetailspage(
                          //       docID: data.id,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: tercol, borderRadius: BorderRadius.circular(28)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                data['name'].toString(),
                                style: GoogleFonts.outfit(
                                    color: pricol,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 17,
                                    letterSpacing: 1),
                              ),
                              CircularPercentIndicator(
                                radius: 45,
                                animation: true,
                                animationDuration: 800,
                                lineWidth: 10,
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: pricol,
                                percent: perc / 100,
                                center: Text(
                                  "${perc.toString()}%",
                                  style: GoogleFonts.outfit(
                                      color: pricol,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 17,
                                      letterSpacing: 1),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(224, 255, 255, 255),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
