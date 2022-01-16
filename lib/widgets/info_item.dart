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
    Future<bool> showConfirmationDialogBox() {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('Do you want to remove item from the cart?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                _info.delete(widget.day, widget.id);
                Navigator.of(context).pop(true);
              },
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }

    return Card(
      margin: EdgeInsets.all(8),
      child: Dismissible(
        key: ValueKey(widget.id),
        background: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Theme.of(context).errorColor,
          ),
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          margin: EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 4,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) {
          return showConfirmationDialogBox();
        },
        onDismissed: (direction) {
          _info.delete(widget.day, widget.id);
        },
        child: Column(
          children: [
            ListTile(
              leading: Text(
                MaterialLocalizations.of(context)
                    .formatTimeOfDay(widget.startTime),
              ),
              title: Text(
                widget.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              trailing: IconButton(
                icon: Icon(Icons.edit),
                splashColor: Theme.of(context).primaryColor,
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
              ),
            ),
            if (_expanded)
              Container(
                height: 70,
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
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${widget.info}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                        softWrap: true,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
