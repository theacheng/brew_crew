import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:brew_crew/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:brew_crew/shared/constants.dart';
import 'package:provider/provider.dart';

class SettingForm extends StatefulWidget {
  SettingForm({Key key}) : super(key: key);

  @override
  _SettingFormState createState() => _SettingFormState();
}

class _SettingFormState extends State<SettingForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> sugar = ['0', '1', '2', '3', '4'];

  // form value
  String _currentName;
  String _currentSugar;
  int _currentStrength;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CustomUser>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Update your brew settings.',
                    style: TextStyle(
                      color: Colors.brown[700],
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    initialValue: userData.name,
                    decoration:
                        textInputDecoration.copyWith(hintText: 'Enter a name'),
                    validator: (val) =>
                        val.isEmpty ? 'Please enter a name' : null,
                    onChanged: (val) => setState(() => _currentName = val),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField(
                      decoration: textInputDecoration,
                      value: _currentSugar ?? userData.sugars,
                      items: sugar
                          .map((sugar) => DropdownMenuItem(
                                value: sugar,
                                child: Text('$sugar sugars'),
                              ))
                          .toList(),
                      onChanged: (val) => setState(() => _currentSugar = val)),
                  SizedBox(height: 20),
                  Slider(
                    value: (_currentStrength ?? userData.strength).toDouble(),
                    activeColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    inactiveColor:
                        Colors.brown[_currentStrength ?? userData.strength],
                    divisions: 8,
                    min: 100.0,
                    max: 900.0,
                    onChanged: (val) => setState(
                      () => _currentStrength = val.round(),
                    ),
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                    color: Colors.brown[400],
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        await DatabaseService(uid: user.uid).updateUserData(
                          _currentSugar ?? userData.sugars,
                          _currentName ?? userData.name,
                          _currentStrength ?? userData.strength,
                        );
                      }
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Update',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
