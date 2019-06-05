import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

const baseUrl = "https://andersonmiranda.clicster.com/api";

class API {
  static Future getProof(unique_id) {
     final Map<String, dynamic> params = {
      "count": "99999",
      "offset": "0",
      "unique_id": unique_id
    };
    final String url = baseUrl + "/proofs/select_view";
    return http.post(url, body: json.encode(params));
  }

  static Future getAlbum(unique_id) {
     final Map<String, dynamic> params = {
      "count": "99999",
      "offset": "0",
      "unique_id": unique_id
    };
    final String url = baseUrl + "/proofs/album_view";
    return http.post(url, body: json.encode(params));
  }

}
