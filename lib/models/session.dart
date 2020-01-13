import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  Session({
    this.id,
    this.topics,
    this.date,
    this.domain,
    this.links,
  });

  List links;
  Timestamp date;
  int id;
  List topics;
  String domain;
}
