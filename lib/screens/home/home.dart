import 'package:codeiiest/services/auth.dart';
import 'package:codeiiest/screens/partials/infoCard.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authenticator _auth = Authenticator();
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: ListTile(
              title: Text(message['notification']['title']),
              subtitle: Text(message['notification']['body']),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Ok'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        // TODO optional
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.message),
                title: Text('Messages'),
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text('Logout'),
                onTap: () async {
                  await _auth.signOut();
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
            ],
          ),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection('sessions').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Text("Loading..");
            }
            return SingleChildScrollView(
              child: Container(
                child: InfoCard(
                  snap: snapshot.data.documents,
                ),
              ),
            );
            // return ListView.builder(
            //   itemExtent: 80.0,
            //   itemCount: snapshot.data.documents.length,
            //   itemBuilder: (context, index) => InfoCard(
            //     doc: snapshot.data.documents[index],
            //   ),
            // );
          },
        ));
  }
}

// return Container(
//   child: Row(
//     children: <Widget>[
//       FlatButton(
//           child: Text('I like web'),
//           onPressed: () => _fcm.subscribeToTopic('web')),
//       FlatButton(
//           child: Text('I hate web'),
//           onPressed: () => _fcm.unsubscribeFromTopic('web')),
//     ],
//   ),
// );

// CustomScrollView(
//         slivers: <Widget>[
//           SliverAppBar(
//             backgroundColor: Color(0xff212121),
//             titleSpacing: 24.0,
//             pinned: true,
//             expandedHeight: 160.0,
//             title: Text(
//               'Feed',
//               style: TextStyle(fontSize: 36.0, color: Colors.cyan[600]),
//             ),
//             floating: true,
//             flexibleSpace: FlexibleSpaceBar(
//                 // background: Image.asset(
//                 //   'assets/images/feed.jpg',
//                 //   fit: BoxFit.cover,
//                 // ),
//                 ),
//           ),
//           StreamBuilder(
//             stream: Firestore.instance.collection('sessions').snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.data) {
//                 return SliverList(
//                   delegate: SliverChildListDelegate([Text("Loading..")]),
//                 );
//               }
//               return SliverList(
//                 delegate: SliverChildBuilderDelegate(
//                   (context, int index) {
//                     return InfoCard(
//                       doc: snapshot.data.documents[index],
//                     );
//                   },
//                 ),
//               );
//             },
//           )
//         ],
//       ),
