import 'package:flutter/material.dart';
import 'add_page.dart';
import 'album.dart';
import 'album_detail_screen.dart';
import 'dart:io';

void main() {
  runApp(const AlbumApp());
}

class AlbumApp extends StatefulWidget {
  const AlbumApp({Key? key}) : super(key: key);

  @override
  _AlbumAppState createState() => _AlbumAppState();
}

class _AlbumAppState extends State<AlbumApp> {
  final List<Album> albums = [];

  void addAlbum(Album album) {
    setState(() {
      albums.add(album);
    });
  }

  void deleteAlbum(int index) {
    setState(() {
      albums.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomePage(
        albums: albums,
        addAlbum: addAlbum,
        deleteAlbum: deleteAlbum,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Album> albums;
  final Function addAlbum;
  final Function deleteAlbum;

  const HomePage({
    super.key,
    required this.albums,
    required this.addAlbum,
    required this.deleteAlbum,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎵 อัลบั้มเพลงของฉัน'),
        backgroundColor: Colors.deepPurple,
      ),
      body: albums.isEmpty
          ? const Center(
              child: Text(
                'ยังไม่มีอัลบั้มเพลง',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetailScreen(
                            album: albums[index],
                            deleteAlbum: () => deleteAlbum(index),
                          ),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          Expanded(
                            child: albums[index].coverUrl.isNotEmpty &&
                                    File(albums[index].coverUrl).existsSync()
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(12),
                                      topRight: Radius.circular(12),
                                    ),
                                    child: Image.file(
                                      File(albums[index].coverUrl),
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Icon(
                                    Icons.album,
                                    size: 80,
                                    color: Colors.white,
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text(
                                  albums[index].name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  albums[index].artist,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
        onPressed: () async {
          final newAlbum = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPage()),
          );
          if (newAlbum != null) {
            addAlbum(newAlbum as Album);
          }
        },
      ),
    );
  }
}
