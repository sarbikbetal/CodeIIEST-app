import 'package:codeiiest/models/session.dart';
import 'package:flutter/material.dart';
import 'package:date_format/date_format.dart';
import 'package:codeiiest/screens/partials/hyperlink.dart';

ExpansionPanelRadio sessionCard(Session session) {
  return ExpansionPanelRadio(
    canTapOnHeader: true,
    value: session.hashCode,
    headerBuilder: (BuildContext context, bool isExpanded) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            CircleAvatar(),
            SizedBox(width: 10.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  session.domain,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  formatDate(session.date.toDate(), [dd, ' ', M, ' \'', yy]),
                  style: TextStyle(
                    fontSize: 13.0,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    },
    body: Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          session.links.isNotEmpty
              ? Text(
                  'Links',
                  style: TextStyle(
                      fontWeight: FontWeight.w500, color: Colors.black54),
                )
              : SizedBox(),
          session.links.isNotEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: session.links
                      .map((link) => Hyperlink(link, link))
                      .toList(),
                )
              : SizedBox(),
          SizedBox(
            height: 12.0,
          ),
          Text(
            'Topics',
            style:
                TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
          ),
          session.topics.isNotEmpty
              ? Wrap(
                  runSpacing: -11.0,
                  alignment: WrapAlignment.start,
                  spacing: 8.0,
                  children: session.topics
                      .map((topic) => Chip(
                            label: Text(topic),
                          ))
                      .toList(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "-_-' nothing tagged",
                    style: TextStyle(color: Colors.red[200]),
                  ),
                )
        ],
      ),
    ),
  );
}
