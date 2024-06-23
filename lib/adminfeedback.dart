import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geopawsfinal/admin_messages_view.dart';

class AdminFeedbackPage extends StatefulWidget {
  const AdminFeedbackPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminFeedbackPage createState() => _AdminFeedbackPage();
}

class _AdminFeedbackPage extends State<AdminFeedbackPage> {
  @override
  Widget build(BuildContext context) {
    var user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 63, 157),
        title: const Row(
          children: [
            Text(
              'Feedback',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
        leading: null,
      ),
      body: Container(
          color: Colors.white,
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('feedback')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data == null) {
                      return const Center(child: Text('No data available'));
                    }
                    final alldata = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: alldata.length,
                      itemBuilder: (context, index) {
                        final data = alldata[index];

                        return Column(
                          children: [
                            GestureDetector(
                              child: Container(
                                  padding: const EdgeInsets.all(7),
                                  margin: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 194, 218, 255),
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(
                                    children: [
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          '${data['firstname']} ${data['lastname']}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                      Container(
                                        alignment: Alignment.bottomLeft,
                                        padding: const EdgeInsets.all(5),
                                        child: Text(
                                          '${data['feedback']}',
                                        ),
                                      ),
                                    ],
                                  )),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => AdminMessageViewPage(
                                          senderUid: user!.uid,
                                          receiverUid: data['uid'],
                                        ))),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
