// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get_contacts/screens/sending%20options.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:share/share.dart';
// import 'package:contacts_service/contacts_service.dart';
// import 'package:permission_handler/permission_handler.dart';

// class ChatState extends StatefulWidget {
//   const ChatState({Key? key}) : super(key: key);

//   @override
//   _ChatStateState createState() => _ChatStateState();
// }

// class _ChatStateState extends State<ChatState> {
//   List<Image> images = [];
//   final ImagePicker _imagePicker = ImagePicker();
//   DateTime? _selectedDate;
//   TimeOfDay? _selectedTime;
//   String? _selectedCategory;
//   TextEditingController textController = TextEditingController();
//   bool _isSending = false;

//   final List<String> categories = [
//     'Birthday',
//     'Marriage',
//     'Start New Business',
//     'Business Success Party',
//   ];

//   void _inviting() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => ContactsPage(
//           eventCategory: _selectedCategory ?? '',
//           eventDate: _selectedDate != null
//               ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//               : 'No date selected',
//           eventTime: _selectedTime != null
//               ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
//               : 'No time selected',
//           enteredText: textController.text,
//         ),
//       ),
//     );
//   }

//   Future<void> _getImageFromSource(ImageSource source) async {
//     final XFile? pickedFile = await _imagePicker.pickImage(source: source);

//     if (pickedFile != null) {
//       setState(() {
//         images.add(Image.file(File(pickedFile.path)));
//       });
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: _selectedDate ?? DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );

//     if (pickedDate != null && pickedDate != _selectedDate) {
//       setState(() {
//         _selectedDate = pickedDate;
//       });
//     }
//   }

//   Future<void> _selectTime(BuildContext context) async {
//     final TimeOfDay? pickedTime = await showTimePicker(
//       context: context,
//       initialTime: _selectedTime ?? TimeOfDay.now(),
//     );

//     if (pickedTime != null && pickedTime != _selectedTime) {
//       setState(() {
//         _selectedTime = pickedTime;
//       });
//     }
//   }

//   void _shareInformation() {
//     String category = _selectedCategory ?? 'No category selected';
//     String date = _selectedDate != null
//         ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//         : 'No date selected';
//     String time = _selectedTime != null
//         ? "${_selectedTime!.hour}:${_selectedTime!.minute}"
//         : 'No time selected';

//     String enteredText = textController.text.isNotEmpty
//         ? 'Entered Text: ${textController.text}\n'
//         : '';

//     String text = '$enteredText'
//         'Event Category: $category\n'
//         'Event Date: $date\n'
//         'Event Time: $time\n';

//     Share.share(
//       text,
//       subject: 'Event Information',
//     );

//     Navigator.pop(context, {
//       'category': category,
//     });
//   }

//   void _submitInformation() {
//     Navigator.pop(context, {
//       'category': _selectedCategory ?? 'No category selected',
//       'date': _selectedDate != null
//           ? "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}"
//           : 'No date selected',
//       'time': _selectedTime ?? 'No time selected',
//       'enteredText ': textController.text,
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Event Creation'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               DropdownButton<String>(
//                 value: _selectedCategory,
//                 hint: const Text('Select Event Category'),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _selectedCategory = newValue;
//                   });
//                 },
//                 items: categories.map((String category) {
//                   return DropdownMenuItem<String>(
//                     value: category,
//                     child: Text(category),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 16),
//               Row(
//                 children: [
//                   Expanded(
//                     child: TextFormField(
//                       readOnly: true,
//                       onTap: () => _selectDate(context),
//                       decoration: InputDecoration(
//                         labelText: 'Select Date',
//                         suffixIcon: IconButton(
//                           onPressed: () => _selectDate(context),
//                           icon: const Icon(Icons.calendar_today),
//                         ),
//                       ),
//                       controller: _selectedDate != null
//                           ? TextEditingController(
//                               text:
//                                   "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
//                             )
//                           : null,
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: TextFormField(
//                       readOnly: true,
//                       onTap: () => _selectTime(context),
//                       decoration: InputDecoration(
//                         labelText: 'Select Time',
//                         suffixIcon: IconButton(
//                           onPressed: () => _selectTime(context),
//                           icon: const Icon(Icons.access_time),
//                         ),
//                       ),
//                       controller: _selectedTime != null
//                           ? TextEditingController(
//                               text:
//                                   "${_selectedTime!.hour}:${_selectedTime!.minute}",
//                             )
//                           : null,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 maxLength: 1000,
//                 maxLengthEnforcement: MaxLengthEnforcement.enforced,
//                 minLines: 3,
//                 maxLines: null,
//                 controller: textController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter text (3-1000 characters)',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//               const SizedBox(height: 16),
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: GestureDetector(
//                       onTap: () async {
//                         if (images.isEmpty) {
//                           await _getImageFromSource(ImageSource.gallery);
//                         }
//                       },
//                       child: Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(
//                             color: const Color.fromARGB(132, 0, 0, 0),
//                             width: 2.0,
//                           ),
//                           borderRadius: BorderRadius.circular(8.0),
//                         ),
//                         height: 150,
//                         width: 320, // Adjust this value to increase the height
//                         child: Center(
//                           child: images.isEmpty
//                               ? Text(
//                                   'Select Images',
//                                   style: TextStyle(fontSize: 16),
//                                   textAlign: TextAlign.center,
//                                 )
//                               : SingleChildScrollView(
//                                   scrollDirection: Axis.horizontal,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       for (var i = 0; i < images.length; i++)
//                                         GestureDetector(
//                                           onTap: () {
//                                             _viewImage(images[i], i);
//                                           },
//                                           child: Container(
//                                             margin: const EdgeInsets.all(4),
//                                             child: images[i],
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   if (images.isNotEmpty)
//                     Align(
//                       alignment: Alignment.bottomRight,
//                       child: FloatingActionButton(
//                         onPressed: () async {
//                           await _getImageFromSource(ImageSource.gallery);
//                         },
//                         child: Icon(Icons.add),
//                       ),
//                     ),
//                   const SizedBox(
//                     height: 17,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () {
//                           _submitInformation();
//                         },
//                         child: Text('Submit'),
//                       ),
//                       ElevatedButton(
//                           onPressed: _isSending ? null : _inviting,
//                           child: _isSending
//                               ? const SizedBox(
//                                   height: 16,
//                                   width: 16,
//                                   child: CircularProgressIndicator(),
//                                 )
//                               : const Text('invite')),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _viewImage(Image image, int index) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           content: Container(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   child: image,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         _removeImage(index);
//                         Navigator.pop(context);
//                       },
//                       child: Text('Remove'),
//                     ),
//                     SizedBox(width: 16),
//                     ElevatedButton(
//                       onPressed: () async {
//                         await _replaceImage(index);
//                         Navigator.pop(context);
//                       },
//                       child: Text('Replace'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void _removeImage(int index) {
//     setState(() {
//       images.removeAt(index);
//     });
//   }

//   Future<void> _replaceImage(int index) async {
//     final XFile? pickedFile =
//         await _imagePicker.pickImage(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       setState(() {
//         images[index] = Image.file(File(pickedFile.path));
//       });
//     }
//   }
// }

