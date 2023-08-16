// import 'package:on_audio_query/on_audio_query.dart';

class Song {
  final String title;
  final String description;
  final String url;
  final String coverUrl;

  Song({
    required this.title,
    required this.description,
    required this.url,
    required this.coverUrl,
  });

  static List<Song> songs = [
  // static List<SongModel> songs = [
    Song(
      title: 'On & On',
      description: 'Cartoon - On & On (feat. Daniel Levi)',
      url: 'assets/music/Cartoon - On & On (feat. Daniel Levi).mp3',
      coverUrl: 'assets/images/onAndOn.png',
    ),
    Song(
      title: ' Cold Water',
      description: 'Major Lazer - Cold Water (feat. Justin Bieber & MØ)',
      url:
          'assets/music/Major Lazer - Cold Water (feat. Justin Bieber & MØ).mp3',
      coverUrl: 'assets/images/coldWater.png',
    ),
    Song(
      title: 'See You Again',
      description: 'See You Again',
      url: 'assets/music/See You Again.mp3',
      coverUrl: 'assets/images/seeYouAgain.png',
    ),
  ];
}
