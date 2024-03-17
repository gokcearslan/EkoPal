import 'package:ekopal/services/announcement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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


///////////

class IlanWidget extends StatefulWidget {
  @override
  _IlanWidgetState createState() => _IlanWidgetState();
}
class _IlanWidgetState extends State<IlanWidget> {
  TextEditingController _announcementNameController = TextEditingController();
  TextEditingController _announcementTypeController = TextEditingController();
  TextEditingController _announcementDetailsController = TextEditingController();

  List<String> annct_types = ['Ev', 'Kitap', 'Proje','İş','Staj'];
  String? _selectedType;


  void _clearTextFields() {
    _announcementNameController.clear();
    _announcementTypeController.clear();
    _announcementDetailsController.clear();
    // tür için clear eklenecek - altta eklendi
    setState(() {
      _selectedType = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _announcementNameController,
            decoration: InputDecoration(labelText: 'İlan başlığı'),
          ),

          Container(
            child: TextFormField(
              controller: _announcementDetailsController,
              decoration: InputDecoration(labelText: 'İlan detayları'),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
          ),
          DropdownButton<String>(
            hint: Text('İlan türünü seçiniz'),
            value: _selectedType,
            onChanged: (String? newValue) {
              if(newValue != null) {
                setState(() {
                  _selectedType = newValue;
                });
              }
            },
            items: annct_types.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
            if (_selectedType != null) {
                Announcement a = Announcement(
                announcementName: _announcementNameController.text,
                announcementType: _selectedType,
                announcementDetails: _announcementDetailsController.text,

              );
              // Save to Firebase
              AnnouncementService().addAnnouncement(a);
              // Clear the selected gender
              setState(() {
                _selectedType = null;
              });
            } else {
              print('Lütfen bir ilan türü seçiniz.');
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Hata'),
                    content: Text('Lütfen bir ilan türü seçiniz.'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Tamam'),
                      ),
                    ],
                  );
                },
              );
            }

            _clearTextFields();
            },
            child: Text('İlan Oluştur'),
          ),
        ],
      ),
    );
  }
}

////////
/*
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


 */

///

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

  Future<void> _selectDateAndTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: now.hour, minute: now.minute),
      );

      if (pickedTime != null) {
        final DateTime pickedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        if (pickedDateTime.isAfter(now)) {
          setState(() {
            _eventDateController.text = DateFormat('yyyy-MM-dd – HH:mm').format(pickedDateTime);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geçmiş Tarihler için etkinlik oluşturulamaz!.')),
          );
        }
      }
    }
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
            readOnly: true,
            onTap: () => _selectDateAndTime(context),
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

              Event event = Event(
                eventName: _eventNameController.text,
                eventDate: _eventDateController.text,
                organizer: _organizerController.text,
                location: _locationController.text,
                additionalInfo: _additionalInfoController.text,
              );

              EventService().addEvent(event);
              _clearTextFields();
            },
            child: Text('Etkinlik Oluştur'),
          ),
        ],
      ),
    );
  }
}


///
class DuyuruWidget extends StatefulWidget {
  @override
  _DuyuruWidgetState createState() => _DuyuruWidgetState();
}

class _DuyuruWidgetState extends State<DuyuruWidget> {
  TextEditingController _DuyuruNameController = TextEditingController();
  TextEditingController _duyuruDetailsController = TextEditingController();
  TextEditingController _duyuruTypeController = TextEditingController();


  void _clearTextFields() {
    _DuyuruNameController.clear();
    _duyuruDetailsController.clear();
    _duyuruTypeController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _DuyuruNameController,
            decoration: InputDecoration(labelText: 'Duyuru Başlığı'),
          ),
          TextFormField(
            controller: _duyuruDetailsController,
            decoration: InputDecoration(labelText: 'Duyuru İçeriği'),
          ),
          TextFormField(
            controller: _duyuruTypeController,
            decoration: InputDecoration(labelText: 'Duyuru Türü'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Create an instance of "duyuru"
              Duyuru duyuru = Duyuru(
                duyuruName: _DuyuruNameController.text,
                duyuruDetails: _duyuruDetailsController.text,
                duyuruType: _duyuruTypeController.text,
              );

              // Save the "duyuru" to Firebase
              DuyuruService().addDuyuru(duyuru);

              _clearTextFields();
            },
            child: Text('Duyuru Oluştur'),
          ),
        ],
      ),
    );
  }
}
