import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';

import 'answer_toquestion_page.dart';
import 'colors.dart';
import 'display_answers_page.dart';

class displayAllAnswersCard extends StatefulWidget {
  final SoruCevap soruCevap;

  displayAllAnswersCard({required this.soruCevap});

  @override
  _displayAllAnswersCardState createState() => _displayAllAnswersCardState();
}


class _displayAllAnswersCardState extends State<displayAllAnswersCard> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    String? url = await UserManager().getProfilePictureUrl(widget.soruCevap.userId);
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format the DateTime object to a readable string
    //String formattedDate = DateFormat('MMMM d, yyyy – h:mm a').format(widget.soruCevap.postedTime);
    String formattedDate="2 days ago";
    const String defaultImageUrl = 'https://cdn-icons-png.flaticon.com/256/12989/12989000.png';

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 5,
      color:cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: imageUrl != null
                  ? NetworkImage(imageUrl!)
                  : NetworkImage(defaultImageUrl),
            ),
            title: Text( widget.soruCevap.createdBy,
                style: TextStyle(fontWeight: FontWeight.bold)),
            //subtitle: Text(formattedDate),  // Display the formatted date as subtitle
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
            child: Row(
              children: [
                Expanded(


                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateAnswerPage(question: widget.soruCevap)),
                      );
                    },
                    icon: Icon(Icons.add_comment, color: textColor),
                    label: Text('Yanıtla', style: TextStyle(color: textColor)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
          ),
          SizedBox(height: 4),

        ],
      ),
    );
  }
}
