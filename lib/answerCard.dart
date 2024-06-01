import 'package:ekopal/services/UserManager.dart';
import 'package:ekopal/services/answer_model.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class AnswerCard extends StatefulWidget {
  final Answer answer;

  AnswerCard({required this.answer});

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  String? imageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfilePicture();
  }

  Future<void> _loadProfilePicture() async {
    String? url = await UserManager().getProfilePictureUrl(widget.answer.createdBy);
    setState(() {
      imageUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {

    String timestamp = widget.answer.timestamp.toString().substring(0, 10);
    List<String> parts = timestamp.split('-');
    String formattedDate = '${parts[2]}-${parts[1]}-${parts[0]}';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 28.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(28),
      ),
      elevation: 2,
      color: cardColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: imageUrl != null
                    ? NetworkImage(imageUrl!)
                    : NetworkImage('https://cdn-icons-png.flaticon.com/256/12989/12989000.png'),
              ),
              title: Text(
                widget.answer.createdBy,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(formattedDate),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: Text(
                widget.answer.answer,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
