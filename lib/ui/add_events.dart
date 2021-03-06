import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../model/event.dart';
import '../model/eventData.dart';

class AddEvents extends StatefulWidget {
  @override
  _AddEventsState createState() => _AddEventsState();
}

class _AddEventsState extends State<AddEvents> {
  String eventTitle;
  String eventNote;
  File image;
  final picker = ImagePicker();

  Future getImage(ImageSource source) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  List<Map<String, dynamic>> imageFrom = [
    {
      "title": "Camera",
      "source": ImageSource.camera,
    },
    {
      "title": "From Gallery",
      "source": ImageSource.gallery,
    }
  ];

  List<String> events = [
    'Anniversary',
    'Announcement',
    'Birthday',
    'Concert',
    'Convention',
    'Examination',
    'Flight',
    'Holiday',
    'Movie/TV',
    'Party',
    'Religious',
    'Trip',
    'Others',
  ];

  String selectedEvent;
  String selectedImageFrom;
  DateTime selectedDate;
  final TextEditingController _controller = new TextEditingController();

  Future _selectDayAndTime(BuildContext context) async {
    DateTime _selectedDay = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2018),
        lastDate: DateTime(2030),
        builder: (BuildContext context, Widget child) => child);

    TimeOfDay _selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (_selectedDay != null && _selectedTime != null) {
      setState(() {
        selectedDate = DateTime(
          _selectedDay.year,
          _selectedDay.month,
          _selectedDay.day,
          _selectedTime.hour,
          _selectedTime.minute,
        );
      });
    }
  }

  DropdownButton dropdown(List<String> listedItem, String selected,
      List<DropdownMenuItem<String>> dropdownItems) {
    try {
      for (String item in listedItem) {
        var newItem = DropdownMenuItem(
          child: Text(item),
          value: item,
        );
        dropdownItems.add(newItem);
      }
    } catch (e) {
      print(e);
    }
    return DropdownButton<String>(
      underline: SizedBox.shrink(),
      value: selected,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          if (selected == selectedEvent) {
            selectedEvent = value;
          } else {
            selectedImageFrom = value;
          }
        });
      },
    );
  }

  DropdownButton imageSource() {
    List<DropdownMenuItem> imageDropdownItems = [];
    try {
      for (var item in imageFrom) {
        var newItem = DropdownMenuItem(
          child: Text(item["title"]),
          value: item,
          onTap: () {
            getImage(item["source"]);
          },
        );
        imageDropdownItems.add(newItem);
      }
    } catch (e) {
      print(e);
    }
    return DropdownButton(
      underline: SizedBox.shrink(),
      value: selectedImageFrom,
      items: imageDropdownItems,
      onChanged: (value) {
        setState(() {
          selectedImageFrom = value;
        });
      },
    );
  }

  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var eventData = Provider.of<EventData>(context);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.height / 1.4,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xffFCA532),
                    Color(0xffF4526A),
                  ],
                  stops: [
                    0.02,
                    1.0,
                  ],
                ),
              ),
              padding: EdgeInsets.fromLTRB(18.0, 25.0, 20.0, 50.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      Row(
                        children: [
                          Stack(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.calendar_today),
                                  onPressed: () {}),
                              Padding(
                                padding: const EdgeInsets.only(top: 2.0),
                                child: IconButton(
                                    icon: Icon(Icons.add, size: 15.0),
                                    onPressed: () {}),
                              ),
                            ],
                          ),
                          IconButton(
                              icon: Icon(Icons.more_vert_rounded),
                              onPressed: () {}),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("New Event",
                        style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      "Add an upcoming event",
                      style: TextStyle(
                          color: Color(0xffFAFAFA),
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: MediaQuery.of(context).size.height / 1.4,
                padding: EdgeInsets.all(10.0),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      leading: Icon(Icons.edit),
                      title: TextField(
                        //  controller: controller,
                        onChanged: (value) {
                          setState(() {
                            eventTitle = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: "Title",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    CustomDivider(),
                    ListTile(
                      leading: Icon(Icons.celebration),
                      title: Text("Event"),
                      trailing: dropdown(events, selectedEvent, []),
                    ),
                    CustomDivider(),
                    ListTile(
                        leading: Icon(Icons.event),
                        title: Text("Date"),
                        trailing: InkWell(
                          onTap: () {
                            _selectDayAndTime(context);
                          },
                          child: selectedDate != null
                              ? Text("${selectedDate.toLocal()}".split(' ')[0])
                              : Text("SELECT DATE"),
                        )),
                    CustomDivider(),
                    ListTile(
                      leading: Icon(Icons.repeat_rounded),
                      title: Text("Repeat"),
                      trailing:
                          InkWell(child: Text("ADD REPEAT"), onTap: () {}),
                    ),
                    CustomDivider(),
                    ListTile(
                      leading: Icon(Icons.add_a_photo),
                      title: Text("Photo"),
                      trailing: imageSource(),
                    ),
                    CustomDivider(),
                    ListTile(
                      leading: Icon(Icons.audiotrack_rounded),
                      title: Text("Song"),
                      trailing: InkWell(child: Text("ADD SONG"), onTap: () {}),
                    ),
                    CustomDivider(),
                    ListTile(
                      leading: Icon(Icons.note),
                      title: Text("Note"),
                      trailing: InkWell(
                          child: eventNote == null
                              ? Text("ADD NOTE")
                              : Text("NOTE ADDED"),
                          onTap: () {
                            return showDialog<void>(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    actions: [
                                      InkWell(
                                        child: Text("Cancel",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onTap: () {
                                          _controller.clear();
                                          Navigator.pop(context);
                                        },
                                      ),
                                      InkWell(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10.0),
                                          child: Text(
                                            "Ok",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Scaffold.of(context)
                                              .showSnackBar(SnackBar(
                                                behavior: SnackBarBehavior.floating,
                                            content: Text("Note added!"),
                                          ));
                                        },
                                      )
                                    ],
                                    title: Text("Note"),
                                    contentPadding: EdgeInsets.all(10.0),
                                    content: Container(
                                      padding: EdgeInsets.all(5.0),
                                      height: 200.0,
                                      // width: 100.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey),
                                      ),
                                      child: TextField(
                                        controller: controller,
                                        maxLines: null,
                                        onChanged: (value) {
                                          setState(() {
                                            eventNote = value;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          hintText: "Note",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ),
                    Align(
                        alignment: Alignment.centerRight,
                        child: RaisedButton(
                          onPressed: () {
                            if (eventTitle != null && selectedDate != null) {
                              eventData.addNewCard(Event(
                                title: eventTitle,
                                date: selectedDate,
                                note: eventNote,
                                imagePath: image.path,
                              ));
                            }
                            Navigator.pop(context);
                          },
                          child: Text(
                            "ADD EVENT",
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Color(0xffFCA532),
                        ))
                  ],
                ))
          ],
        ),
      ),
    );
  }
}

class CustomDivider extends StatelessWidget {
  const CustomDivider({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 1.0,
        margin: EdgeInsetsDirectional.only(start: 0.0, end: 0.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1.0),
          ),
        ),
      ),
    );
  }
}
