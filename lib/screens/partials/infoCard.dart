import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
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
    widget.snap.forEach((doc) {
      _mainlist.add(Item(
        headerValue: doc['domain'],
        expandedValue: doc['date'].toString(),
      ));
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _mainlist[index].isExpanded = !isExpanded;
        });
      },
      children: _mainlist.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text(item.headerValue),
            );
          },
          body: ListTile(
              title: Text(item.expandedValue),
              subtitle: Text('To delete this panel, tap the trash can icon'),
              trailing: Icon(Icons.delete),
              onTap: () {
                setState(() {
                  _mainlist.removeWhere((currentItem) => item == currentItem);
                });
              }),
          isExpanded: item.isExpanded,
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
