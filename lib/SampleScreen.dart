import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/services/question_ans_model.dart';
import 'package:flutter/material.dart';


class DisplayQuestionsPage extends StatefulWidget {
  @override
  _DisplayQuestionsPageState createState() => _DisplayQuestionsPageState();
}

class _DisplayQuestionsPageState extends State<DisplayQuestionsPage> {
  int upvotes = 6;
  int downvotes = 2;
  Color upvoteColor = Colors.grey;
  Color downvoteColor = Colors.grey;

  List<SoruCevap>? soruCeap;
  SoruCevapService _soruCevapService = SoruCevapService();

  @override
  void initState() {
    super.initState();
    fetchSoruCevap();
  }

  void fetchSoruCevap() async {
    soruCeap = await _soruCevapService.getSoruCevap();
    if (mounted) {
      setState(() {});
    }
  }

  void incrementUpvote() {
    setState(() {
      upvotes++;
      upvoteColor = Colors.blue; // Change color on upvote
      downvoteColor = Colors.grey;
    });
  }

  void incrementDownvote() {
    setState(() {
      downvotes++;
      downvoteColor = Colors.red; // Change color on downvote
      upvoteColor = Colors.grey;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
        elevation: 0, // Remove the shadow under the app bar
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: Colors.pink[50],
              child: ExpansionTile(
                title: Text('Have you ever tried to eat at a restaurant...'),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                        'Here is a detailed explanation about the question that can be expanded upon user interaction.'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up, color: upvoteColor),
                        onPressed: incrementUpvote,
                      ),
                      Text('$upvotes'),
                      IconButton(
                        icon: Icon(Icons.thumb_down, color: downvoteColor),
                        onPressed: incrementDownvote,
                      ),
                      Text('$downvotes'),
                      IconButton(
                        icon: Icon(Icons.comment, color: Colors.lightGreen),
                        onPressed: () {
                          // Action to open comments or add a comment
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class SoruCevapCard extends StatelessWidget {
  final SoruCevap soruCevap;

  SoruCevapCard({required this.soruCevap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 5,
      child: ExpansionTile(
        tilePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            'https://i.pinimg.com/564x/25/b0/f8/25b0f846698d82069e8d3086ca29aced.jpg',
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          soruCevap.soru,
          style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
        ),

      ),
    );
  }
}


