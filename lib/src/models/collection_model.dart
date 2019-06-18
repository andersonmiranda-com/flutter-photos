import 'dart:convert';

class Collections {
  List<Collection> items = new List();

  Collections();

  Collections.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;

    for (var item in jsonList) {
      final gallery = new Collection.fromJson(item);
      items.add(gallery);
    }
  }
}

class Collection {
  int id;
  String name;
  String message;
  bool downloadable;
  bool singleDownload;
  bool commentable;
  bool shareable;
  dynamic description;
  DateTime photographedAt;
  String status;
  DateTime selectionLimitDate;
  int selectionLimit;
  String friendlyUrl;
  String selectionQuantityType;
  String cover;
  ExhibitionSize exhibitionSize;
  Owner owner;
  bool priv;
  List<Photo> photos;
  int totalPhotos;
  int totalSelections;

  Collection({
    this.id,
    this.name,
    this.message,
    this.downloadable,
    this.singleDownload,
    this.commentable,
    this.shareable,
    this.description,
    this.photographedAt,
    this.status,
    this.selectionLimitDate,
    this.selectionLimit,
    this.friendlyUrl,
    this.selectionQuantityType,
    this.cover,
    this.exhibitionSize,
    this.owner,
    this.priv,
    this.photos,
    this.totalPhotos,
    this.totalSelections,
  });

  factory Collection.fromRawJson(String str) => Collection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Collection.fromJson(Map<String, dynamic> json) => new Collection(
        id: json["id"],
        name: json["name"],
        message: json["message"],
        downloadable: json["downloadable"],
        singleDownload: json["single_download"],
        commentable: json["commentable"],
        shareable: json["shareable"],
        description: json["description"],
        photographedAt: DateTime.parse(json["photographed_at"]),
        status: json["status"],
        selectionLimitDate: DateTime.parse(json["selection_limit_date"]),
        selectionLimit: json["selection_limit"],
        friendlyUrl: json["friendly_url"],
        selectionQuantityType: json["selection_quantity_type"],
        cover: json["cover"],
        exhibitionSize: ExhibitionSize.fromJson(json["exhibition_size"]),
        owner: Owner.fromJson(json["owner"]),
        priv: json["priv"],
        photos: new List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
        totalPhotos: json["total_photos"],
        totalSelections: json["total_selections"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "message": message,
        "downloadable": downloadable,
        "single_download": singleDownload,
        "commentable": commentable,
        "shareable": shareable,
        "description": description,
        "photographed_at":
            "${photographedAt.year.toString().padLeft(4, '0')}-${photographedAt.month.toString().padLeft(2, '0')}-${photographedAt.day.toString().padLeft(2, '0')}",
        "status": status,
        "selection_limit_date":
            "${selectionLimitDate.year.toString().padLeft(4, '0')}-${selectionLimitDate.month.toString().padLeft(2, '0')}-${selectionLimitDate.day.toString().padLeft(2, '0')}",
        "selection_limit": selectionLimit,
        "friendly_url": friendlyUrl,
        "selection_quantity_type": selectionQuantityType,
        "cover": cover,
        "exhibition_size": exhibitionSize.toJson(),
        "owner": owner.toJson(),
        "priv": priv,
        "photos": new List<dynamic>.from(photos.map((x) => x.toJson())),
        "total_photos": totalPhotos,
        "total_selections": totalSelections,
      };
}

class ExhibitionSize {
  int width;
  int height;

  ExhibitionSize({
    this.width,
    this.height,
  });

  factory ExhibitionSize.fromRawJson(String str) => ExhibitionSize.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ExhibitionSize.fromJson(Map<String, dynamic> json) => new ExhibitionSize(
        width: json["width"],
        height: json["height"],
      );

  Map<String, dynamic> toJson() => {
        "width": width,
        "height": height,
      };
}

class Owner {
  String name;
  String logoText;
  String logoType;
  dynamic logo;

  Owner({
    this.name,
    this.logoText,
    this.logoType,
    this.logo,
  });

  factory Owner.fromRawJson(String str) => Owner.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Owner.fromJson(Map<String, dynamic> json) => new Owner(
        name: json["name"],
        logoText: json["logo_text"],
        logoType: json["logo_type"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "logo_text": logoText,
        "logo_type": logoType,
        "logo": logo,
      };
}

class Photo {
  int id;
  String url;
  String name;
  int height;
  int width;
  int position;
  bool selected;
  bool ownerFavorite;
  List<dynamic> comments;

  Photo({
    this.id,
    this.url,
    this.name,
    this.height,
    this.width,
    this.position,
    this.selected,
    this.ownerFavorite,
    this.comments,
  });

  factory Photo.fromRawJson(String str) => Photo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Photo.fromJson(Map<String, dynamic> json) => new Photo(
        id: json["id"],
        url: json["url"],
        name: json["name"],
        height: json["height"],
        width: json["width"],
        position: json["position"],
        selected: json["selected"],
        ownerFavorite: json["owner_favorite"],
        comments: new List<dynamic>.from(json["comments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "name": name,
        "height": height,
        "width": width,
        "position": position,
        "selected": selected,
        "owner_favorite": ownerFavorite,
        "comments": new List<dynamic>.from(comments.map((x) => x)),
      };
}
