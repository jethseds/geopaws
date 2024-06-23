import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/adminbottom.dart';
import 'package:geopawsfinal/adminpetprofile.dart';
import 'package:geopawsfinal/formpet.dart';

void main() {
  runApp(const AdminPetPage());
}

// ignore: camel_case_types
class AdminPetPage extends StatefulWidget {
  const AdminPetPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminPetPage createState() => _AdminPetPage();
}

// ignore: camel_case_types
class _AdminPetPage extends State<AdminPetPage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ScaffoldMessenger(
        key: _globalKey,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 63, 157),
            title: Row(
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_left,
                    size: 40,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminBottomPage(),
                        ));
                  },
                ),
                const Text(
                  'Pet',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AdminFormPetPage(),
                          ),
                        );
                      },
                      child: const FaIcon(
                        FontAwesomeIcons.plusSquare,
                        color: Color.fromARGB(255, 0, 63, 157),
                        size: 50,
                      ),
                    ),
                    const Text(
                      'ADD PET',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 63, 157),
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 20),
                  child: const Text(
                    'Pet for Adoption',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('pet')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData || snapshot.data == null) {
                        return const Center(
                          child: Text('No data available'),
                        );
                      }
                      final alldata = snapshot.data!.docs;

                      if (alldata.isEmpty) {
                        return const Center(
                          child: Text('No pets available for adoption'),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap:
                            true, // Important to use shrinkWrap inside a ListView
                        physics:
                            NeverScrollableScrollPhysics(), // Disable scrolling to avoid conflicts
                        itemCount: alldata.length,
                        itemBuilder: (context, index) {
                          final data = alldata[index];
                          // Access your fields from Firestore document
                          final type = data['type'] ?? 'Unnamed';
                          final breed = data['breed'] ?? 'Unnamed';

                          final docId = data.id; // Access the document ID here
                          // Assuming you have an image field in Firestore

                          return Container(
                            margin: const EdgeInsets.only(top: 8),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 239, 239, 239),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(55),
                                    ),
                                    child: ClipOval(
                                      child: Image.network(
                                        data['images'],
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit
                                            .cover, // This ensures the image covers the circular area
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset('assets/p1.png',
                                              width: 60, height: 60);
                                        },
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            type,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          Text(
                                            breed,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10.0),
                                  GestureDetector(
                                      child: Container(
                                        padding: const EdgeInsets.all(5),
                                        child: const FaIcon(
                                          FontAwesomeIcons.chevronCircleRight,
                                          color:
                                              Color.fromARGB(255, 0, 63, 157),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    AdminPetProfilePage(
                                                        docId: docId))));
                                      }),
                                  GestureDetector(
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      child: const FaIcon(
                                        FontAwesomeIcons.trash,
                                        color: Colors.red,
                                      ),
                                    ),
                                    onTap: () {
                                      FirebaseFirestore.instance
                                          .collection('pet')
                                          .doc(docId)
                                          .delete()
                                          .then((value) {
                                        var snackBar = const SnackBar(
                                            backgroundColor: Colors.green,
                                            content:
                                                Text('Success Delete Data'));
                                        _globalKey.currentState
                                            ?.showSnackBar(snackBar);
                                      });
                                    },
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
        ),
      ),
    );
  }
}
