import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
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

class EtkinlikWidget extends StatefulWidget {
  @override
  _EtkinlikWidgetState createState() => _EtkinlikWidgetState();
}

class _EtkinlikWidgetState extends State<EtkinlikWidget> {
  TextEditingController _eventNameController = TextEditingController();
  TextEditingController _eventDateController = TextEditingController();
  TextEditingController _organizerController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _additionalInfoController = TextEditingController();

  void _clearTextFields() {
    _eventNameController.clear();
    _eventDateController.clear();
    _organizerController.clear();
    _locationController.clear();
    _additionalInfoController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _eventNameController,
            decoration: InputDecoration(labelText: 'Etkinlik Adı'),
          ),
          TextFormField(
            controller: _eventDateController,
            decoration: InputDecoration(labelText: 'Etkinlik Tarihi'),
          ),
          TextFormField(
            controller: _organizerController,
            decoration: InputDecoration(labelText: 'Etkinliği Düzenleyen Kişi/Topluluk'),
          ),
          TextFormField(
            controller: _locationController,
            decoration: InputDecoration(labelText: 'Etkinlik Yeri'),
          ),
          TextFormField(
            controller: _additionalInfoController,
            decoration: InputDecoration(labelText: 'Ek Açıklamalar'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Create an instance of Event using the entered data
              Event event = Event(
                eventName: _eventNameController.text,
                eventDate: _eventDateController.text,
                organizer: _organizerController.text,
                location: _locationController.text,
                additionalInfo: _additionalInfoController.text,
              );

              // Save the event to Firebase
              EventService().addEvent(event);

              // Clear the text fields
              _clearTextFields();
            },
            child: Text('Etkinlik Oluştur'),
          ),
        ],
      ),
    );
  }
}
