import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/image_service.dart';
import 'package:ekopal/services/new_Type_Service.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/duyuru_model.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'advertisements.dart';
import 'announcements.dart';
import 'colors.dart';
import 'events_page.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';


class CreatePage extends StatefulWidget {

  final String initialCategory;
  CreatePage({this.initialCategory = 'İlan'});


  @override
  _CreatePageState createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  String? _selectedOption;
  final String _placeholderValue = "__placeholder__";
  @override
  void initState() {
    super.initState();
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
  String? _selectedImageUrl;
  String? _imageUrl;


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
    setState(() {
      _selectedType = null;
    });
  }

  Future<void> _loadTypeNames() async {
    ad_types = await getTypeNames();
    setState(() {});
  }


  void _showEditImageActionSheet(BuildContext context) {
    final action = CupertinoActionSheet(
      title: Text("Picture", style: TextStyle(fontSize: 15.0, color: Color(0xFF001489))),
      message: Text("Select a picture for the advertisement", style: TextStyle(fontSize: 15.0, color: Color(0xFF001489).withOpacity(0.7))),
      actions: [
        CupertinoActionSheetAction(
          child: Text("Camera", style: TextStyle(color: Color(0xFF001489))),
          onPressed: () {
            Navigator.pop(context);
            _uploadAdvertisementImage(ImageSource.camera).then((imageUrl) {
              if (imageUrl != null) {
                setState(() {
                  _imageUrl = imageUrl;
                });
              }
            });
          },
        ),
        CupertinoActionSheetAction(
          child: Text("Gallery", style: TextStyle(color: Color(0xFF001489))),
          onPressed: () {
            Navigator.pop(context);
            _uploadAdvertisementImage(ImageSource.gallery).then((imageUrl) {
              if (imageUrl != null) {
                setState(() {
                  _imageUrl = imageUrl;
                });
              }
            });
          },
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        child: Text("Close", style: TextStyle(color: Colors.red)),
        isDestructiveAction: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );

    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => action,
    );
  }

  Future<String?> _uploadAdvertisementImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);

    if (image != null) {
      File imageFile = File(image.path);
      String fileName = 'advertisement_images/${FirebaseAuth.instance.currentUser?.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';

      try {
        TaskSnapshot snapshot = await FirebaseStorage.instance.ref(fileName).putFile(imageFile);
        String downloadUrl = await snapshot.ref.getDownloadURL();
        print("Image URL: $downloadUrl");
        return downloadUrl;
      } catch (e) {
        print('Error uploading image: $e');
      }
    }
    return null;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                if (_imageUrl == null)  // Display the IconButton only if _imageUrl is null
                  Flexible(
                    child: IconButton(
                      icon: Icon(Icons.add_photo_alternate, size: 50),
                      onPressed: () {
                        _uploadAdvertisementImage(ImageSource.gallery).then((imageUrl) {
                          if (imageUrl != null) {
                            setState(() {
                              _imageUrl = imageUrl;  // Store the uploaded image URL
                            });
                          } else {
                            print("Failed to upload image or get URL.");
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Failed to upload image"))
                            );
                          }
                        }).catchError((error) {
                          print("Error in uploading image: $error");
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error in uploading image: $error"))
                          );
                        });
                      },
                    ),
                  ),
                if (_imageUrl != null)  // Display the image if _imageUrl is not null
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: 350,  // maximum width for the image
                          maxHeight: 400,  // maximum height for the image
                        ),
                        child: Image.network(
                          _imageUrl!,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
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
            SizedBox(height: 10),
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
            SizedBox(height: 10),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (_imageUrl == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Please upload an image first."))
                    );
                    return;
                  }
                  FirebaseFirestore.instance.collection('advertisements').add({
                    'imageUrl': _imageUrl,
                    'advertisementName': _advertisementNameController.text,
                    'advertisementType': _selectedType,
                    'advertisementDetails': _advertisementDetailsController.text,
                    'userId': FirebaseAuth.instance.currentUser?.uid,
                  }).then((_) {
                    print("Advertisement successfully posted.");
                  //  ScaffoldMessenger.of(context).showSnackBar(
                   //     SnackBar(content: Text("Advertisement successfully posted."))
                    //);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ViewAdvertisements()),
                    );
                  }).catchError((error) {
                    print("Failed to create advertisement: $error");
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Failed to create advertisement"))
                    );
                  });
                }
              },

              style: ElevatedButton.styleFrom(
                foregroundColor: textColor,
                backgroundColor: backgroundColor,
                textStyle: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
                padding: EdgeInsets.symmetric(horizontal: 120, vertical: 16),
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
    final DateTime simdi = DateTime.now();
    final DateTime? secilenTarih = await showDatePicker(
      context: context,
      initialDate: simdi,
      firstDate: simdi,
      lastDate: DateTime(2101),
      locale: const Locale('tr', 'TR'), // Set the locale to Turkish
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light(), // You can customize the theme here if needed
          child: child!,
        );
      },
    );

    if (secilenTarih != null) {
      final TimeOfDay? secilenSaat = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: simdi.hour, minute: simdi.minute),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), // Ensure 24-hour format
            child: Localizations.override(
              context: context,
              locale: const Locale('tr', 'TR'), // Set the locale to Turkish for time picker
              child: child!,
            ),
          );
        },
      );

      if (secilenSaat != null) {
        final DateTime secilenTarihVeSaat = DateTime(
          secilenTarih.year,
          secilenTarih.month,
          secilenTarih.day,
          secilenSaat.hour,
          secilenSaat.minute,
        );

        if (secilenTarihVeSaat.isAfter(simdi)) {
          setState(() {
            _eventDateController.text = DateFormat('dd-MM-yyyy – HH:mm', 'tr_TR').format(secilenTarihVeSaat);
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geçmiş tarihler için etkinlik oluşturulamaz!')),
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
            /*
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
            */
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
                padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
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
                padding: EdgeInsets.symmetric(horizontal: 100, vertical: 16),
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