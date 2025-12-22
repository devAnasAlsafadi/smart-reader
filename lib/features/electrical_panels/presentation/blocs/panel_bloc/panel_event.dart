
import 'package:equatable/equatable.dart';

abstract class PanelEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadElectricalPanelsEvent extends PanelEvent{}

