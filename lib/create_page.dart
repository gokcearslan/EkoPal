import 'package:ekopal/services/new_Type_Service.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
                FutureBuilder<List<String>>(
                  future: getCategoryNames(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }

                    List<String> categories = snapshot.data ?? [];
                    // Debugging
                    print("Selected option: $_selectedOption");
                    print("Categories: $categories");

                    return DropdownButton<String>(
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

                    );
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
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            decoration: InputDecoration(
              labelText: 'İlan başlığı',
              hintText: 'Başlık giriniz.',
              floatingLabelBehavior: FloatingLabelBehavior.always,
              filled: true,
              fillColor: Colors.purpleAccent.withOpacity(0.1),
              labelStyle: TextStyle(
                color: Colors.brown,  // Sets the color of the label text
                fontSize: 16,
                fontWeight: FontWeight.bold,// Optionally set the font size
              ),
              hintStyle:TextStyle(
                color: Colors.brown,  // Sets the color of the label text
                fontSize: 16,
                fontWeight: FontWeight.bold,// Optionally set the font size
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
              focusedBorder: UnderlineInputBorder( // Underlined border when focused
                borderSide: BorderSide(
                  color: Colors.brown.withOpacity(0.5), // Color of the underline
                  width: 2.5, // Thickness of the underline
                ),
              ),
            ),
          ),

          SizedBox(height: 5),

          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.purpleAccent.withOpacity(0.1),
              prefixIcon: Icon(Icons.keyboard_arrow_down, color: Colors.brown), // Search icon
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide.none,
              ),
            ),
            value: _selectedType,
            icon: Icon(Icons.arrow_drop_down, color: Colors.white), // Dropdown icon
            iconSize: 24,
            elevation: 16,
            style: TextStyle(color: Colors.white, fontSize: 18),
            onChanged: (String? newValue) {
              _selectedType = newValue; // Update the selected value on change
            },
            items: ad_types.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(
                  color: Colors.brown, // Color for each item
                  fontSize: 16, // Font size for each item
                  fontWeight: FontWeight.bold, // Font weight for each item
                )),
              );
            }).toList(),
          ),


          /// eskisi aşağıda

          SizedBox(height: 20),
          TextFormField(
            controller: _advertisementNameController,
            decoration: InputDecoration(labelText: 'İlan başlığı'),
          ),

          Container(
            child: TextFormField(
              controller: _advertisementDetailsController,
              decoration: InputDecoration(labelText: 'İlan detayları',
                icon: Icon(Icons.details),
                hintText: 'Gelecek olan kişinin  payına düşen kira, oda sayısı, eşyalı/eşyasız olma durumu vb. bilgileri giriniz.',
                hintMaxLines: 3
              ),
              maxLines: null,
              minLines: 3,
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
            items: ad_types.map<DropdownMenuItem<String>>((String value) {
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
                Advertisement a = Advertisement(
                  advertisementName: _advertisementNameController.text,
                  advertisementType: _selectedType,
                  advertisementDetails: _advertisementDetailsController.text,
                );
                // Save to Firebase
                AdvertisementService().addAdvertisement(a);
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
          TextField(
            controller: _eventNameController,
            decoration: InputDecoration(
              labelText: 'Etkinlik Adı',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),  // Spacing between text fields
          TextField(
            controller: _eventDateController,
            decoration: InputDecoration(
              labelText: 'Etkinlik Tarihi',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () => _selectDateAndTime(context),
          ),
          SizedBox(height: 10),  // Spacing between text fields
          TextField(
            controller: _organizerController,
            decoration: InputDecoration(
              labelText: 'Etkinliği Düzenleyen Kişi/Topluluk',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),  // Spacing between text fields
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              labelText: 'Etkinlik Yeri',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 10),  // Spacing between text fields
          TextField(
            controller: _additionalInfoController,
            decoration: InputDecoration(
              labelText: 'Ek Açıklamalar',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),  // Larger space before the button
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