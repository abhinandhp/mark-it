import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/firebase/friendserivces.dart';

class FriendReqPage extends StatefulWidget {
  const FriendReqPage({super.key});

  @override
  State<FriendReqPage> createState() => _FriendReqPageState();
}

class _FriendReqPageState extends State<FriendReqPage> {
  final _friendservice = FriendSerivces();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Friend requests",
            style: GoogleFonts.outfit(
                color: pricol,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                letterSpacing: 1)),
      ),
      backgroundColor: bgcol,
      body: StreamBuilder(
        stream: _friendservice.frndreqstream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeBounce(
              size: 25,
              color: pricol,
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Text("No friend requests\n    at the moment",
                    style: GoogleFonts.outfit(
                        color: pricol,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: 1)));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Text("No data");
          }
          final docs = snapshot.data ?? [];
          if(docs.isEmpty){
            return Center(
                child: Text("No friend requests\n    at the moment",
                    style: GoogleFonts.outfit(
                        color: pricol,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        letterSpacing: 1)));
          }
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index];

              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12), color: pricol),
                margin: const EdgeInsets.only(left: 12, right: 12, top: 12),
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(data['username'],
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: tercol,
                              letterSpacing: 2),
                        )),
                    const Spacer(),
                    GestureDetector(
                      onTap: () async {
                        await _friendservice.acceptFriendRequest(data['uid']);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: bgcol,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('Accept',
                            style: GoogleFonts.quicksand(
                              textStyle: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: pricol,
                              ),
                            )),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
