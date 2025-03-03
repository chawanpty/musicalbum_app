class Album {
  final String name;
  final String artist;
  final int year;
  final String genre;
  final DateTime releaseDate;
  final List<String> songs;
  final String coverUrl; // ✅ เพิ่มปกอัลบั้ม

  Album(
    this.name,
    this.artist,
    this.year,
    this.genre,
    this.releaseDate,
    List<String>? songs,
    this.coverUrl,
  ) : songs = songs ?? [];
}
