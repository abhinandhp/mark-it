import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/firebase/friendserivces.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _friendservice = FriendSerivces();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text("All Users",
            style: GoogleFonts.outfit(
                color: pricol,
                fontWeight: FontWeight.w700,
                fontSize: 30,
                letterSpacing: 1)),
      ),
      backgroundColor: bgcol,
      body: StreamBuilder(
        stream: _friendservice.getallusersexpcurr(),
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
                        await _friendservice.sendFriendRequest(data);
                        if (mounted) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Sent"),
                          ));
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 12),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                            color: bgcol,
                            borderRadius: BorderRadius.circular(8)),
                        child: Text('ADD',
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
