import 'package:flutter/material.dart';
import 'package:ekopal/services/event_model.dart';
import 'package:ekopal/services/firebase_service.dart';
import 'package:ekopal/detailed_event_page.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  List<Event>? events;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  fetchEvents() async {
    events = await EventService().getEvents();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events'),
      ),
      body: events == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: events!.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to detailed event page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailedEventPage(event: events![index]),
                ),
              );
            },
            child: buildEventCard(events![index]),
          );
        },
      ),
    );
  }

  Widget buildEventCard(Event event) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: ListTile(
        title: Text(event.eventName),
        subtitle: Text(event.eventDate),
        trailing: Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
