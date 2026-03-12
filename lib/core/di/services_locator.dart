import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/features/customer/data/datasource/customer_data_source.dart';
import 'package:admin_panel/features/customer/data/datasource/customer_data_source_impl.dart';
import 'package:admin_panel/features/customer/data/repository/customer_repository_impl.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';
import 'package:admin_panel/features/customer/domain/usecase/create_customer_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/delete_customer_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/get_all_customers_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/update_customer_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/create_customer/create_customer_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/delete_customer/delete_customer_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_all_customers/get_all_customers_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/update_customer/update_customer_bloc.dart';
import 'package:admin_panel/features/dashboard/data/datasource/dashboard_data_source.dart';
import 'package:admin_panel/features/dashboard/data/datasource/dashboard_data_source_impl.dart';
import 'package:admin_panel/features/dashboard/data/repository/dashboard_repository_impl.dart';
import 'package:admin_panel/features/dashboard/domain/repository/dashboard_repositories.dart';
import 'package:admin_panel/features/dashboard/domain/usecase/get_dashboard_use_case.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_bloc.dart';
import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/data/datasource/product_data_source_impl.dart';
import 'package:admin_panel/features/products/data/repository/product_repository_impl.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';
import 'package:admin_panel/features/products/domain/usecase/get_products_use_case.dart';
import 'package:admin_panel/features/products/presentation/bloc/get_products/get_products_bloc.dart';
import 'package:admin_panel/features/workers/data/datasource/worker_data_source.dart';
import 'package:admin_panel/features/workers/data/datasource/worker_data_source_impl.dart';
import 'package:admin_panel/features/workers/data/repository/worker_repository_impl.dart';
import 'package:admin_panel/features/workers/domain/repository/worker_repositories.dart';
import 'package:admin_panel/features/workers/domain/usecase/create_worker_use_case.dart';
import 'package:admin_panel/features/workers/domain/usecase/delete_worker_use_case.dart';
import 'package:admin_panel/features/workers/domain/usecase/get_all_workers_use_case.dart';
import 'package:admin_panel/features/workers/domain/usecase/update_worker_use_case.dart';
import 'package:admin_panel/features/workers/presentation/bloc/create_worker/create_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/delete_worker/delete_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/update_worker/update_worker_bloc.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> setup() async {
  sl.registerLazySingleton(() => Dio());

  /// DioClient
  sl.registerLazySingleton<DioClient>(() => DioClient());

  ///! DataSource
  ///* Worker
  sl.registerLazySingleton<WorkerDataSource>(
        () => WorkerDataSourceImpl(),
  );
  ///* Customer
  sl.registerLazySingleton<CustomerDataSource>(
        () => CustomerDataSourceImpl(),
  );
  ///* Dashboard
  sl.registerLazySingleton<DashboardDataSource>(
        () => DashboardDataSourceImpl(),
  );
  ///* Products
  sl.registerLazySingleton<ProductDataSource>(
        () => ProductDataSourceImpl(),
  );

  ///! Repository
  ///* Worker
  sl.registerLazySingleton<WorkerRepositories>(
        () => WorkerRepositoryImpl(  remote: sl(),),
  );
  ///* Customer
  sl.registerLazySingleton<CustomerRepositories>(
        () => CustomerRepositoryImpl(  remote: sl(),),
  );
  ///* Dashboard
  sl.registerLazySingleton<DashboardRepositories>(
        () => DashboardRepositoryImpl(  remote: sl(),),
  );
  ///* Products
  sl.registerLazySingleton<ProductRepositories>(
        () => ProductRepositoryImpl(  remote: sl(),),
  );
  ///! UseCase
  ///*Worker
  sl.registerLazySingleton(()=>GetAllWorkersUseCase(sl()));
  sl.registerLazySingleton(()=>CreateWorkerUseCase(sl()));
  sl.registerLazySingleton(()=>DeleteWorkerUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateWorkerUseCase(sl()));

  ///*Customer
  sl.registerLazySingleton(()=>GetAllCustomersUseCase(sl()));
  sl.registerLazySingleton(()=>CreateCustomerUseCase(sl()));
  sl.registerLazySingleton(()=>DeleteCustomerUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateCustomerUseCase(sl()));

  ///*Dashboard
  sl.registerLazySingleton(()=>GetDashboardUseCase(sl()));

  ///*Products
  sl.registerLazySingleton(()=>GetProductUseCase(sl()));

  ///! Bloc
  ///* Worker
  sl.registerLazySingleton(()=> GetAllWorkerBloc(sl()));
  sl.registerLazySingleton(()=> CreateWorkerBloc(sl()));
  sl.registerLazySingleton(()=> DeleteWorkerBloc(sl()));
  sl.registerLazySingleton(()=> UpdateWorkerBloc(sl()));

  ///* Customer
  sl.registerLazySingleton(()=> GetAllCustomersBloc(sl()));
  sl.registerLazySingleton(()=> CreateCustomerBloc(sl()));
  sl.registerLazySingleton(()=> DeleteCustomerBloc(sl()));
  sl.registerLazySingleton(()=> UpdateCustomerBloc(sl()));

  ///* Dashboard
  sl.registerLazySingleton(()=> GetDashboardBloc(sl()));

  ///* Products
  sl.registerLazySingleton(()=> GetProductsBloc(sl()));
}


