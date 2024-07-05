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
  Future<void> onTap() async {
    await _fireDb.addsub({'name': "Math"});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 238, 253, 224),
      body: SafeArea(
        child: Container(
          color: const Color.fromARGB(255, 238, 253, 224),
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
                      child: const Icon(Icons.person_3_sharp),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    const Text(
                      'UserName',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: const Icon(Icons.notifications_outlined),
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
                    final doc = snapshot.data;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: doc!.length,
                      itemBuilder: (context, index) {
                        final data = doc[index];
                        return Container(
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 239, 248, 248),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(data['name'].toString()),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              backgroundColor: Colors.white,
                              content: const Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  MyTextField(
                                    title: "Subject",
                                  ),
                                  MyTextField(
                                    title: "Current attendance",
                                  ),
                                  MyTextField(title: "Total no of classes")
                                ],
                              ),
                              actionsAlignment: MainAxisAlignment.center,
                              actions: [
                                IconButton(
                                    onPressed: onTap,
                                    icon: const Icon(
                                      Icons.add_circle_outline_sharp,
                                      size: 40,
                                    ))
                              ],
                            ));
                  },
                  child: const Text(
                    "insert",
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
