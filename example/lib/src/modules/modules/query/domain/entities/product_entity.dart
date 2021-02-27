// To parse this JSON data, do
//
//     final productEntity = productEntityFromMap(jsonString);

import 'dart:convert';

class ProductEntity {
    ProductEntity({
        this.barCode,
        this.createdAt,
        this.id,
        this.producName,
        this.providerId,
        this.updatedAt,
    });

    String? barCode;
    DateTime? createdAt;
    String? id;
    String? producName;
    int? providerId;
    DateTime? updatedAt;

    ProductEntity copyWith({
        String? barCode,
        DateTime? createdAt,
        String? id,
        String? producName,
        int? providerId,
        DateTime? updatedAt,
    }) => 
        ProductEntity(
            barCode: barCode ?? this.barCode,
            createdAt: createdAt ?? this.createdAt,
            id: id ?? this.id,
            producName: producName ?? this.producName,
            providerId: providerId ?? this.providerId,
            updatedAt: updatedAt ?? this.updatedAt,
        );

    factory ProductEntity.fromJson(String str) => ProductEntity.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ProductEntity.fromMap(Map json) => ProductEntity(
        barCode: json["bar_code"],
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
        producName: json["produc_name"],
        providerId: json["provider_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toMap() => {
        "bar_code": barCode,
        "created_at": createdAt == null ? null : createdAt!.toIso8601String(),
        "id": id,
        "produc_name": producName,
        "provider_id": providerId,
        "updated_at": updatedAt == null ? null : updatedAt!.toIso8601String(),
    };
}
