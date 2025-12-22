import 'package:bloc/bloc.dart';
import 'package:smart_reader/features/electrical_panels/presentation/blocs/panel_bloc/panel_event.dart';
import 'package:smart_reader/features/electrical_panels/presentation/blocs/panel_bloc/panel_state.dart';

import '../../../domain/usecases/get_electrical_panels.dart';

class PanelBloc extends Bloc<PanelEvent, PanelState> {
  final GetElectricalPanelsUseCase getPanels;

  PanelBloc({required this.getPanels}) : super(PanelState()) {
    on<LoadElectricalPanelsEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      final panels = await getPanels();
      print('panels is : ${panels.length}');
      emit(state.copyWith(loading: false, panels: panels));
    });
  }
}
