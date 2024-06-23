import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/bottom.dart';
import 'package:geopawsfinal/login.dart';
import 'package:geopawsfinal/pet2.dart';

// ignore: camel_case_types
class PetProfilePage extends StatefulWidget {
  final docId;
  const PetProfilePage({super.key, required this.docId});

  @override
  // ignore: library_private_types_in_public_api
  _PetProfilePage createState() => _PetProfilePage();
}

// ignore: camel_case_types
class _PetProfilePage extends State<PetProfilePage> {
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  String type = "";
  String breed = "";
  String age = "";
  String color = "";
  String arrivaldate = "";
  String sizeweight = "";
  String sex = "";
  String images = "";

  String email = "";

  @override
  void initState() {
    super.initState();
    // Fetch data based on the provided UID when the widget initializes
    fetchData();
    userfetchData();
  }

  Future<void> fetchData() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('pet')
          .doc(widget
              .docId) // Replace 'your_document_id' with the actual document ID
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          type = userData['type'] ?? '';
          breed = userData['breed'] ?? '';
          age = userData['age'] ?? '';
          color = userData['color'] ?? '';
          arrivaldate = userData['arrivaldate'] ?? '';
          sizeweight = userData['sizeweight'] ?? '';
          sex = userData['sex'] ?? '';
          images = userData['images'] ?? '';
        });
      } else {
        // Document does not exist
        print('Document does not exist');
      }
    } catch (e) {
      // Error handling for document fetch or data extraction
      print('Error fetching document: $e');
    }
  }

  String fullname = "";

  Future<void> userfetchData() async {
    final user = FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();

      if (documentSnapshot.exists) {
        var userData = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          String firstname = userData['firstname'] ?? '';
          String lastname = userData['lastname'] ?? '';
          fullname = '$firstname $lastname';
        });
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
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
                          builder: (context) => const PetPage(),
                        ));
                  },
                ),
                const Text(
                  'Pet Profile',
                  style: TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
          body: ListView(
            children: [
              Container(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                      child: Column(
                        children: [
                          Image.network(
                            images,
                            height: 300,
                            fit: BoxFit.cover,
                          ),
                          const Text(
                            'Image',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text(
                                'Type: ${type}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Breed: ${breed}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Age: ${age}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Color: ${color}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Arrival Date: ${arrivaldate}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Size Weight: ${sizeweight}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 30),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 0, 63, 157),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Text('Sex: ${sex}',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(margin: const EdgeInsets.only(bottom: 20)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 50),
                padding: const EdgeInsets.symmetric(horizontal: 90),
                child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xdd2e3131),
                        borderRadius: BorderRadius.circular(40)),
                    child: TextButton(
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('request')
                              .where('uid', isEqualTo: user!.uid)
                              .where('status', isEqualTo: 'Pending')
                              .get()
                              .then((QuerySnapshot querySnapshot) {
                            if (querySnapshot.docs.isEmpty) {
                              // No pending request exists, create a new request
                              FirebaseFirestore.instance
                                  .collection('request')
                                  .add({
                                'petId': widget.docId,
                                'uid': user!.uid,
                                'fullname': fullname,
                                'status': 'Pending'
                              });

                              var snackBar = const SnackBar(
                                  backgroundColor: Colors.green,
                                  content: Text(
                                      'Success Request Adopt Waiting for approval'));
                              _globalKey.currentState?.showSnackBar(snackBar);
                            } else {
                              var snackBar = const SnackBar(
                                  content: Text('Already Request'));
                              _globalKey.currentState?.showSnackBar(snackBar);
                            }
                          }).catchError((error) {
                            print("Error getting documents: $error");
                          });
                        },
                        child: const Text(
                          'Request Adopt',
                          style: TextStyle(
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                              color: Colors.white),
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
