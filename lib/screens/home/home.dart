import 'package:flutter/material.dart';
import 'package:codeiiest/services/auth.dart';
// import 'package:codeiiest/screens/partials/infoCard.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';

class Events {
  Events({
    this.id,
    this.expandedValue,
    this.date,
    this.domain,
  });

  Timestamp date;
  int id;
  List expandedValue;
  String domain;
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Authenticator _auth = Authenticator();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  List<Events> _mainlist = [];

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
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Color(0xff212121),
            titleSpacing: 24.0,
            pinned: true,
            expandedHeight: 160.0,
            title: Text(
              'Dashboard',
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
                    stream:
                        Firestore.instance.collection('sessions').snapshots(),
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
                          _mainlist.add(Events(
                            id: index,
                            domain: doc['domain'],
                            date: doc['date'],
                            expandedValue: doc['topics'],
                          ));
                        });

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: ExpansionPanelList.radio(
                            initialOpenPanelValue: 0,
                            children: _mainlist
                                .map<ExpansionPanelRadio>((Events event) {
                              return ExpansionPanelRadio(
                                canTapOnHeader: true,
                                value: event.hashCode,
                                headerBuilder:
                                    (BuildContext context, bool isExpanded) {
                                  return Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(event.domain),
                                        Text(formatDate(event.date.toDate(),
                                            [dd, ' ', M, ' \'', yy])),
                                      ],
                                    ),
                                  );
                                },
                                body: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 8.0),
                                  alignment: Alignment.centerLeft,
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    spacing: 8.0,
                                    children: event.expandedValue
                                        .map((topic) => Chip(
                                              label: Text(topic),
                                            ))
                                        .toList(),
                                  ),
                                ),
                              );
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
