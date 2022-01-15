import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/info.dart';

class EditItem extends StatefulWidget {
  static String routeName = '/edit-item';
  @override
  _EditItemState createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _form = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();

  TimeOfDay selectedStartTime = TimeOfDay.now();
  TimeOfDay selectedEndTime = TimeOfDay.now();
  var _editableInfo = InfoItem(
    id: DateTime.now().toString(),
    title: '',
    description: '',
    startTime: TimeOfDay.now(),
    endTime: TimeOfDay.now(),
  );

  Future<void> _selectStartTime(
      BuildContext context, InfoItem _currentInfo) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: _currentInfo.startTime,
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
          id: _currentInfo.id,
          title: _editableInfo.title,
          description: _editableInfo.description,
          startTime: selectedStartTime,
          endTime: _editableInfo.endTime,
        );
      });
  }

  Future<void> _selectEndTime(
      BuildContext context, InfoItem _currentInfo) async {
    final TimeOfDay pickedS = await showTimePicker(
        context: context,
        initialTime: _currentInfo.endTime,
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
          id: _currentInfo.id,
          title: _editableInfo.title,
          description: _editableInfo.description,
          startTime: selectedStartTime,
          endTime: selectedEndTime,
        );
      });
  }

  void _saveForm(int day) {
    _form.currentState.save();
    print(_editableInfo.title);
    print(_editableInfo.description);
    print(_editableInfo.startTime);
    print(_editableInfo.endTime);

    Provider.of<Info>(context, listen: false).edit(
      day,
      _editableInfo.id,
      _editableInfo.title,
      _editableInfo.description,
      _editableInfo.startTime,
      _editableInfo.endTime,
    );
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context).settings.arguments as List;
    final _currentInfo = Provider.of<Info>(context, listen: false)
        .getSingleInfo(args[0], args[1]);
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Slot'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveForm(args[0]);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Slot Added Successfully!'),
                ),
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: Form(
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
                  initialValue: _currentInfo.title,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  onSaved: (value) {
                    _editableInfo = InfoItem(
                      id: _currentInfo.id,
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
                  initialValue: _currentInfo.description,
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
                      id: _currentInfo.id,
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
                                .formatTimeOfDay(_currentInfo.startTime),
                          ),
                          subtitle: Text('starts'),
                          onTap: () {
                            _selectStartTime(context, _currentInfo);
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        child: ListTile(
                          title: Text(
                            MaterialLocalizations.of(context)
                                .formatTimeOfDay(_currentInfo.endTime),
                          ),
                          subtitle: Text('ends'),
                          onTap: () {
                            _selectEndTime(context, _currentInfo);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _saveForm(args[0]);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Slot Editted Successfully!'),
                    ),
                  );
                  Navigator.of(context).pop();
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
