class TopicModel {
    List<TopicData>? data;

    TopicModel({
        this.data,
    });

    factory TopicModel.fromJson(Map<dynamic, dynamic> json) => TopicModel(
        data: json["data"] == null ? [] : List<TopicData>.from(json["data"]!.map((x) => TopicData.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
    };
}

class TopicData {
    String? name;

    TopicData({
        this.name,
    });

    factory TopicData.fromJson(Map<dynamic, dynamic> json) => TopicData(
        name: json["name"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
    };
}
