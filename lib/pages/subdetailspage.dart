import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/firebase/dbservices.dart';
import 'package:mark_it/widgets/mytextfield.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:google_fonts/google_fonts.dart';

class Subdetailspage extends StatefulWidget {
  final String docID;
  const Subdetailspage({super.key, required this.docID});

  @override
  State<Subdetailspage> createState() => _SubdetailspageState();
}

class _SubdetailspageState extends State<Subdetailspage> {
  final FireDb _fireDb = FireDb();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _targetcontroller = TextEditingController();

  final TextEditingController _subcontroller = TextEditingController();
  final TextEditingController _attcontroller = TextEditingController();
  final TextEditingController _totcontroller = TextEditingController();
  final TextEditingController _ctncontroller = TextEditingController();

  void clearcontrollers() {
    _attcontroller.clear();
    _totcontroller.clear();
    _subcontroller.clear();
    _ctncontroller.clear();
  }

  Future<void> update(String id) async {
    if (_subcontroller.text.trim() != "" &&
        _attcontroller.text.trim() != "" &&
        _totcontroller.text.trim() != "" &&
        _ctncontroller.text.trim() != "") {
      await _fireDb.updatesub(id, {
        'name': _subcontroller.text.trim(),
        'attend': _attcontroller.text.trim(),
        'tot': _totcontroller.text.trim(),
        'clstilnow': _ctncontroller.text.trim()
      });
      if (mounted) {
        Navigator.pop(context);
      }
      clearcontrollers();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Fill all fields"),
      ));
    }
  }

  void scrolldown() {
    _scrollController.animateTo(
      //_scrollController.position.maxScrollExtent,
      _scrollController.offset + 300,
      duration: const Duration(seconds: 1),
      curve: Curves.easeInOut,
    );
  }

  void present(DocumentSnapshot<Map<String, dynamic>> datamap) async {
    int att = int.parse(datamap['attend']);
    att++;
    int ctn = int.parse(datamap['clstilnow']);
    ctn++;
    Map<String, dynamic> map = {
      'name': datamap['name'],
      'attend': att.toString(),
      'tot': datamap['tot'],
      'clstilnow': ctn.toString()
    };
    await _fireDb.updateDoc('subjects', widget.docID, map);
  }

  String res = " Enter the target percentage \n       you want to achieve";
  void noOfLeaves(String perstring, int tot, int leaves) {
    double? perc = double.tryParse(perstring);
    if (perc == null) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text('Enter a valid percentage!!'),
        ),
      );
      return;
    }
    double? rem = 100.0 - perc;
    int possibleLeav = (rem * tot / 100).floor();
    int remLeav = possibleLeav - leaves;
    if (remLeav > 0) {
      res = "You can take $remLeav more leaves";
    } else if (remLeav == 0) {
      res = "You have NO more leaves left";
    } else {
      res = "You already took ${-remLeav} extra leaves";
    }
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _targetcontroller.dispose();
    super.dispose();
  }

  void absent(DocumentSnapshot<Map<String, dynamic>> datamap) async {
    int ctn = int.parse(datamap['clstilnow']);
    ctn++;
    Map<String, dynamic> map = {
      'name': datamap['name'],
      'attend': datamap['attend'],
      'tot': datamap['tot'],
      'clstilnow': ctn.toString()
    };
    await _fireDb.updateDoc('subjects', widget.docID, map);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: bgcol,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(_fireDb.getCurrentUser()!.uid)
                .collection('subjects')
                .doc(widget.docID)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              final map = snapshot.data;

              _attcontroller.text = map!['attend'];
              _ctncontroller.text = map['clstilnow'];
              _totcontroller.text = map['tot'];
              _subcontroller.text = map['name'];

              final att = int.parse(map['attend']);
              final ctn = int.parse(map['clstilnow']);
              final tot = int.parse(map['tot']);
              final currperc = ((att / ctn) * 1000).round();
              final expperc = ((att / tot) * 1000).round();
              Future.delayed(const Duration(seconds: 1), () {
                scrolldown();
              });
              return Stack(
                children: [
                  SingleChildScrollView(
                    controller: _scrollController,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Center(
                            child: Text(
                              map['name'],
                              style: GoogleFonts.outfit(
                                  color: pricol,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 26,
                                  letterSpacing: 1),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Current attendance: ${map['attend']}",
                            style: GoogleFonts.outfit(
                                color: pricol,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                          Text(
                            "Completed classes: ${map['clstilnow']}",
                            style: GoogleFonts.outfit(
                                color: pricol,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                          Text(
                            "Expected no of classes: ${map['tot']}",
                            style: GoogleFonts.outfit(
                                color: pricol,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  "Current percentage",
                                  style: GoogleFonts.outfit(
                                      color: pricol,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      letterSpacing: 1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 80),
                                  child: CircularPercentIndicator(
                                    radius: 65,
                                    animation: true,
                                    animationDuration: 800,
                                    lineWidth: 10,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: seccol,
                                    percent: currperc / 1000,
                                    center: Text(
                                        "${(currperc / 10).toString()}%",
                                        style: GoogleFonts.outfit(
                                            color: pricol,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 1)),
                                    backgroundColor: bgcol,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  "Attendance progress\n   (out of ${map['tot']} classes)",
                                  style: GoogleFonts.outfit(
                                      color: pricol,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      letterSpacing: 1),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 18.0, horizontal: 80),
                                  child: CircularPercentIndicator(
                                    radius: 65,
                                    animation: true,
                                    animationDuration: 800,
                                    lineWidth: 10,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: seccol,
                                    percent: expperc / 1000,
                                    center: Text(
                                        "${(expperc / 10).toString()}%",
                                        style: GoogleFonts.outfit(
                                            color: pricol,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 20,
                                            letterSpacing: 1)),
                                    backgroundColor: bgcol,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 55, vertical: 13),
                            child: Text(
                              "No of leaves taken:  ${ctn - att}",
                              style: GoogleFonts.outfit(
                                  color: pricol,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                  letterSpacing: 1),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.all(15),
                            child: Column(
                              children: [
                                Text(
                                  "Target %",
                                  style: GoogleFonts.outfit(
                                      color: pricol,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      letterSpacing: 1),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    MyTextField(
                                      wid: 60,
                                      controller: _targetcontroller,
                                      title: "",
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        noOfLeaves(
                                            _targetcontroller.text.trim(),
                                            tot,
                                            ctn - att);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                            color: pricol,
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: const Icon(
                                          Icons.check,
                                          size: 33,
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                Text(
                                  res,
                                  style: GoogleFonts.outfit(
                                      color: pricol,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      letterSpacing: 1),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 250,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 50,
                    left: 1,
                    right: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            absent(map);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width * .2,
                            padding: const EdgeInsets.all(19),
                            decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(28)),
                            child: const Column(
                              children: [
                                Icon(Icons.minimize_rounded),
                                Text('Absent')
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            present(map);
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.width * .2,
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
                  ),
                  Positioned(
                    right: 0,
                    child: PopupMenuButton(
                      color: tercol,
                      iconSize: 35,
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 0,
                          child: Text(
                            "Edit",
                            style: GoogleFonts.outfit(
                                color: pricol,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                        ),
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Delete",
                            style: GoogleFonts.outfit(
                                color: pricol,
                                fontWeight: FontWeight.w500,
                                fontSize: 20,
                                letterSpacing: 1),
                          ),
                        )
                      ],
                      onSelected: (value) {
                        if (value == 0) {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: SingleChildScrollView(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          MyTextField(
                                            controller: _subcontroller,
                                            title: "Subject",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          MyTextField(
                                            controller: _attcontroller,
                                            title: "Current attendance",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          MyTextField(
                                            controller: _ctncontroller,
                                            title: "Classes completed till now",
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          MyTextField(
                                            controller: _totcontroller,
                                            title: "Total no of classes",
                                          ),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.end,
                                    actionsPadding: const EdgeInsets.all(25),
                                    scrollable: true,
                                    actions: [
                                      GestureDetector(
                                        onTap: clearcontrollers,
                                        child: Container(
                                          margin:
                                              const EdgeInsets.only(right: 10),
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.redAccent,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            "Clear",
                                            style: GoogleFonts.outfit(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1)),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          update(widget.docID);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: pricol,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            "ADD",
                                            style: GoogleFonts.outfit(
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1)),
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(
                                "Confirm",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        color: pricol,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1)),
                              ),
                              content: Text(
                                "Do you want to delete this subject?",
                                style: GoogleFonts.outfit(
                                    textStyle: const TextStyle(
                                        color: pricol,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1)),
                              ),
                              actionsAlignment: MainAxisAlignment.end,
                              actionsPadding: const EdgeInsets.all(25),
                              actions: [
                                GestureDetector(
                                  onTap: (){
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "Cancel",
                                      style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1)),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () async{
                                    
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    await Future.delayed(const Duration(milliseconds: 900));
                                    _fireDb.deletesub(widget.docID);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: pricol,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Text(
                                      "Delete",
                                      style: GoogleFonts.outfit(
                                          textStyle: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              letterSpacing: 1)),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
