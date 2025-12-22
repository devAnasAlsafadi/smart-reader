


import 'package:hive/hive.dart';

import '../../domain/entities/electrical_panel_entity.dart';
part 'electrical_panel_model.g.dart';

@HiveType(typeId: 7)
class ElectricalPanelModel extends ElectricalPanelEntity {
  @HiveField(0)
  final String idHive;

  @HiveField(1)
  final String nameHive;

  @HiveField(2)
  final String addressHive;

  ElectricalPanelModel({
    required this.idHive,
    required this.nameHive,
    required this.addressHive,
  }) : super(
    id: idHive,
    name: nameHive,
    address: addressHive,
  );

  factory ElectricalPanelModel.fromJson(
      String id,
      Map<String, dynamic> json,
      ) {
    return ElectricalPanelModel(
      idHive: id,
      nameHive: json['name'],
      addressHive: json['address'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': nameHive,
    'address': addressHive,
  };
}
