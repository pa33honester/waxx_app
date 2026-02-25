// To parse this JSON data, do
//
//     final conutryDataModel = conutryDataModelFromJson(jsonString);

import 'dart:convert';

List<ConutryDataModel> countryDataModelFromJson(String str) =>
    List<ConutryDataModel>.from(
        json.decode(str).map((x) => ConutryDataModel.fromJson(x)));

String countryDataModelToJson(List<ConutryDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ConutryDataModeldemo {}

class ConutryDataModel {
  int? id;
  String? countryName;

  List<StateData>? states;

  ConutryDataModel({
    this.id,
    this.countryName,
    this.states,
  });

  factory ConutryDataModel.fromJson(Map<String, dynamic> json) =>
      ConutryDataModel(
        id: json["id"],
        countryName: json["name"],
        states: json["states"] == null
            ? []
            : List<StateData>.from(
                json["states"]!.map((x) => StateData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "states": states == null
            ? []
            : List<dynamic>.from(states!.map((x) => x.toJson())),
      };
}

class StateData {
  int? id;
  String? stateName;

  List<City>? cities;

  StateData({
    this.id,
    this.stateName,
    this.cities,
  });

  factory StateData.fromJson(Map<String, dynamic> json) => StateData(
        id: json["id"],
        stateName: json["name"],
        cities: json["cities"] == null
            ? []
            : List<City>.from(json["cities"]!.map((x) => City.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": stateName,
        "cities": cities == null
            ? []
            : List<dynamic>.from(cities!.map((x) => x.toJson())),
      };
}

class City {
  int? id;
  String? cityName;

  City({
    this.id,
    this.cityName,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        id: json["id"],
        cityName: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": cityName,
      };
}
