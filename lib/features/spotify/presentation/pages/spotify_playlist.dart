import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_spotify_africa_assessment/objects.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../colors.dart';

//TODO: complete this page - you may choose to change it to a stateful widget if necessary
class SpotifyPlaylist extends StatefulWidget {

  final PlaylistDetails playlistDetails;

  const SpotifyPlaylist({Key? key, required this.playlistDetails}) : super(key: key);

  @override
  State<SpotifyPlaylist> createState() => _SpotifyPlaylistState();
}

class _SpotifyPlaylistState extends State<SpotifyPlaylist> {

  final String clientId = '42cea7baf90842b682ad6b233f5b2fa9';
  final String clientSecret = '84fd6a7fe55f4d4dbbdf18e906bce2b4';

  bool loadedArtists = false;

  @override
  void initState() {

    if(widget.playlistDetails.playlistTracks.isEmpty){
      fetchPlaylistTrack().then((value){
        setState(() {
          widget.playlistDetails.playlistTracks =  widget.playlistDetails.playlistTracks.toSet().toList();
          loadedArtists = true;
        });
      });
    }
    else{
      setState(() {
        loadedArtists = true;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      // extendBody: true,
      extendBodyBehindAppBar: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min ,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: height*.125),
                  Hero(
                      tag: widget.playlistDetails.id,
                      child: Material(
                          type: MaterialType.transparency,
                          color: Colors.transparent,
                          child: Container(
                            width: width*.8,
                            height: width*.85,
                            decoration: BoxDecoration(
                                color: Theme.of(context).hoverColor,
                                borderRadius: BorderRadius.circular(12)
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  height: width*.65,
                                  margin: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(widget.playlistDetails.icon),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(8)
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10).
                                  copyWith(bottom: 5),
                                  child:  DefaultTextStyle(
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: const TextStyle(
                                        fontSize: 18,
                                        decoration: TextDecoration.none,
                                        fontWeight: FontWeight.normal
                                    ),
                                    child: Text(widget.playlistDetails.name),
                                  ),
                                ),
                              ],
                            ),
                          )
                      )
                  ),
                  const SizedBox(height: 10),

                  Container(
                    width: width*.9,
                    alignment: Alignment.centerLeft,
                    child: Html(
                        data: widget.playlistDetails.description,
                        onLinkTap: (String? url, RenderContext context, Map<String, String> attributes, element) {
                          _launchUrl(url!);
                        }
                    ),
                  ),
                  const SizedBox(height: 10),


                  Container(
                      width: width,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: width*.5,
                        height: height*.05,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(15))
                        ),
                        child:  Text(
                          "${formatNumber("${widget.playlistDetails.followers}")} followers",
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                              fontSize: 12,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 20),

                  Container(
                    width: width*.85,
                    height: height*.005,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: const LinearGradient(
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
                  const SizedBox(height: 10),

                  widget.playlistDetails.playlistTracks.isEmpty ?
                  Container(
                    width: width,
                    height: height*.2,
                    alignment: Alignment.center,
                    child: const Text(
                      "Getting tracks...",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ) :
                  Flexible(
                      child: ListView.builder(
                        itemCount: widget.playlistDetails.playlistTracks.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (BuildContext context, int index){
                          return ListTile(
                            leading: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          widget.playlistDetails.playlistTracks[index].icon
                                      ),
                                      fit: BoxFit.cover
                                  )
                              ),
                            ),
                            title: Text(
                              widget.playlistDetails.playlistTracks[index].name,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            subtitle: Text(
                              widget.playlistDetails.playlistTracks[index].artists.map((e) => e.name).toList().join(', '),
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                  overflow: TextOverflow.ellipsis
                              ),
                            ),
                            trailing: Text(
                              convertDuration(widget.playlistDetails.playlistTracks[index].duration),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70
                              ),
                            ),
                          );
                        },
                      )
                  ),
                  const SizedBox(height: 20),

                  Container(
                      width: width,
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: width*.9,
                        height: height*.065,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius: const BorderRadius.horizontal(right: Radius.circular(15))
                        ),
                        child: const Text(
                          "Featured Artists",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 18,
                              decoration: TextDecoration.none,
                              fontWeight: FontWeight.normal
                          ),
                        ),
                      )
                  ),
                  const SizedBox(height: 10),

                  Container(
                      width: width,
                      height: 160,
                      alignment: loadedArtists ?
                      Alignment.centerLeft :
                      Alignment.center,
                      padding: const EdgeInsets.all(2),
                      child: loadedArtists ?
                      ListView.separated(
                        itemCount: widget.playlistDetails.playlistArtists.length,
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        separatorBuilder: (context, index) {
                          return const SizedBox(width: 20);
                        },
                        itemBuilder: (BuildContext context, int index){
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            widget.playlistDetails.playlistArtists[index].profile
                                        ),
                                        fit: BoxFit.cover
                                    )
                                ),
                              ),
                              Text(
                                widget.playlistDetails.playlistArtists[index].name,
                                style: const TextStyle(
                                  fontSize: 12,

                                ),
                              ),
                            ],
                          );
                        },
                      ) :
                      const CircularProgressIndicator()
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: height*.1,
              child: AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
            )
          ),
        ],
      )
    );
  }

  String formatNumber(number){
    return number.replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => "${m[1]},");
  }
  String convertDuration(int time) {
    Duration duration = Duration(milliseconds: time);
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
  Future<void> _launchUrl(String urlLink) async {

    final Uri url = Uri.parse(urlLink);

    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
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
  Future<void> fetchPlaylistTrack() async {
    final accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse(widget.playlistDetails.playlistLink),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {

      Map<String, dynamic> responseData = json.decode(response.body);
      widget.playlistDetails.playlistTracks = [];

      setState(() {
        widget.playlistDetails.followers = responseData['followers']['total'];
      });
      for(Map<String, dynamic> track in responseData['tracks']['items']){
        List<Artist>  artistTemp = [];

        track['track']['artists'].forEach((artist) async {

          bool exists = widget.playlistDetails.playlistArtists.any((e) => e.name == artist['name']);
          String artistProfile = await fetchArtistProfile(artist['href'], accessToken);
           setState(() {
             artistTemp.add(
                 Artist(
                     name: artist['name'],
                     artistLink: artist['href'],
                     profile: artistProfile
                 )
             );
           });

          if(!exists){
            setState(() {
              widget.playlistDetails.playlistArtists.add(Artist(
                  name: artist['name'],
                  artistLink: artist['href'],
                  profile: artistProfile
              ));
            });
          }
        });
        setState(() {
          widget.playlistDetails.playlistTracks.add(
            Track(
                name: track['track']['name'],
                icon: track['track']['album']['images'][0]['url'],
                artists: artistTemp,
                duration: track['track']['duration_ms']
            ),
          );
        });
      }
    }
    else {
      throw Exception('Failed to fetch playlists');
    }
  }
  Future<String> fetchArtistProfile(String artistLink, accessToken) async {

    final response = await http.get(
      Uri.parse(artistLink),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {


      if (json.decode(response.body)["images"].isEmpty){
        return "https://www.seekpng.com/png/detail/110-1100707_person-avatar-placeholder.png";
      }
      return json.decode(response.body)["images"][0]["url"];
    }
    else if(response.statusCode == 429){
      String newToken = await getAccessToken();

      return fetchArtistProfile(artistLink, newToken);
    }
    else {
      // print("CODE: ${response.statusCode}");
      throw Exception('Failed to fetch Artist Info');
    }
  }
}