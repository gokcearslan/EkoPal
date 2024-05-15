import 'package:ekopal/services/new_Type_Service.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'advertisements.dart';
import 'advertisements_view_page.dart';
import 'announcements.dart';
import 'colors.dart';
import 'events_page.dart';

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
        centerTitle: true,
        backgroundColor: appBarColor,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20),
            Text(
              'Oluşturmak istediğiniz kategoriyi seçiniz',
              style: TextStyle(fontSize: 19),
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

  final _formKey = GlobalKey<FormState>();

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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            TextFormField(
              controller: _advertisementNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'İlan başlığı',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _advertisementDetailsController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },
              decoration: InputDecoration(
                labelText: 'İlan detayları',
                labelStyle: TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                hintText: 'Detayları giriniz',
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              maxLines: null,
              minLines: 3,
              keyboardType: TextInputType.multiline,
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
                    setState(() {
                      _selectedType = newValue;
                    });
                  },
                  items: ad_types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: TextStyle(color: textColor, fontSize: 21)),
                    );
                  }).toList(),
                  dropdownColor: backgroundColor,
                  style: TextStyle(color: textColor, fontSize: 21),
                  icon: Icon(Icons.arrow_drop_down, color: textColor),
                  iconSize: 24,
                  elevation: 16,
                  isExpanded: true,
                ),
              ),
            ),
            SizedBox(height: 20),
            //FOTO EKLEME YERİ
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.add_photo_alternate, size: 50),
                  onPressed: () {
                    // Functionality to be implemented later
                    print('Icon to add image pressed');
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String? userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) {
                    print('No user logged in');
                    return;
                  }
                  Advertisement a = Advertisement(
                      advertisementName: _advertisementNameController.text,
                      advertisementType: _selectedType,
                      advertisementDetails: _advertisementDetailsController.text,
                      userId: userId
                  );
                  AdvertisementService().addAdvertisement(a)..then((value) {
                    print("İlan başarıyla paylaşıldı");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("İlan başarıyla paylaşıldı")));
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewAdvertisements()),
                    );
                  }).catchError((error) {
                    print("Paylaşma sırasında bir hata oluştu: $error");
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paylaşma sırasında bir hata oluştu')));
                  });

                  _clearTextFields();
                }
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
              child: Text('İlan Oluştur'),
            ),
          ],
        ),
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

  final _formKey = GlobalKey<FormState>();


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
            SnackBar(content: Text('Geçmiş Tarihler için etkinlik oluşturulamaz!')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
    child: Form(
    key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller:_eventNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinlik Adı',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
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
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller:_eventDateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinlik Tarihi',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                suffixIcon: const Icon(Icons.calendar_today, color: Colors.black),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              readOnly: true,
              onTap: () => _selectDateAndTime(context),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller: _organizerController,
                validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bu alan boş bırakılamaz';
              }
              return null;
            },              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinliği Düzenleyen Kişi/Topluluk',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller: _locationController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Etkinlik Yeri',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller:_additionalInfoController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Ek Açıklamalar',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          //FOTO EKLEME YERİ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_photo_alternate, size: 50),
                onPressed: () {
                  // Functionality to be implemented later
                  print('Icon to add image pressed');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
             if (_formKey.currentState!.validate()) {
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
               EventService().addEvent(event).then((value) {
                 print("Etkinlik başarıyla paylaşıldı");
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Etkinlik başarıyla paylaşıldı")));
                 Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => EventsPage()),
                 );
               }).catchError((error) {
                 print("Paylaşma sırasında bir hata oluştu: $error");
                 ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paylaşma sırasında bir hata oluştu')));
               });

               _clearTextFields();
             }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor,
              backgroundColor: backgroundColor,
              textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
            ),
            child: const Text('Etkinlik Oluştur'),
          ),
        ],
      ),
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

  final _formKey = GlobalKey<FormState>();


  void _clearTextFields() {
    _DuyuruNameController.clear();
    _duyuruDetailsController.clear();
    _duyuruTypeController.clear();

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
    child: Form(
    key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            child: TextFormField(
              controller:_DuyuruNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Duyuru Başlığı',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller:_duyuruDetailsController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Duyuru İçeriği',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
              maxLines: null,
              minLines: 3,
              keyboardType: TextInputType.multiline,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: TextFormField(
              controller:_duyuruTypeController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Bu alan boş bırakılamaz';
                }
                return null;
              },              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                labelText: 'Duyuru Türü',
                labelStyle: const TextStyle(
                  fontSize: 20,
                  color: textColor,
                ),
                fillColor: backgroundColor,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          //FOTO EKLEME YERİ
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.add_photo_alternate, size: 50),
                onPressed: () {
                  // Functionality to be implemented later
                  print('Icon to add image pressed');
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
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
                DuyuruService().addDuyuru(duyuru).then((value) {
                  print("Duyuru başarıyla paylaşıldı");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Duyuru başarıyla paylaşıldı")));
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AnnouncementsPage()),
                  );
                }).catchError((error) {
                  print("Paylaşma sırasında bir hata oluştu: $error");
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Paylaşma sırasında bir hata oluştu')));
                });

                _clearTextFields();
              }
            },
            style: ElevatedButton.styleFrom(
              foregroundColor: textColor,
              backgroundColor: backgroundColor,
              textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 13),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 10,
            ),
            child: Text('Duyuru Oluştur'),
          ),

        ],
      ),
    ),
    );
  }

}