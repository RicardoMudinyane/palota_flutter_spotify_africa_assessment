

class PlaylistCategory{

  String name;
  String image;
  String id;
  String categoryLink;

  PlaylistCategory({
    required this.name,
    required this.image,
    required this.id,
    required this.categoryLink,
  });
}


class PlaylistDetails{

  String name;
  String icon;
  String id;
  String description;
  String snapshotId;
  String playlistLink;
  int totalTracks;
  int followers;
  List<Track> playlistTracks;
  List<Artist> playlistArtists;

  PlaylistDetails({
    required this.name,
    required this.icon,
    required this.id,
    required this.description,
    required this.snapshotId,
    required this.playlistLink,
    required this.totalTracks,
    this.followers = 0,
    required this.playlistTracks,
    required this.playlistArtists,
  });
}

class Track {
  String name;
  String icon;
  List<Artist> artists;
  int duration;

  Track({
    required this.name,
    required this.icon,
    required this.artists,
    required this.duration
  });
}

class Artist {
  String name;
  String artistLink;
  String profile;

  Artist({
    required this.name,
    required this.artistLink,
    required this.profile
  });
}

