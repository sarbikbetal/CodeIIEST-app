import 'package:cloud_firestore/cloud_firestore.dart';

class Session {
  Session({
    this.id,
    this.topics,
    this.date,
    this.domain,
    this.links,
    this.code,
  });

  List links;
  int code;
  Timestamp date;
  int id;
  List topics;
  String domain;
}
