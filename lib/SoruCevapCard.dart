import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';
import 'answer_toquestion_page.dart';
import 'colors.dart';
import 'display_answers_page.dart';

class SoruCevapCard extends StatefulWidget {
  final SoruCevap soruCevap;

  SoruCevapCard({required this.soruCevap});

  @override
  _SoruCevapCardState createState() => _SoruCevapCardState();
}


class _SoruCevapCardState extends State<SoruCevapCard> {
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
          ),
          SizedBox(height: 6),

          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            child: Image.network(
              'https://i.pinimg.com/564x/86/d1/07/86d107cbbcf8f527bc9fcc374764a36a.jpg',
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
                    icon: Icon(Icons.comment, color: textColor),
                    label: Text('Yanıt Ekle', style: TextStyle(color: textColor)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => QuestionDetailsPage(question: widget.soruCevap)),
                      );
                    },
                    icon: Icon(Icons.visibility, color: textColor),
                    label: Text('Yanıtları Gör', style: TextStyle(color: textColor)),
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),

        ],
      ),
    );
  }
}
