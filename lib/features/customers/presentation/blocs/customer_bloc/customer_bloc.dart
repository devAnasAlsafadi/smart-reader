import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/enum/customer_filter_type.dart';
import '../../../domain/entities/customer_entity.dart';
import '../../../domain/usecases/add_customer_usercase.dart';
import '../../../domain/usecases/sync_offline_customer_usecase.dart';
import 'customer_event.dart';
import 'customer_state.dart';
import '../../../domain/usecases/get_customers_usecase.dart';
import '../../../domain/usecases/delete_customer_usecase.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {

  final AddCustomerUseCase addCustomer;
  final GetCustomersUseCase getCustomers;
  final DeleteCustomerUseCase deleteCustomer;
  final SyncOfflineCustomersUseCase syncCustomers;

  CustomerBloc({
    required this.addCustomer,
    required this.getCustomers,
    required this.deleteCustomer,
    required this.syncCustomers,
  }): super( CustomerState()) {


    // 🔵 Add Customer ---------------------------------------------------------
    on<AddCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingAdd: true));
      try {
        await addCustomer(event.customerEntity);
        emit(state.copyWith(isLoadingAdd: false,addSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoadingAdd: false,addError: e.toString()));
      }
    });



    // 🔵 Load Customers -------------------------------------------------------
    on<LoadCustomersEvent>((event, emit) async {
      emit(state.copyWith(isLoadingGet: true));
      try {
        final all = await getCustomers(event.userId);
        final filtered = applyFilter(all, state.searchText, state.filterType);
        emit(state.copyWith(isLoadingGet: false,allCustomers: all,filteredCustomers: filtered));
      } catch (e) {
        emit(state.copyWith(
          isLoadingGet: false,
          getError: e.toString(),
        ));
      }
    });


    // 🔵 Delete Customer ------------------------------------------------------
    on<DeleteCustomerEvent>((event, emit) async {
      emit(state.copyWith(isLoadingDelete: true));

      try {
        await deleteCustomer(event.customerId);
        emit(state.copyWith(isLoadingDelete: false,deleteSuccess: true));
      } catch (e) {
        emit(state.copyWith(isLoadingDelete: false,deleteError: e.toString()));

      }
    });


    // 🔵 Change Filter --------------------------------------------------------
    on<ChangeFilterEvent>((event, emit) {
      final filtered = applyFilter(state.allCustomers, state.searchText, event.type);
      final isNone = event.type == CustomerFilterType.none;
      emit(state.copyWith(
        filterType: event.type,
        filteredCustomers: filtered,
        showFilterChip: !isNone,
      ));
    },);


    on<ResetFilterEvent>((event, emit) {
      emit(state.copyWith(
        filterType: CustomerFilterType.name,
        showFilterChip: false,
        searchText: "",
        filteredCustomers: state.allCustomers,
      ));
    });


    // 🔵 Search ---------------------------------------------------------------
    on<SearchCustomerEvent>((event, emit) {
      final filtered = applyFilter(
        state.allCustomers,
        event.text,
        state.filterType,
      );
      emit(state.copyWith(searchText: event.text,filteredCustomers: filtered));
    },);



    // 🔵 Sync Offline ---------------------------------------------------------
    on<SyncOfflineCustomersEvent>((event, emit) async {
      await syncCustomers(event.userId);
    });
  }


  // 🔍 Filtering Logic --------------------------------------------------------
  List<CustomerEntity> applyFilter(
      List<CustomerEntity> customers,
      String search,
      CustomerFilterType filter,
      ) {
    if (search.isEmpty) return customers;

    final query = search.toLowerCase();

    return customers.where((c) {
      if (filter == CustomerFilterType.name) {
        return c.name.toLowerCase().contains(query);
      } else if(filter == CustomerFilterType.street) {
        return c.street.toLowerCase().contains(query);
      }
      return false;
    }).toList();
  }
}





