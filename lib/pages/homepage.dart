import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mark_it/constants.dart';
import 'package:mark_it/pages/subdetailspage.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/material.dart';
import 'package:mark_it/firebase/dbservices.dart';
import 'package:mark_it/widgets/mytextfield.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _fireDb = FireDb();

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

  Future<void> onTap() async {
    if (_subcontroller.text.trim() != "" &&
        _attcontroller.text.trim() != "" &&
        _totcontroller.text.trim() != "" &&
        _ctncontroller.text.trim() != "") {
      await _fireDb.addsub({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgcol,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          color: bgcol.withOpacity(0),
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15.0, horizontal: 12),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.all(16),
                      child: const Icon(
                        Icons.person_3_sharp,
                        color: pricol,
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Text('Username',
                        style: GoogleFonts.quicksand(
                          textStyle: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: pricol,
                          ),
                        )),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Icon(Icons.notifications_outlined,
                          color: pricol),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _fireDb.getsubs(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return const Text("Error loading data");
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Text("No data");
                    }
                    final docs = snapshot.data!.docs;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Subdetailspage(
                                  docID: data.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                color: tercol,
                                borderRadius: BorderRadius.circular(28)),
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
              Center(
                child: GestureDetector(
                    onTap: () {
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
                                      margin: const EdgeInsets.only(right: 10),
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
                                    onTap: onTap,
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
                    },
                    child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                            color: pricol,
                            borderRadius: BorderRadius.circular(40)),
                        child: const Icon(
                          Icons.add,
                          size: 40,
                          color: Colors.white,
                        ))),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
