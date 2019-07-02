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
  String type;
  String name;
  String message;
//  bool downloadable;
//  bool singleDownload;
//  bool commentable;
  bool shareable;
  dynamic description;
  String photographedAt;
  String status;
//  DateTime selectionLimitDate;
//  int selectionLimit;
//  String friendlyUrl;
//  String selectionQuantityType;
  String cover;
//  ExhibitionSize exhibitionSize;
  String ownerName;
  String ownerLogoText;
  String ownerLogoType;
  String ownerLogo;
  bool priv;
  List<Photo> photos;
//  int totalPhotos;
//  int totalSelections;

  Collection(
      {this.id,
      this.type,
      this.name,
      this.message,
//    this.downloadable,
//    this.singleDownload,
//    this.commentable,
      this.shareable,
      this.description,
      this.photographedAt,
      this.status,
//    this.selectionLimitDate,
//    this.selectionLimit,
//    this.friendlyUrl,
//    this.selectionQuantityType,
      this.cover,
//      this.exhibitionSize,
      this.ownerName,
      this.ownerLogoText,
      this.ownerLogoType,
      this.ownerLogo,
      this.priv,
      this.photos
      //  this.totalPhotos,
      //  this.totalSelections,
      });

  factory Collection.fromRawJson(String str) => Collection.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Collection.fromJson(Map<String, dynamic> json) {
    final _owner = Owner.fromJson(json["owner"]);

    return new Collection(
      id: json["id"],
      type: json["type"],
      name: json["name"],
      message: json["message"],
      //downloadable: json["downloadable"],
      //singleDownload: json["single_download"],
      //commentable: json["commentable"],
      shareable: json["shareable"],
      description: json["description"],
      photographedAt: json["photographed_at"],
      status: json["status"],
      //selectionLimitDate: DateTime.parse(json["selection_limit_date"]),
      //selectionLimit: json["selection_limit"],
      //friendlyUrl: json["friendly_url"],
      //selectionQuantityType: json["selection_quantity_type"],
      cover: json["cover"],
      //exhibitionSize: ExhibitionSize.fromJson(json["exhibition_size"]),
      ownerName: _owner.name,
      ownerLogoText: _owner.logoText,
      ownerLogoType: _owner.logoType,
      ownerLogo: _owner.logo,
      priv: json["priv"],
      photos: new List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      //totalPhotos: json["total_photos"],
      //totalSelections: json["total_selections"],
    );
  }

  factory Collection.fromJsonDB(Map<String, dynamic> json) {
    return new Collection(
      id: json["id"],
      type: json["type"],
      name: json["name"],
      message: json["message"],
      //downloadable: json["downloadable"],
      //singleDownload: json["single_download"],
      //commentable: json["commentable"],
      shareable: json["shareable"].toLowerCase() == 'true',
      description: json["description"],
      photographedAt: json["photographed_at"],
      status: json["status"],
      //selectionLimitDate: DateTime.parse(json["selection_limit_date"]),
      //selectionLimit: json["selection_limit"],
      //friendlyUrl: json["friendly_url"],
      //selectionQuantityType: json["selection_quantity_type"],
      cover: json["cover"],
      //exhibitionSize: ExhibitionSize.fromJson(json["exhibition_size"]),
      ownerName: json["ownerName"],
      ownerLogoText: json["ownerLogoText"],
      ownerLogoType: json["ownerLogoType"],
      ownerLogo: json["ownerLogo"],
      priv: json["priv"].toLowerCase() == 'true',
      //photos: new List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
      //totalPhotos: json["total_photos"],
      //totalSelections: json["total_selections"],
    );
  }

  Map<String, dynamic> toJson() {
    final _onwer = new Owner(
        name: ownerName, logoText: ownerLogoText, logoType: ownerLogoType, logo: ownerLogo);

    return {
      "id": id,
      "type": type,
      "name": name,
      "message": message,
      //"downloadable": downloadable,
      //"single_download": singleDownload,
      //"commentable": commentable,
      "shareable": shareable,
      "description": description,
      "photographed_at": photographedAt,
      "status": status,
//        "selection_limit_date":
//            "${selectionLimitDate.year.toString().padLeft(4, '0')}-${selectionLimitDate.month.toString().padLeft(2, '0')}-${selectionLimitDate.day.toString().padLeft(2, '0')}",
//        "selection_limit": selectionLimit,
//        "friendly_url": friendlyUrl,
//        "selection_quantity_type": selectionQuantityType,
      "cover": cover,
//        "exhibition_size": exhibitionSize.toJson(),
      "owner": _onwer.toJson(),
      "priv": priv,
      "photos": new List<dynamic>.from(photos.map((x) => x.toJson())),
      //"total_photos": totalPhotos,
      //"total_selections": totalSelections,
    };
  }
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
//  bool selected;
//  bool ownerFavorite;
//  List<dynamic> comments;

  Photo({
    this.id,
    this.url,
    this.name,
    this.height,
    this.width,
    this.position,
    //  this.selected,
    //  this.ownerFavorite,
    //  this.comments,
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
        //    selected: json["selected"],
        //    ownerFavorite: json["owner_favorite"],
        //    comments: new List<dynamic>.from(json["comments"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "name": name,
        "height": height,
        "width": width,
        "position": position,
        //  "selected": selected,
        //  "owner_favorite": ownerFavorite,
        //  "comments": new List<dynamic>.from(comments.map((x) => x)),
      };
}
