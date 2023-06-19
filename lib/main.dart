import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/services.dart';

void main() {
  runApp(PasswordGeneratorApp());
}

class PasswordGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generador de Contraseñas',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PasswordGeneratorScreen(),
    );
  }
}

class PasswordGeneratorScreen extends StatefulWidget {
  @override
  _PasswordGeneratorScreenState createState() =>
      _PasswordGeneratorScreenState();
}

class _PasswordGeneratorScreenState extends State<PasswordGeneratorScreen> {
  bool _includeUppercase = true;
  bool _includeLowercase = true;
  bool _includeNumbers = true;
  bool _includeSpecialCharacters = true;
  int _passwordLength = 8;
  String _generatedPassword = '';

  void _generatePassword() {
    String characters = '';

    if (_includeUppercase) characters += 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    if (_includeLowercase) characters += 'abcdefghijklmnopqrstuvwxyz';
    if (_includeNumbers) characters += '0123456789';
    if (_includeSpecialCharacters) characters += '!@#\$%^&*()-=_+';

    if (!_includeUppercase &&
        !_includeLowercase &&
        !_includeNumbers &&
        !_includeSpecialCharacters) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Debe seleccionar al menos una opción.'),
            actions: <Widget>[
              TextButton(
                child: Text('Aceptar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return;
    }

    String password = '';

    for (int i = 0; i < _passwordLength; i++) {
      password += characters[Random().nextInt(characters.length)];
    }

    setState(() {
      _generatedPassword = password;
    });
  }

  void _copyToClipboard() {
    Clipboard.setData(ClipboardData(text: _generatedPassword));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contraseña copiada al portapapeles')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Password Generator'),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'Configuración',
                style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text('Longitud de la contraseña:'),
                  SizedBox(width: 8.0),
                  DropdownButton<int>(
                    value: _passwordLength,
                    onChanged: (int? value) {
                      setState(() {
                        _passwordLength = value ?? 8;
                      });
                    },
                    items: <DropdownMenuItem<int>>[
                      DropdownMenuItem<int>(
                        value: 8,
                        child: Text('8'),
                      ),
                      DropdownMenuItem<int>(
                        value: 12,
                        child: Text('12'),
                      ),
                      DropdownMenuItem<int>(
                        value: 16,
                        child: Text('16'),
                      ),
                      DropdownMenuItem<int>(
                        value: 20,
                        child: Text('20'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              CheckboxListTile(
                title: Text('Incluir letras mayúsculas'),
                value: _includeUppercase,
                onChanged: (bool? value) {
                  setState(() {
                    _includeUppercase = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Incluir letras minúsculas'),
                value: _includeLowercase,
                onChanged: (bool? value) {
                  setState(() {
                    _includeLowercase = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Incluir números'),
                value: _includeNumbers,
                onChanged: (bool? value) {
                  setState(() {
                    _includeNumbers = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: Text('Incluir caracteres especiales'),
                value: _includeSpecialCharacters,
                onChanged: (bool? value) {
                  setState(() {
                    _includeSpecialCharacters = value ?? false;
                  });
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _generatePassword,
                child: Text('Generar contraseña'),
              ),
              SizedBox(height: 16.0),
              if (_generatedPassword.isNotEmpty) ...[
                Text(
                  'Contraseña generada:',
                  style: TextStyle(fontSize: 16.0),
                ),
                SizedBox(height: 8.0),
                SelectableText(
                  _generatedPassword,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _copyToClipboard,
                  child: Text('Copiar al portapapeles'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
