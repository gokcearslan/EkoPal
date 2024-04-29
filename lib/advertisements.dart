import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ekopal/services/advertisement_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'advertisement_details_page.dart';
import 'colors.dart';
import 'create_page.dart';

class ViewAdvertisements extends StatefulWidget {
  const ViewAdvertisements({Key? key}) : super(key: key);

  @override
  _ViewAdvertisementsState createState() => _ViewAdvertisementsState();
}

class _ViewAdvertisementsState extends State<ViewAdvertisements> {
  List<Advertisement>? advertisements;

  @override
  void initState() {
    super.initState();
    fetchAdvertisements();

  }

  fetchAdvertisements() async {
    advertisements = await AdvertisementService().getAdvertisements();
    if (mounted) {
      setState(() {});
    }
  }


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    final textTheme = Theme
        .of(context)
        .textTheme;


    return Scaffold(
      backgroundColor:white,
        appBar: AppBar(
          title: const Text(
            'İlanlar',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          backgroundColor: appBarColor,
        ),
        body: advertisements == null
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
          itemCount: advertisements!.length,
          itemBuilder: (context, index) {
            return buildAdCard(advertisements![index]);
          },
        ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CreatePage(initialCategory: 'İlan')));
          },
          child: Material(
            color: Colors.transparent,
            child: Icon(
              Icons.add,
              color: textColor,
            ),
          ),
          backgroundColor: lightButtonColor,
        ),
        );
  }


  Widget buildAdCard(Advertisement ad) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Card(
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5.0,
        color:cardColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                'https://img3.idealista.com/blur/WEB_LISTING-M/0/id.pro.es.image.master/88/73/d4/908040653.jpg',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ad.advertisementName,
                    style: theme.textTheme.headline6?.copyWith(
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children:[
                      Icon(Icons.arrow_circle_right_rounded, color: Colors.blueGrey), // Icon widget
                      SizedBox(width: 10),
                      Text(
                        ad.advertisementType ?? 'Empty Value',
                        style: theme.textTheme.subtitle1,
                        //add_home_work_outlined

                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  Text(
                    ad.advertisementDetails,
                    style: theme.textTheme.bodyText2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(
                          ad.isFavorite ? Icons.star : Icons.star_border,
                          color: ad.isFavorite ? Colors.amber : colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          setState(() {
                            ad.isFavorite = !ad.isFavorite;
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.article_outlined,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AdvertisementDetailsPage(ad: ad),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


