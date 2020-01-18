import 'package:flutter/material.dart';
import 'package:codeiiest/screens/partials/sessionCard.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:codeiiest/models/session.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<Session> _mainlist = [];

  Map<String, bool> _subs = {
    "cp": true,
    "web": true,
    "ml": true,
    "security": true,
  };

  initSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _subs['cp'] = prefs.getBool('cp') ?? true;
    _subs['web'] = prefs.getBool('web') ?? true;
    _subs['ml'] = prefs.getBool('ml') ?? true;
    _subs['security'] = prefs.getBool('security') ?? true;
    this.setState(() {});
  }

  @override
  void initState() {
    super.initState();
    // Shared preferences
    initSharedPrefs();
    // Firebase Cloud Messaging Init
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
              leading: Icon(Icons.notifications_active),
              title: Text('Notifications'),
            ),
            CheckboxListTile(
              value: this._subs['cp'],
              title: Padding(
                padding: const EdgeInsets.only(left: 64.0),
                child: const Text(
                  'Competitive Programming',
                  style: TextStyle(color: Color(0x99000000)),
                ),
              ),
              onChanged: (bool value) async {
                value
                    ? _fcm.subscribeToTopic('CP')
                    : _fcm.unsubscribeFromTopic('CP');
                this.setState(() {
                  this._subs['cp'] = !this._subs['cp'];
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('cp', this._subs['cp']);
              },
            ),
            CheckboxListTile(
              value: this._subs['web'],
              title: Padding(
                padding: const EdgeInsets.only(left: 64.0),
                child: const Text(
                  'Web and Open-Source',
                  style: TextStyle(color: Color(0x99000000)),
                ),
              ),
              onChanged: (bool value) async {
                value
                    ? _fcm.subscribeToTopic('web')
                    : _fcm.unsubscribeFromTopic('web');
                this.setState(() {
                  this._subs['web'] = !this._subs['web'];
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('web', this._subs['web']);
              },
            ),
            CheckboxListTile(
              value: this._subs['ml'],
              title: Padding(
                padding: const EdgeInsets.only(left: 64.0),
                child: const Text(
                  'Machine Learning',
                  style: TextStyle(color: Color(0x99000000)),
                ),
              ),
              onChanged: (bool value) async {
                value
                    ? _fcm.subscribeToTopic('ML')
                    : _fcm.unsubscribeFromTopic('ML');
                this.setState(() {
                  this._subs['ml'] = !this._subs['ml'];
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('ml', this._subs['ml']);
              },
            ),
            CheckboxListTile(
              value: this._subs['security'],
              title: Padding(
                padding: const EdgeInsets.only(left: 64.0),
                child: const Text(
                  'Hacking & Security',
                  style: TextStyle(color: Color(0x99000000)),
                ),
              ),
              onChanged: (bool value) async {
                value
                    ? _fcm.subscribeToTopic('security')
                    : _fcm.unsubscribeFromTopic('security');
                this.setState(() {
                  this._subs['security'] = !this._subs['security'];
                });
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('security', this._subs['security']);
              },
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
                              topics:
                                  doc['topics'] != null ? doc['topics'] : [],
                              links: doc['links'] != null ? doc['links'] : [],
                              code: doc['code'] != null ? doc['code'] : 0));
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
