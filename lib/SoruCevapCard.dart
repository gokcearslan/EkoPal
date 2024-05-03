import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';

import 'colors.dart';

class SoruCevapCard extends StatefulWidget {
  final SoruCevap soruCevap;

  SoruCevapCard({required this.soruCevap});

  @override
  _SoruCevapCardState createState() => _SoruCevapCardState();
}


class _SoruCevapCardState extends State<SoruCevapCard> {

  @override
  Widget build(BuildContext context) {
    // Format the DateTime object to a readable string
    //String formattedDate = DateFormat('MMMM d, yyyy – h:mm a').format(widget.soruCevap.postedTime);
    String formattedDate="2 days ago";
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      color:cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            title: Text('Default User', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(formattedDate),  // Display the formatted date as subtitle
          ),
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              'https://cdn.vectorstock.com/i/500p/28/89/a-question-mark-symbol-vector-1122889.jpg',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.soruCevap.soru,
              style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Text(widget.soruCevap.soruDetails),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Action to add a comment or perform another task
              },
              icon: Icon(Icons.comment),
              label: Text('Yanıtla'),
              style: ElevatedButton.styleFrom(
                foregroundColor: textColor,
                backgroundColor: buttonColor1, // Background color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                minimumSize: Size(double.infinity, 36),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
