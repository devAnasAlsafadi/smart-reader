import 'package:equatable/equatable.dart';
import '../../../../../core/enum/customer_filter_type.dart';
import '../../../domain/entities/customer_entity.dart';



class CustomerState extends Equatable{
  final bool isLoadingGet;
  final bool isLoadingAdd;
  final bool isLoadingDelete;
  final bool isLoadingSync;
  final List<CustomerEntity> allCustomers;
  final List<CustomerEntity> filteredCustomers;
  final String searchText;
  final CustomerFilterType filterType ;
  final bool showFilterChip;
  final String? getError;
  final String? addError;
  final String? deleteError;
  final String? syncError;

  final bool addSuccess;
  final bool deleteSuccess;

  const CustomerState({
    this.isLoadingGet = false,
    this.isLoadingAdd = false,
    this.isLoadingDelete = false,
    this.isLoadingSync = false,
    this.allCustomers = const [],
    this.filteredCustomers = const [],
    this.searchText = "",
    this.filterType = CustomerFilterType.name,
    this.showFilterChip = false,
    this.getError,
    this.addError,
    this.deleteError,
    this.syncError,
    this.addSuccess = false,
    this.deleteSuccess = false,
  });

  CustomerState copyWith({
    bool? isLoadingGet,
    bool? isLoadingAdd,
    bool? isLoadingDelete,
    bool? isLoadingSync,
    List<CustomerEntity>? allCustomers,
    List<CustomerEntity>? filteredCustomers,
    String? searchText,
    CustomerFilterType? filterType,
    bool? showFilterChip,
    String? getError,
    String? addError,
    String? deleteError,
    String? syncError,
    bool? addSuccess,
    bool? deleteSuccess,
  }) {
    return CustomerState(

      isLoadingGet: isLoadingGet ?? this.isLoadingGet,
      isLoadingAdd: isLoadingAdd ?? this.isLoadingAdd,
      isLoadingDelete: isLoadingDelete ?? this.isLoadingDelete,
      isLoadingSync: isLoadingSync ?? this.isLoadingSync,
      showFilterChip: showFilterChip ?? this.showFilterChip,
      allCustomers: allCustomers ?? this.allCustomers,
      filteredCustomers: filteredCustomers ?? this.filteredCustomers,
      searchText: searchText ?? this.searchText,
      filterType: filterType ?? this.filterType,
      getError: getError,
      addError: addError,
      deleteError: deleteError,
      syncError: syncError,
      addSuccess: addSuccess ?? false,
      deleteSuccess: deleteSuccess ?? false,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
  [
    isLoadingGet,
    isLoadingAdd,
    isLoadingDelete,
    isLoadingSync,
    allCustomers,
    filteredCustomers,
    searchText,
    filterType,
    getError,
    addError,
    deleteError,
    syncError,
    showFilterChip,
    addSuccess,
    deleteSuccess,
  ];
}
