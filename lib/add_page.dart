import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'album.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _songController = TextEditingController();
  final List<String> _songs = [];
  File? _selectedImage;
  bool _isPickingImage = false; // 🔹 ตัวแปรป้องกันการเรียกซ้ำ

  String _name = '';
  String _artist = '';
  final int _year = DateTime.now().year;
  String _genre = 'Pop';
  DateTime? _releaseDate;

  final List<String> genres = ['Pop', 'Rock', 'Jazz', 'Hip-Hop', 'Classical'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _releaseDate = picked;
      });
    }
  }

  void _addSong() {
    if (_songController.text.isNotEmpty) {
      setState(() {
        _songs.add(_songController.text);
        _songController.clear();
      });
    }
  }

  Future<void> _pickImage() async {
    if (_isPickingImage) return; // 🔹 ป้องกันการเรียกซ้ำ
    _isPickingImage = true;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }

    _isPickingImage = false; // 🔹 รีเซ็ตสถานะหลังจากเลือกรูปเสร็จ
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('➕ เพิ่มอัลบั้มใหม่'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child:
                      _selectedImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _selectedImage!,
                              height: 200,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                          : Container(
                            height: 200,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                size: 100,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ชื่ออัลบั้ม'),
                  validator:
                      (value) => value!.isEmpty ? 'กรุณากรอกชื่ออัลบั้ม' : null,
                  onSaved: (value) => _name = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ศิลปิน'),
                  validator:
                      (value) => value!.isEmpty ? 'กรุณากรอกชื่อศิลปิน' : null,
                  onSaved: (value) => _artist = value!,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'ปีที่ออก'),
                  keyboardType: TextInputType.number,
                  initialValue: _year.toString(),
                  readOnly: true,
                ),
                DropdownButtonFormField(
                  decoration: const InputDecoration(labelText: 'ประเภทเพลง'),
                  value: _genre,
                  items:
                      genres.map((genre) {
                        return DropdownMenuItem(
                          value: genre,
                          child: Text(genre),
                        );
                      }).toList(),
                  onChanged:
                      (value) => setState(() => _genre = value.toString()),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _releaseDate == null
                          ? 'เลือกวันที่ออกจำหน่าย'
                          : 'วันที่ออก: ${_releaseDate!.day}/${_releaseDate!.month}/${_releaseDate!.year}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('เลือกวันที่'),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _songController,
                  decoration: const InputDecoration(labelText: "เพิ่มเพลง"),
                ),
                ElevatedButton(
                  onPressed: _addSong,
                  child: const Text("เพิ่มเพลง"),
                ),
                Column(children: _songs.map((song) => Text(song)).toList()),
                const SizedBox(height: 20),
                ElevatedButton(
                  child: const Text('บันทึกอัลบั้ม'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Navigator.pop(
                        context,
                        Album(
                          _name,
                          _artist,
                          _year,
                          _genre,
                          _releaseDate ?? DateTime.now(),
                          _songs.isNotEmpty ? _songs : [],
                          _selectedImage?.path ?? '',
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
