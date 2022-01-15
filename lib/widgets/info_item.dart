import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/info.dart';
import '../screens/edit_item.dart';

class InfoItem extends StatefulWidget {
  final int day;
  final String id;
  final String title;
  final String info;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  InfoItem({
    this.day,
    this.id,
    this.title,
    this.info,
    this.startTime,
    this.endTime,
  });

  @override
  _InfoItemState createState() => _InfoItemState();
}

class _InfoItemState extends State<InfoItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final _info = Provider.of<Info>(context, listen: false);

    return Card(
      margin: EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: Text(
              MaterialLocalizations.of(context)
                  .formatTimeOfDay(widget.startTime),
            ),
            title: Text(widget.title),
            onTap: () {
              setState(() {
                _expanded = !_expanded;
              });
            },
          ),
          if (_expanded)
            Container(
              height: 100,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    Text(
                      MaterialLocalizations.of(context)
                              .formatTimeOfDay(widget.startTime) +
                          ' - ' +
                          MaterialLocalizations.of(context)
                              .formatTimeOfDay(widget.endTime),
                    ),
                    Text(
                      '${widget.info}',
                      softWrap: true,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              EditItem.routeName,
                              arguments: [
                                widget.day,
                                widget.id,
                              ],
                            );
                          },
                          child: Text('Edit'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Are You Sure?'),
                                content: Text(
                                    'Do you want to remove item from the cart?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('No'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      _info.delete(widget.day, widget.id);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Yes'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
