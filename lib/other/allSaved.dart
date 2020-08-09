import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_map/services/CrudMarkers.dart';

class AllSaved extends StatefulWidget {
  AllSaved({Key key}) : super(key: key);

  @override
  _AllSavedState createState() => _AllSavedState();
}

class _AllSavedState extends State<AllSaved> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("All Markers"),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: StreamBuilder(
          stream:
              Firestore.instance.collection(currUser + "_parking").snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            else {
              return ListView.builder(
                padding: EdgeInsets.all(10.0),
                itemCount: snapshot.data.documents.length,
                itemBuilder: (builder, int index) {
                  return Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple[100],
                          Colors.deepPurple[200],
                          Colors.deepPurple[100],
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height / 4,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: snapshot.data.documents[index]['image'] !=
                                      null
                                  ? NetworkImage(
                                      snapshot.data.documents[index]['image'],
                                    )
                                  : NetworkImage(
                                      "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAQMAAADDCAMAAACxkIT5AAAASFBMVEVUVFSoqKhOTk5RUVGrq6tzc3OZmZmFhYWwsLBMTEyXl5etra1vb29+fn6Li4uTk5NiYmJnZ2dbW1uhoaGAgIBeXl5ycnJsbGwxLNHVAAAEr0lEQVR4nO2cDZeiIBSG4V4ElQSVJv//P13ATPuY2Wlqzy7u+5wzk0l2uk9cQEOEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFAaTO+H/3ZQz8GTfj9TWRK4svLd2Ko0B+rtDhQcwAEcwAEcwAEcwAEcwAEcwMGuHahuiYLMXbly9OXBcLBDBwwHcCDgIJfDARyI/9tBwzPNIweXwj07kK1Z0PeF+lLo9+xAqoWnC/fj4BXgAA7gAA7gAA7gAA7gAA7gAA7gAA7gAA7g4P90kK6a2ZnPL6Dt10EMXgbvuuowDcMwHarO+SDt1yL25CDG77tepMn4K/GZ6DsfPezfgbLBDCn6RwdFE4MJn2nYiQNl/dQ8jP9yIDeTf2xhFw6UcuM3bkZhGt2jlmEPDqwf6fdHZmj09/eAlO/A6v7GwNwSnm9Vug2Pen1roXQHSlZXWRCjF0N1dL7VWrfeHavYUfD1Kyqp9uTAtuPm8zOJg8vDgXPa59GS1GbirSgeW7sfB7Zr1iKi0yfDgDRwOGwtNN1WQskOlFxbgtjmmy/HQVaaTd9B/SYfCnagtNjE5H97YhDHEBtnQq9vVKwD6y8BpR7vO6eTatuL0qWXLNaBdUtTwGS+cXJ4DleZS0I0zpbtQJlFAQ3hmUsKKgxLVVjmLhXrYAmEzLM3/1pzObZwB/PHZvFUJViqwnlQwXtwcNXFPSFBzvmwBwd0+OnFRXVKEnbggF5YB8BWtAcHryhIw2wq38FrCnJNKN0BTa8uiGGn0vvGj9d/a1neo1QHP+oT7yTIsh28ETiAAziAAziAAziAAziAAzjYiwOsIclTePtSoqGwtUSxpiwAAABwQ5p8lx7m31wpTzjj607u/DRv8byT55/b0/a6gx9OYPz34aH1KWrXsWDhggyG+aDbjB5yeNP85EPQSUvZDhSP0ulg8h2za0+clm2n+FZt683tDM9/Hz5YeWRBMXQxqlBNnQw8GGNCMMb1+SWVTeu/uJFM7aaDryvmU51KKDimEGR0cKobPtTHo9O1L01CdFApkR2QDrEm06hcfGhav8xbj6dVnO9gGOqqSasF2TGGm0ryUaGTsTacbHIQs6GZ1nkphRAdNNJQjIbGOp/rkJEpy1u/WQkqZTqTC/OcJdvRlYNOLQ7yzs7+lUh+TnJQ1SmaGNeY90zp8cqB9ZFDE+ZdMQOaKwckj7Q6EGN9KKtdjA4oBRUdVHMIscr3tw6cc8nBvEgYaX/joLKbeiBEXdq5c3SQPrw2NNUf8567enDOhbUeXOdC/DPT6uCjHspzIOI3HB2IOq8UR+6uPZgTPBbkXaOtaMh5E5MgO4i1oLo4aIwqS8HsgAebvlEvx/ht9/XxsQPua5P6BS/jE3tsOJqYsoMoMahzv0BdaamQan6OuI7jAxGU6VzdpuBj0t86iC1+rbtjsLGq87F2nUlTnEmm0dVkcz3wvs0Tkwqjd5z/p7acu1b7ah47d+u3OZjzBvVOazPO0/i8blPu8DFdOaNjdNinoVQlCqsFifNAKD/weiFsO+6/bG7Ll01e/+ebQP/8JwYAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADwB/gFh35K7dZjp9sAAAAASUVORK5CYII="),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              snapshot.data.documents[index]['about'] +
                                  "\n" +
                                  snapshot.data.documents[index]['label'],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w700),
                            ),
                            Column(
                              children: [
                                Text(
                                  snapshot.data.documents[index]['coords']
                                          .latitude
                                          .toString() +
                                      " N",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic),
                                ),
                                Text(
                                  snapshot.data.documents[index]['coords']
                                          .longitude
                                          .toString() +
                                      " S",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontStyle: FontStyle.italic),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
