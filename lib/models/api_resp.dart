import 'dart:convert';


ApiResp apiRespFromJson(String str) => ApiResp.fromJson(json.decode(str));

String apiRespToJson(ApiResp data) => json.encode(data.toJson());

class ApiResp {
    bool ok;
    dynamic rdata;
    List<String> msgs;
    String message;

    ApiResp({
        required this.ok,
        required this.rdata,
        required this.msgs,
        required this.message,
    });

    factory ApiResp.fromJson(Map<String, dynamic> json) {
        return ApiResp(
            ok: json['success'] ?? false,
            rdata: json['data'],
            msgs: json['data'] != null ? List<String>.from(json['data']['msgs'] ?? []) : [],
            message: json['message'] ?? '', // Ensure message is correctly parsed
        );
    }

    Map<String, dynamic> toJson() => {
        "ok": ok,
        "rdata": rdata,
        "msgs": msgs,
        "message": message,
    };
}

