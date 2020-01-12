import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';

class Item {
  Item({
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

List<Item> _mainlist = [];

class InfoCard extends StatefulWidget {
  final List<DocumentSnapshot> snap;
  InfoCard({this.snap});

  @override
  _InfoCardState createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  void initState() {
    widget.snap.asMap().forEach((index, doc) {
      _mainlist.add(Item(
        id: index,
        domain: doc['domain'],
        date: doc['date'],
        expandedValue: doc['topics'],
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList.radio(
      initialOpenPanelValue: 0,
      children: _mainlist.map<ExpansionPanelRadio>((Item item) {
        return ExpansionPanelRadio(
          canTapOnHeader: true,
          value: item.hashCode,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(item.domain),
                  Text(formatDate(item.date.toDate(), [dd, ' ', M, ' \'', yy])),
                ],
              ),
            );
          },
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              spacing: 8.0,
              children: item.expandedValue
                  .map((topic) => Chip(
                        label: Text(topic),
                      ))
                  .toList(),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// Padding(
//       padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 16.0),
//       child: Card(
//         clipBehavior: Clip.hardEdge,
//         shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(Radius.circular(8.0))),
//         elevation: 2.0,
//         child: InkWell(
//           onTap: () {
//             setState(() {
//               _expanded = !_expanded;
//             });
//           },
//           child: AnimatedSize(
//             vsync: this,
//             duration: Duration(milliseconds: 400),
//             curve: Curves.easeInCubic,
//             child: Padding(
//               padding: EdgeInsets.all(18.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Text(
//                     widget.doc['domain'],
//                     style: TextStyle(
//                       color: Colors.black87,
//                       fontSize: 20.0,
//                       height: 1.2,
//                     ),
//                   ),
//                   Text(
//                     widget.doc['date'].toString(),
//                     style: TextStyle(
//                       color: Colors.grey[700],
//                       height: 1.6,
//                     ),
//                   ),
//                   _expanded
//                       ? Text(
//                           'Conditions',
//                           style: TextStyle(
//                               fontSize: 18.0,
//                               color: Colors.grey[700],
//                               fontWeight: FontWeight.w600,
//                               height: 2.0),
//                         )
//                       : SizedBox(),
//                   _expanded
//                       ? Text(
//                           'Topics: ' + "dummy",
//                           style:
//                               TextStyle(color: Colors.grey[600], height: 1.2),
//                         )
//                       : SizedBox(),
//                   _expanded
//                       ? Text(
//                           'Links: ' + "dummy",
//                           style:
//                               TextStyle(color: Colors.grey[600], height: 1.2),
//                         )
//                       : SizedBox(),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
