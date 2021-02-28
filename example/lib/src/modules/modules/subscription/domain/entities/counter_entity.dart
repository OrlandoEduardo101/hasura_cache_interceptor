// To parse this JSON data, do
//
//     final productEntity = productEntityFromMap(jsonString);

import 'dart:convert';

class CounterEntity {
    CounterEntity({
        this.counter,
        this.id,
    });

    int? counter;
    int? id;

    CounterEntity copyWith({
        int? counter,
        int? id,
    }) => 
        CounterEntity(
            counter: counter ?? this.counter,
            id: id ?? this.id,
        );

    factory CounterEntity.fromJson(String str) => CounterEntity.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory CounterEntity.fromMap(Map json) => CounterEntity(
        counter: json["counter"],
        id: json["id"],
    );

    Map<String, dynamic> toMap() => {
        "counter": counter,
        "id": id,
    };
}
