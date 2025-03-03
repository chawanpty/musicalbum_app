import 'package:flutter/material.dart';
import 'album.dart';

class AddPage extends StatefulWidget {
  @override
  _AddPageState createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _artist = '';
  int _year = DateTime.now().year;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('➕ เพิ่มอัลบั้มใหม่')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'ชื่ออัลบั้ม'),
                validator:
                    (value) => value!.isEmpty ? 'กรุณากรอกชื่ออัลบั้ม' : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ศิลปิน'),
                validator:
                    (value) => value!.isEmpty ? 'กรุณากรอกชื่อศิลปิน' : null,
                onSaved: (value) => _artist = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'ปีที่ออก'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) return 'กรุณากรอกปีที่ออก';
                  int? year = int.tryParse(value);
                  if (year == null ||
                      year < 1900 ||
                      year > DateTime.now().year) {
                    return 'ปีที่ออกไม่ถูกต้อง';
                  }
                  return null;
                },
                onSaved: (value) => _year = int.parse(value!),
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: 'ประเภทเพลง'),
                value: _genre,
                items:
                    genres.map((genre) {
                      return DropdownMenuItem(value: genre, child: Text(genre));
                    }).toList(),
                onChanged: (value) => setState(() => _genre = value.toString()),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _releaseDate == null
                        ? 'เลือกวันที่ออกจำหน่าย'
                        : 'วันที่ออก: ${_releaseDate!.day}/${_releaseDate!.month}/${_releaseDate!.year}',
                    style: TextStyle(fontSize: 16),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('เลือกวันที่'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('บันทึกอัลบั้ม'),
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
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
