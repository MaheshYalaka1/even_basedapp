import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_contacts/screens/sending%20options.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class ChatState extends StatefulWidget {
  const ChatState({Key? key}) : super(key: key);

  @override
  _ChatStateState createState() => _ChatStateState();
}

class _ChatStateState extends State<ChatState> {
  List<Image> images = [];
  final ImagePicker _imagePicker = ImagePicker();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedCategory;
  TextEditingController textController = TextEditingController();
  bool _isSending = false;
  bool _isVideoVisible = false;
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  final List<String> categories = [
    'Birthday',
    'Marriage',
    'Start New Business',
    'Business Success Party',
  ];

  List<VideoPlayerWidget> videoPlayers = [];
  final String sampleVideoUrl =
      "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4";

  void _inviting() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ContactsPage(
          eventCategory: _selectedCategory ?? '',
          eventDate: _selectedDate != null
              ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
              : 'No date selected',
          eventTime: _selectedTime != null
              ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
              : 'No time selected',
          enteredText: textController.text,
          videoUrl: sampleVideoUrl,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(sampleVideoUrl);
    _initializeVideoPlayerFuture =
        _videoPlayerController.initialize().then((_) {
      setState(() {}); // Rebuild the widget when the video playback changes
    });
  }

  Future<void> _getImageFromSource(ImageSource source) async {
    final XFile? pickedFile = await _imagePicker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        images.add(Image.file(File(pickedFile.path)));
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _submitInformation() {
    Navigator.pop(context, {
      'category': _selectedCategory ?? 'No category selected',
      'date': _selectedDate != null
          ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
          : 'No date selected',
      'time': _selectedTime ?? 'No time selected',
      'enteredText ': textController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Creation'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButton<String>(
                value: _selectedCategory,
                hint: const Text('Select Event Category'),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: categories.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: InputDecoration(
                        labelText: 'Select Date',
                        suffixIcon: IconButton(
                          onPressed: () => _selectDate(context),
                          icon: const Icon(Icons.calendar_today),
                        ),
                      ),
                      controller: _selectedDate != null
                          ? TextEditingController(
                              text:
                                  "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      onTap: () => _selectTime(context),
                      decoration: InputDecoration(
                        labelText: 'Select Time',
                        suffixIcon: IconButton(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                        ),
                      ),
                      controller: _selectedTime != null
                          ? TextEditingController(
                              text:
                                  "${_selectedTime!.hour}:${_selectedTime!.minute}",
                            )
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                maxLength: 1000,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                minLines: 3,
                maxLines: null,
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Enter text (3-1000 characters)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: GestureDetector(
                      onTap: () async {
                        if (images.isEmpty) {
                          await _getImageFromSource(ImageSource.gallery);
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: const Color.fromARGB(132, 0, 0, 0),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        height: 150,
                        width: 320, // Adjust this value to increase the height
                        child: Center(
                          child: images.isEmpty
                              ? Text(
                                  'Select Images',
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                )
                              : SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      for (var i = 0; i < images.length; i++)
                                        GestureDetector(
                                          onTap: () {
                                            _viewImage(images[i], i);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4),
                                            child: images[i],
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (images.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () async {
                          await _getImageFromSource(ImageSource.gallery);
                        },
                        child: Icon(Icons.add),
                      ),
                    ),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _submitInformation();
                        },
                        child: Text('Submit'),
                      ),
                      ElevatedButton(
                          onPressed: _isSending ? null : _inviting,
                          child: _isSending
                              ? const SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(),
                                )
                              : const Text('invite')),
                    ],
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isVideoVisible = true;
                  });
                  _videoPlayerController.play();
                },
                child: Text('See Video'),
              ),
              if (_isVideoVisible)
                Column(
                  children: [
                    SizedBox(height: 16),
                    FutureBuilder(
                      future: _initializeVideoPlayerFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return AspectRatio(
                            aspectRatio:
                                _videoPlayerController.value.aspectRatio,
                            child: VideoPlayer(_videoPlayerController),
                          );
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (_videoPlayerController.value.isPlaying) {
                                _videoPlayerController.pause();
                              } else {
                                _videoPlayerController.play();
                              }
                            });
                          },
                          icon: Icon(
                            _videoPlayerController.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isVideoVisible = false;
                            });
                            _videoPlayerController.pause();
                          },
                          child: Text('Close Video'),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewImage(Image image, int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: image,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _removeImage(index);
                        Navigator.pop(context);
                      },
                      child: Text('Remove'),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () async {
                        await _replaceImage(index);
                        Navigator.pop(context);
                      },
                      child: Text('Replace'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _removeImage(int index) {
    setState(() {
      images.removeAt(index);
    });
  }

  Future<void> _replaceImage(int index) async {
    final XFile? pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images[index] = Image.file(File(pickedFile.path));
      });
    }
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoURL;

  const VideoPlayerWidget({Key? key, required this.videoURL}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _videoPlayerController;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.videoURL);
    _initializeVideoPlayerFuture = _videoPlayerController.initialize();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: _videoPlayerController.value.aspectRatio,
            child: VideoPlayer(_videoPlayerController),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
