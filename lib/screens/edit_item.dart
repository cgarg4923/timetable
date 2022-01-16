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
  int day;
  bool _initValue = false;
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
      initialTime: _editableInfo.startTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (pickedS != null && pickedS != _editableInfo.startTime)
      setState(
        () {
          _editableInfo = InfoItem(
            id: _editableInfo.id,
            title: _editableInfo.title,
            description: _editableInfo.description,
            startTime: pickedS,
            endTime: _editableInfo.endTime,
          );
        },
      );
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay pickedS = await showTimePicker(
      context: context,
      initialTime: _editableInfo.endTime,
      builder: (BuildContext context, Widget child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child,
        );
      },
    );
    if (pickedS != null && pickedS != _editableInfo.endTime)
      setState(
        () {
          _editableInfo = InfoItem(
            id: _editableInfo.id,
            title: _editableInfo.title,
            description: _editableInfo.description,
            startTime: _editableInfo.startTime,
            endTime: pickedS,
          );
        },
      );
  }

  void _saveForm(int days) {
    _form.currentState.save();
    print(_editableInfo.startTime);
    print(_editableInfo.endTime);
    Provider.of<Info>(context, listen: false).edit(
      days,
      _editableInfo.id,
      _editableInfo.title,
      _editableInfo.description,
      _editableInfo.startTime,
      _editableInfo.endTime,
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_initValue) {
      final List args = ModalRoute.of(context).settings.arguments as List;
      final _currentInfo = Provider.of<Info>(context, listen: false)
          .getSingleInfo(args[0], args[1]);
      setState(() {
        _editableInfo = _currentInfo;
        day = args[0];
      });
    }
    _initValue = true;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Slot'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              _saveForm(day);
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
        autovalidateMode: AutovalidateMode.always,
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
                  initialValue: _editableInfo.title,
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
                  initialValue: _editableInfo.description,
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
                                .formatTimeOfDay(_editableInfo.startTime),
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
                                .formatTimeOfDay(_editableInfo.endTime),
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
                  _saveForm(day);
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
