import 'package:dribble_music_player_by_swapnil/models/song_model.dart';

class Playlist {
  final String title;
  final List<Song> songs;
  final String imageUrl;

  Playlist({
    required this.title,
    required this.songs,
    required this.imageUrl,
  });

  static List<Playlist> playlists = [
    Playlist(
      title: 'Hip-Hop R&B Mix',
      songs: Song.songs,
      imageUrl:
          'https://images.unsplash.com/photo-1445985543470-41fba5c3144a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8bXVzaWMlMjBjb3ZlciUyMHIlMjAlMjYlMjBCfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=10',
    ),
    Playlist(
      title: 'Rock & Roll',
      songs: Song.songs,
      imageUrl:
          'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fG11c2ljJTIwY292ZXIlMjByb2NrfGVufDB8fDB8fHww&auto=format&fit=crop&w=500&q=10',
    ),
    Playlist(
      title: 'Techno',
      songs: Song.songs,
      imageUrl:
          'https://images.unsplash.com/photo-1516981442399-a91139e20ff8?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OXx8bXVzaWMlMjBjb3ZlciUyMGhpcCUyMGhvcHxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=500&q=10',
    ),
  ];
}
