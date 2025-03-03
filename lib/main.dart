import 'package:flutter/material.dart';
import 'add_page.dart';
import 'album.dart';

void main() {
  runApp(AlbumApp());
}

class AlbumApp extends StatefulWidget {
  @override
  _AlbumAppState createState() => _AlbumAppState();
}

class _AlbumAppState extends State<AlbumApp> {
  List<Album> albums = [];

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

  HomePage({
    required this.albums,
    required this.addAlbum,
    required this.deleteAlbum,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🎵 อัลบั้มเพลงของฉัน')),
      body:
          albums.isEmpty
              ? Center(
                child: Text(
                  'ยังไม่มีอัลบั้มเพลง',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                itemCount: albums.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(albums[index].name),
                    onDismissed: (direction) => deleteAlbum(index),
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    child: ListTile(
                      title: Text(
                        albums[index].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        'ศิลปิน: ${albums[index].artist} | ปี: ${albums[index].year}\n'
                        'ประเภท: ${albums[index].genre} | วันที่ออก: ${albums[index].releaseDate.day}/${albums[index].releaseDate.month}/${albums[index].releaseDate.year}',
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newAlbum = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPage()),
          );
          if (newAlbum != null) addAlbum(newAlbum);
        },
      ),
    );
  }
}
