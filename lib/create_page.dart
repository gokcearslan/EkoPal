import 'package:ekopal/services/new_Type_Service.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'colors.dart';

class CreatePage extends StatefulWidget {

  final String initialCategory;
  CreatePage({this.initialCategory = 'İlan'}); // Default is 'İlan'


  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? _selectedOption;
  final String _placeholderValue = "__placeholder__";
  @override
  void initState() {
    super.initState();
    // Initialize _selectedOption to the placeholder value
    //_selectedOption = 'İlan';
    _selectedOption = widget.initialCategory;

  }


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
        title: const Text('Oluştur', style: TextStyle(fontSize: 26)),
        backgroundColor: backgroundColor,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20),
            Text(
              'Oluşturmak istediğiniz kategoriyi seçiniz',
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            FutureBuilder<List<String>>(
              future: getCategoryNames(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                List<String> categories = snapshot.data ?? [];
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color:backgroundColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: _selectedOption,
                      items: [
                        DropdownMenuItem<String>(
                          value: _placeholderValue,
                          child: Text('Bir kategori seçiniz'),
                        ),
                        ...categories.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ],
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedOption = newValue;
                        });
                      },
                      style: TextStyle(color: textColor, fontSize: 21),
                      dropdownColor: backgroundColor,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildContent(),
          ],
        ),
      ),
    );
  }
}
///

class IlanWidget extends StatefulWidget {
  @override
  _IlanWidgetState createState() => _IlanWidgetState();
}
class _IlanWidgetState extends State<IlanWidget> {
  TextEditingController _advertisementNameController = TextEditingController();
  TextEditingController _advertisementTypeController = TextEditingController();
  TextEditingController _advertisementDetailsController = TextEditingController();

  List<String> ad_types = [];
  String? _selectedType;

  @override
  void initState() {
    super.initState();
    _loadTypeNames();
  }

  void _clearTextFields() {
    _advertisementNameController.clear();
    _advertisementTypeController.clear();
    _advertisementDetailsController.clear();
    // tür için clear eklenecek - altta eklendi
    setState(() {
      _selectedType = null;
    });
  }

  Future<void> _loadTypeNames() async {
    ad_types = await getTypeNames();
    setState(() {}); // Call setState to rebuild the widget with the loaded types
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
      Container(
        width: double.infinity, // Ensures the container tries to expand to fill all available horizontal space
        child: TextFormField(
          controller: _advertisementNameController,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            labelText: 'İlan başlığı',
            labelStyle: TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            fillColor: backgroundColor,
            filled: true,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10), // Increase padding to make the field larger
          ),
        ),
      ),
          SizedBox(height: 20),
        Container(
          width: double.infinity,
          child: TextFormField(
            controller: _advertisementDetailsController,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.black,
            ),
            decoration: InputDecoration(
              labelText: 'İlan detayları',
              labelStyle: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              //icon: Icon(Icons.details), // Icon next to the label
              hintText: 'Gelecek olan kişinin payına düşen kira, oda sayısı, eşyalı/eşyasız olma durumu vb. bilgileri giriniz.',
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              hintMaxLines: 3,
              fillColor: backgroundColor,
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none, // No border visible
                borderRadius: BorderRadius.circular(12), // Rounded corners of the border
              ),
              contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10), // Padding inside the text field
            ),
            maxLines: null, // Allows the field to expand vertically as text is entered
            minLines: 3, // Starts with 3 lines visible
            keyboardType: TextInputType.multiline, // Keyboard type set for multiline text
          ),
        ),
          SizedBox(height: 20),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: backgroundColor,
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              hint: Text('İlan türünü seçiniz'),
              value: _selectedType,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedType = newValue;
                  });
                }
              },
              dropdownColor: backgroundColor,
              items: ad_types.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: textColor, fontSize: 21),
                  ),
                );
              }).toList(),
              style: TextStyle(color: textColor, fontSize: 21),
              icon: Icon(Icons.arrow_drop_down, color: textColor),
              iconSize: 24,
              elevation: 16,
              isExpanded: true,
            ),
          ),
        ),
        SizedBox(height: 20),
        IconButton(
          icon: Icon(Icons.add_photo_alternate, size: 50),
          onPressed: () {
            // Functionality to be implemented later
            print('Icon to add image pressed');
            },
        ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String? userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) {
                print('No user logged in');
                return;
              }
              if (_selectedType != null) {
                Advertisement a = Advertisement(
                    advertisementName: _advertisementNameController.text,
                    advertisementType: _selectedType,
                    advertisementDetails: _advertisementDetailsController.text,
                    userId: userId
                );
                AdvertisementService().addAdvertisement(a);
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
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor,
             backgroundColor: backgroundColor,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold), // Text style
              padding: EdgeInsets.symmetric(horizontal: 118, vertical: 11),
              shape: RoundedRectangleBorder( // Button shape
                borderRadius: BorderRadius.circular(12), // Rounded corners
              ),
              elevation: 10, // Shadow depth
            ),
            child: Text('İlan Oluştur'),
          ),

        ],
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
            _eventDateController.text = DateFormat('dd-MM-yyyy – HH:mm').format(pickedDateTime);
                //DateFormat('yyyy-MM-dd – HH:mm').format(pickedDateTime);
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
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _eventNameController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinlik Adı',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal:10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _eventDateController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinlik Tarihi',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                suffixIcon: Icon(Icons.calendar_today, color: Colors.black),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              readOnly: true,
              onTap: () => _selectDateAndTime(context),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _organizerController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinliği Düzenleyen Kişi/Topluluk',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _locationController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinlik Yeri',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _additionalInfoController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Ek Açıklamalar',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.add_photo_alternate, size: 50),
            onPressed: () {
              // Functionality to be implemented later
              print('Icon to add image pressed');
            },
          ),
          SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              String? userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) {
                print('No user logged in');
                return;
              }
              Event event = Event(
                eventName: _eventNameController.text,
                eventDate: _eventDateController.text,
                organizer: _organizerController.text,
                location: _locationController.text,
                additionalInfo: _additionalInfoController.text,
                userId: userId,
              );
              EventService().addEvent(event);
              _clearTextFields();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor,
              backgroundColor: backgroundColor,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 118, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
            ),
            child: Text('Etkinlik Oluştur'),
          ),
          SizedBox(height: 20),
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
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _DuyuruNameController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Duyuru Başlığı',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _duyuruDetailsController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Duyuru İçeriği',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              maxLines: null, // Allows for multi-line input without a fixed limit
              minLines: 3, // Starts with 3 lines visible
              keyboardType: TextInputType.multiline,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller: _duyuruTypeController,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Duyuru Türü',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          SizedBox(height: 20),
          IconButton(
            icon: Icon(Icons.add_photo_alternate, size: 50),
            onPressed: () {
              // Functionality to be implemented later
              print('Icon to add image pressed');
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String? userId = FirebaseAuth.instance.currentUser?.uid;
              if (userId == null) {
                print('No user logged in');
                return;
              }
              Duyuru duyuru = Duyuru(
                duyuruName: _DuyuruNameController.text,
                duyuruType: _duyuruTypeController.text,
                duyuruDetails: _duyuruDetailsController.text,
                userId: userId,
              );
              DuyuruService().addDuyuru(duyuru);
              _clearTextFields();
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor,
              backgroundColor: backgroundColor,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 118, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
            ),
            child: Text('Duyuru Oluştur'),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

}