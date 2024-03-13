import 'package:flutter/material.dart';

class CreatePage extends StatefulWidget {
  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String _selectedOption = '';

  Widget _buildContent() {
    switch (_selectedOption) {
      case 'İlan':
        return IlanWidget();
      case 'Duyuru':
        return DuyuruWidget();
      case 'Etkinlik':
        return EtkinlikWidget();
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oluştur'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  'Oluşturmak istediğiniz kategoriyi seçiniz',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 20),
                DropdownButton<String>(
                  value: _selectedOption,
                  items: <String>['', 'İlan', 'Duyuru', 'Etkinlik']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                          value.isEmpty ? 'Bir kategori seçiniz' : value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedOption = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20),
                _buildContent(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class IlanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'İlan sayfası',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class DuyuruWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Duyuru Sayfası',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class EtkinlikWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        'Etlinlik Sayfası',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
