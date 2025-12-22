import 'package:equatable/equatable.dart';

import '../../../domain/entities/electrical_panel_entity.dart';



class PanelState extends Equatable{
  final bool loading;
  final List<ElectricalPanelEntity> panels;

  const PanelState({
    this.loading = false,
    this.panels = const [],
  });

  PanelState copyWith({
    bool? loading,
    List<ElectricalPanelEntity>? panels,
  }) {
    return PanelState(
      loading: loading ?? this.loading,
      panels: panels ?? this.panels,
    );
  }
  @override
  List<Object?> get props => [loading,panels];
}