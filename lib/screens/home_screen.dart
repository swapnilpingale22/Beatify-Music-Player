import 'package:dribble_music_player_by_swapnil/controller/player_controller.dart';
import 'package:dribble_music_player_by_swapnil/screens/song_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';
import '../models/playlist_model.dart';
import '../widgets/song_card_2.dart';
import '../widgets/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  bool _hasPermission = false;

  @override
  void initState() {
    super.initState();
    checkAndRequestPermissions();
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );

    _hasPermission ? setState(() {}) : null;
  }

  @override
  Widget build(BuildContext context) {
    List<Playlist> playlists = Playlist.playlists;
    return Container(
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
      child: !_hasPermission
          ? noAccessToLibraryWidget()
          : Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const _CustomAppBar(),
              bottomNavigationBar: const _CustomNavBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    const _DiscoverMusic(),
                    const _TrendingMusic(),
                    _PlaylistMusic(playlists: playlists),
                  ],
                ),
              ),
            ),
    );
  }

  Widget noAccessToLibraryWidget() {
    return Scaffold(
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
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.redAccent.shade700.withOpacity(0.8),
                  Colors.redAccent.shade200.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 5,
                    spreadRadius: 2,
                    offset: const Offset(3, 3),
                    color: Colors.grey.shade700),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Player doesn't have Storage Permission to access the library!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      Colors.white,
                    ),
                  ),
                  onPressed: () => checkAndRequestPermissions(retry: true),
                  child: const Text(
                    "Allow",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PlaylistMusic extends StatelessWidget {
  const _PlaylistMusic({
    required this.playlists,
  });

  final List<Playlist> playlists;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SectionHeader(title: 'Playlists'),
          ListView.builder(
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: playlists.length,
            itemBuilder: (context, index) {
              return PlaylistCard(playlist: playlists[index]);
            },
          )
        ],
      ),
    );
  }
}

class _TrendingMusic extends StatelessWidget {
  const _TrendingMusic();

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(PlayerController());
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        top: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: SectionHeader(
              title: 'Trending Now',
              operation: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SongList(),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.26,
            child: FutureBuilder<List<SongModel>>(
              future: controller.audioQuery.querySongs(
                ignoreCase: true,
                sortType: SongSortType.DATE_ADDED,
                orderType: OrderType.DESC_OR_GREATER,
                uriType: UriType.EXTERNAL,
              ),
              builder: (context, snapshot) {
                var song2 = snapshot.data;
                if (song2 == null) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (song2.isEmpty) {
                  return const Center(
                    child: Text('No Songs Found'),
                  );
                } else {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: song2.length,
                    itemBuilder: (context, index) {
                      return SongCard2(
                        song2: song2[index],
                      );
                    },
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class _DiscoverMusic extends StatelessWidget {
  const _DiscoverMusic();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Welcome', style: Theme.of(context).textTheme.bodyLarge!),
          const SizedBox(height: 5),
          Text(
            'Enjoy your favourite music',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4,
                  spreadRadius: 2,
                  offset: Offset(2, 2),
                ),
              ],
            ),
            child: TextFormField(
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                hintText: 'Search',
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.grey.shade400),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey.shade400,
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide.none),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomNavBar extends StatefulWidget {
  const _CustomNavBar();

  @override
  State<_CustomNavBar> createState() => _CustomNavBarState();
}

class _CustomNavBarState extends State<_CustomNavBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: (index) {
        setState(() {
          selectedIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.deepPurple.shade800,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white38,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite_outline),
          label: 'Favourite',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.play_circle_outline),
          label: 'Play',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          label: 'Profile',
        ),
      ],
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String photoUrl =
        'https://images.unsplash.com/photo-1494232410401-ad00d5433cfa?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8bXVzaWN8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=10';
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: const Icon(
        Icons.grid_view_rounded,
        color: Colors.white,
      ),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 20),
          child: CircleAvatar(
            radius: 20,
            backgroundImage: CachedNetworkImageProvider(
              photoUrl,
              cacheKey: photoUrl,
              errorListener: () {
                const Icon(
                  Icons.signal_wifi_connected_no_internet_4,
                  color: Colors.deepPurple,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}
