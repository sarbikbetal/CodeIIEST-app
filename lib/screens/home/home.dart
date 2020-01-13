import 'package:flutter/material.dart';
import 'package:codeiiest/services/auth.dart';
import 'package:codeiiest/screens/partials/sessionCard.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codeiiest/models/session.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authenticator _auth = Authenticator();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<Session> _mainlist = [];

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
                color: Colors.cyan[800],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Controls /',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  Text(
                    ' CodeIIEST',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xff212121),
            titleSpacing: 24.0,
            pinned: true,
            expandedHeight: 160.0,
            title: Text(
              '</Dashboard>',
              style: TextStyle(fontSize: 36.0, color: Colors.cyan[600]),
              textAlign: TextAlign.start,
            ),
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
                // background: Image.asset(
                //   'assets/images/feed.jpg',
                //   fit: BoxFit.cover,
                // ),
                ),
          ),
          SliverStickyHeader(
            header: Card(
              elevation: 5.0,
              color: Colors.cyan[600],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0))),
              child: Container(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  'Sessions',
                  style: const TextStyle(
                    color: Color.fromRGBO(0, 0, 0, 0.75),
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            sliver: SliverList(
              delegate:
                  SliverChildBuilderDelegate((BuildContext context, int index) {
                return StreamBuilder(
                    stream: Firestore.instance
                        .collection('sessions')
                        .orderBy('date', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                            padding: EdgeInsets.only(top: 120.0),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ));
                      } else {
                        _mainlist.clear();
                        snapshot.data.documents.asMap().forEach((index, doc) {
                          _mainlist.add(Session(
                            id: index,
                            domain: doc['domain'],
                            date: doc['date'],
                            topics: doc['topics'] != null ? doc['topics'] : [],
                            links: doc['links'] != null ? doc['links'] : [],
                          ));
                        });

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ExpansionPanelList.radio(
                            children: _mainlist
                                .map<ExpansionPanelRadio>((Session session) {
                              return sessionCard(session);
                            }).toList(),
                          ),
                        );
                      }
                    });
              }, childCount: 1),
            ),
          ),
        ],
      ),
    );
  }
}
