import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongList extends StatefulWidget {
  const SongList({super.key});

  @override
  State<SongList> createState() => _SongListState();
}

class _SongListState extends State<SongList> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  String sortByName = "🔤  Sort by Name";
  String sortByDate = "📅  Sort by Date";
  String sortBySize = "📈  Sort by Size";
  String sortByAlbum = "📀  Sort by Album";
  String sortByArtist = "🙍‍♂️  Sort by Artist";
  String sortByDuration = "⌛  Sort by Duration";

  SongSortType dValue = SongSortType.TITLE;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All Music',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple.shade800.withOpacity(0.8),
        elevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SongSortType.TITLE,
                child: Text(sortByName),
              ),
              PopupMenuItem(
                value: SongSortType.DATE_ADDED,
                child: Text(sortByDate),
              ),
              PopupMenuItem(
                value: SongSortType.SIZE,
                child: Text(sortBySize),
              ),
              PopupMenuItem(
                value: SongSortType.ALBUM,
                child: Text(sortByAlbum),
              ),
              PopupMenuItem(
                value: SongSortType.ARTIST,
                child: Text(sortByArtist),
              ),
              PopupMenuItem(
                value: SongSortType.DURATION,
                child: Text(sortByDuration),
              ),
            ],
            onSelected: (SongSortType newValue) {
              setState(() {
                dValue = newValue;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.deepPurple.shade800.withOpacity(0.8),
              Colors.deepPurple.shade200.withOpacity(0.8),
            ],
          ),
        ),
        child: FutureBuilder<List<SongModel>>(
          future: _audioQuery.querySongs(
            sortType: dValue,
            orderType: (dValue == SongSortType.DATE_ADDED ||
                    dValue == SongSortType.DURATION ||
                    dValue == SongSortType.SIZE)
                ? OrderType.DESC_OR_GREATER
                : OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            var song2 = item.data;
            if (item.hasError) {
              return Text(item.error.toString());
            }

            if (item.data == null) {
              return const CircularProgressIndicator();
            }

            if (item.data!.isEmpty) return const Text("Nothing found!");

            return ListView.builder(
              itemCount: item.data!.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    bottom: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black45.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    onTap: () {
                      Get.toNamed('/song', arguments: song2![index]);
                    },
                    title: Text(
                      item.data![index].title,
                      maxLines: 1,
                    ),
                    subtitle: Text(
                      item.data![index].artist ?? "No Artist",
                      maxLines: 1,
                    ),
                    trailing: const Icon(
                      Icons.play_circle,
                      color: Colors.white60,
                    ),
                    leading: QueryArtworkWidget(
                      controller: _audioQuery,
                      id: item.data![index].id,
                      type: ArtworkType.AUDIO,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
