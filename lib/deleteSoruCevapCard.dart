import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';
import 'colors.dart';
import 'answer_toquestion_page.dart';
import 'display_answers_page.dart';

class deleteSoruCevapCard extends StatefulWidget {
  final SoruCevap soruCevap;
  final VoidCallback onDelete;

  deleteSoruCevapCard({required this.soruCevap, required this.onDelete});

  @override
  _deleteSoruCevapCardState createState() => _deleteSoruCevapCardState();
}

class _deleteSoruCevapCardState extends State<deleteSoruCevapCard> {
  String? imageUrl;
  final SoruCevapService _soruCevapService = SoruCevapService();

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

  Future<void> _deleteQuestion() async {
    String? questionId = await _soruCevapService.findQuestionId(
      widget.soruCevap.soru,
      widget.soruCevap.soruDetails,
      widget.soruCevap.createdBy,
    );

    if (questionId != null) {
      await _soruCevapService.deleteQuestion(questionId).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Soru başarıyla silindi")));
        widget.onDelete();
      }).catchError((error) {
        print("Silme sırasında bir hata oluştu: $error");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Silme sırasında bir hata oluştu')));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = "2 days ago";
    const String defaultImageUrl = 'https://cdn-icons-png.flaticon.com/256/12989/12989000.png';

    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      color: cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : NetworkImage(defaultImageUrl),
            ),
            title: Text(widget.soruCevap.createdBy, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(formattedDate),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.deepPurple),
              onPressed: _deleteQuestion,
            ),
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
