import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/info.dart';

class AddNewItem extends StatefulWidget {
  static String routeName = '/add-new-item';
  @override
  _AddNewItemState createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {
  final _form = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  bool _isLoaded = false;
  var _editableInfo = InfoItem(
    id: DateTime.now().toString(),
    title: '',
    description: '',
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay.now(),
  );

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: selectedStartTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedStartTime)
      setState(() {
        selectedStartTime = pickedS;
        _editableInfo = InfoItem(
          id: _editableInfo.id,
          title: _editableInfo.title,
          description: _editableInfo.description,
          startTime: selectedStartTime,
          endTime: _editableInfo.endTime,
        );
      });
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: selectedEndTime,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child,
          );
        });

    if (pickedS != null && pickedS != selectedEndTime)
      setState(() {
        selectedEndTime = pickedS;
        _editableInfo = InfoItem(
          id: _editableInfo.id,
          title: _editableInfo.title,
          description: _editableInfo.description,
          startTime: selectedStartTime,
          endTime: selectedEndTime,
        );
      });
  }

  void _saveForm(int day) {
    _form.currentState.save();
    Provider.of<Info>(context, listen: false)
        .addInfo(day, _editableInfo)
        .catchError((error) {
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          content: Text(error),
          title: Text('An Error Occured!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text('Okay'),
            ),
          ],
        ),
      );
    }).then((_) {
      setState(() {
        _isLoaded = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Slot Added Successfully!'),
        ),
      );
      Navigator.of(context).pop();
    });
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int day = ModalRoute.of(context).settings.arguments as int;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Slot'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              setState(() {
                _isLoaded = true;
              });
              _saveForm(day);
            },
          ),
        ],
      ),
      body: _isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Form(
              key: _form,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        onSaved: (value) {
                          _editableInfo = InfoItem(
                            id: _editableInfo.id,
                            title: value,
                            description: _editableInfo.description,
                            startTime: _editableInfo.startTime,
                            endTime: _editableInfo.endTime,
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.done,
                        focusNode: _descriptionFocusNode,
                        validator: (value) {
                          if (value.length > 200) {
                            return 'Maximum Word Limit Exceeded';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onSaved: (value) {
                          _editableInfo = InfoItem(
                            id: _editableInfo.id,
                            title: _editableInfo.title,
                            description: value,
                            startTime: _editableInfo.startTime,
                            endTime: _editableInfo.endTime,
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  MaterialLocalizations.of(context)
                                      .formatTimeOfDay(selectedStartTime),
                                ),
                                subtitle: Text('starts'),
                                onTap: () {
                                  _selectStartTime(context);
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  MaterialLocalizations.of(context)
                                      .formatTimeOfDay(selectedEndTime),
                                ),
                                subtitle: Text('ends'),
                                onTap: () {
                                  _selectEndTime(context);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _isLoaded = true;
                        });
                        _saveForm(day);
                      },
                      child: Text('Add'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
