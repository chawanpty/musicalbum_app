import 'package:flutter/material.dart';
import 'dart:io';
import 'album.dart';

class AlbumDetailScreen extends StatelessWidget {
  final Album album;
  final Function deleteAlbum;

  const AlbumDetailScreen({
    super.key,
    required this.album,
    required this.deleteAlbum,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(album.name),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child:
                    album.coverUrl.isNotEmpty &&
                            File(album.coverUrl).existsSync()
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(album.coverUrl),
                            width: 250,
                            height: 250,
                            fit: BoxFit.cover,
                          ),
                        )
                        : const Icon(
                          Icons.album,
                          size: 150,
                          color: Colors.white,
                        ),
              ),
              const SizedBox(height: 20),
              Text(
                "🎵 ศิลปิน: ${album.artist}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "📅 ปีที่ออก: ${album.year}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "📆 วันที่จำหน่าย: ${album.releaseDate.day}/${album.releaseDate.month}/${album.releaseDate.year}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "📌 ประเภท: ${album.genre}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "🎶 รายการเพลง",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              album.songs.isNotEmpty
                  ? ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: album.songs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.music_note),
                          title: Text(album.songs[index]),
                        ),
                      );
                    },
                  )
                  : const Center(
                    child: Text(
                      "ไม่มีเพลงในอัลบั้ม",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
