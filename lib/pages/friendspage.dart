import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/firebase/friendserivces.dart';
import 'package:mark_it/pages/visitfrndpage.dart';

class FriendsPage extends StatefulWidget {
  const FriendsPage({super.key});

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  final _friendservice = FriendSerivces();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("Friends",
            style: GoogleFonts.outfit(
                color: pricol,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                letterSpacing: 1)),
      ),
      backgroundColor: bgcol,
      body: StreamBuilder(
        stream: _friendservice.friendsstream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SpinKitThreeBounce(
              size: 25,
              color: pricol,
            );
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading data"));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Text("No data");
          }
          final docs = snapshot.data ?? [];
          if(docs.isEmpty){
            return Center(
                child: Text("You have no friend\n    at the moment",
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return VisitFriend(friendId: data['uid'],);
                        },));
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: bgcol,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('Visit',
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
