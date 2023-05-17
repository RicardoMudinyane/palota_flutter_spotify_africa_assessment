import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_spotify_africa_assessment/colors.dart';
import 'package:flutter_spotify_africa_assessment/objects.dart';
import 'package:flutter_spotify_africa_assessment/routes.dart';
import 'package:http/http.dart' as http;

// TODO: fetch and populate playlist info and allow for click-through to detail
// Feel free to change this to a stateful widget if necessary

enum SortOrder {
  ascending,
  descending,
}

class SpotifyCategory extends StatefulWidget {
  final String categoryId;

  const SpotifyCategory({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  State<SpotifyCategory> createState() => _SpotifyCategoryState();
}

class _SpotifyCategoryState extends State<SpotifyCategory> {

  final ScrollController _scrollController = ScrollController();

  final String clientId = '42cea7baf90842b682ad6b233f5b2fa9';
  final String clientSecret = '84fd6a7fe55f4d4dbbdf18e906bce2b4';

  final String apiKey = "_q6Qaip9V-PShHzF8q9l5yexp-z9IqwZB_o_6x882ts3AzFuo0DxuQ==";

  PlaylistCategory? playlistCategory;
  List<PlaylistDetails> playlists = [];
  List<PlaylistDetails> filteredData = [];


  List<PlaylistDetails> tempList = [];

  int returnIndex = 0;

  bool isLoading = false;
  bool isSearching = false;

  String searchQuery = '';
  SortOrder sortOrder = SortOrder.ascending;

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    fetchCategoryID();
    super.initState();
  }



  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();

    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent && !isLoading) {
      returnIndex = returnIndex + 20;
      fetchPlaylists();
    }
  }

  void filterData() {
    playlists = tempList.where((item) => item.name.toLowerCase().contains(searchQuery)).toList();
  }
  void _onSearch(String value) {
    setState(() {
      searchQuery = value.toLowerCase();
      filterData();
    });
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isSearching ?
        TextField(
          onChanged: _onSearch,
          decoration: const InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          style: const TextStyle(color: Colors.white),
        ) :
        Text(widget.categoryId),
        actions: [
          IconButton(
            icon: isSearching ? const Icon(Icons.cancel) : const Icon(Icons.search),
            onPressed: () {
              setState(() {
                if (isSearching) {
                  playlists = tempList;
                  isSearching = false;
                  searchQuery = '';
                  filterData();
                } else {
                  tempList = playlists;
                  isSearching = true;
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () =>  Navigator.of(context).pushNamed(AppRoutes.about),
          ),
        ],
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.blue,
                AppColors.cyan,
                AppColors.green,
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric (
              vertical: 10
            ).copyWith(left: 10, top: 20),
            sliver: SliverToBoxAdapter(
              child: Container(
                  width: width*.95,
                  height: height*.085,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Theme.of(context).hoverColor,
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(10))
                  ),
                  child: Row(
                    children: [
                      playlistCategory != null ?
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          playlistCategory!.image ,
                          fit: BoxFit.cover,
                          height: height*.085,
                          width: height*.075,
                        )
                      ):
                      Container(
                        height: height*.085,
                        width: height*.075,
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(16),
                        child: const CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Afro ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 28
                                  )
                              ),
                              TextSpan(
                                  text: 'Playlists',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 28
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(10),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 1/1.115,
                crossAxisCount: 2,
                crossAxisSpacing: 15.0,
                mainAxisSpacing: 15.0,
              ),
              delegate: SliverChildBuilderDelegate(
                childCount: playlists.length, (context, index){
                return GestureDetector(
                  onTap: ()=> Navigator.of(context).pushNamed(
                    AppRoutes.spotifyPlaylist,
                    arguments: playlists[index],
                  ),
                  child: Hero(
                      tag: playlists[index].id,
                      child:  Material(
                        type: MaterialType.transparency,
                        color: Colors.transparent,
                        child: Container(
                          width: width*.4,
                          height: height*.5,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // color: Colors.amberAccent,
                              color: Theme.of(context).hoverColor,
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                height: height*.2,
                                margin: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    image: DecorationImage(
                                        image: NetworkImage( playlists[index].icon),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Padding(
                                  padding: const EdgeInsets.all(6).copyWith(
                                      bottom: 10
                                  ),
                                  child: DefaultTextStyle(
                                    style: const TextStyle(
                                        fontSize: 12,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.bold
                                    ),
                                    child: Text(
                                      playlists[index].name,
                                      textAlign: TextAlign.left,
                                    ),
                                  )
                              ),
                            ],
                          ),
                        ),
                      )
                  ),
                );
              },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
              child: isLoading ? const CircularProgressIndicator() : null,
            ),
          ),
        ],
      ),
    );
  }

  // Fetch Playlists Category ID
  Future<void> fetchCategoryID() async {
    final response =  await http.get(
      Uri.parse('https://palota-jobs-africa-spotify-fa.azurewebsites.net/api/browse/categories/afro'),
      headers: {
        'x-functions-key': apiKey,
        "Content-Type": 'application/json'
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      setState(() {
        playlistCategory = PlaylistCategory(
            name: data['name'],
            image: data['icons'][0]['url'],
            id: data['id'],
            categoryLink: data['href']
        );
      });

      fetchPlaylists().
      then((value) {
        setState(() {
          isLoading = false;
        });
      }).catchError((error) {
        setState(() {
          isLoading = false;
        });
      });
    }
    else {
      // Error handling
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<String> getAccessToken() async {
    final String basicAuth =
        'Basic ${base64Encode(utf8.encode('$clientId:$clientSecret'))}';
    final response = await http.post(
      Uri.parse('https://accounts.spotify.com/api/token'),
      headers: {'Authorization': basicAuth},
      body: {'grant_type': 'client_credentials'},
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final accessToken = responseData['access_token'];

      return accessToken;
    } else {
      throw Exception('Failed to obtain access token');
    }
  }
  Future<void> fetchPlaylists() async {
    setState(()=> isLoading = true);
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse("${playlistCategory!.categoryLink}/playlists?country=ZA&offset=$returnIndex&limit=20"),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> responseData = json.decode(response.body);

      for(Map<String, dynamic> playlist in responseData['playlists']['items']){
        setState(() {
          playlists.add(
              PlaylistDetails(
                name: playlist["name"],
                icon: playlist["images"][0]["url"],
                id: playlist["id"],
                description: playlist["description"],
                snapshotId: playlist["snapshot_id"],
                playlistLink: playlist["href"],
                totalTracks: playlist["tracks"]["total"],
                playlistTracks: [],
                playlistArtists: [],
                followers: 0
              )
          );
        });
      }
    }
    else {
      throw Exception('Failed to fetch playlists');
    }
  }

}
