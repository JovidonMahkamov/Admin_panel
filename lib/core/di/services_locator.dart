import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/features/customer/data/datasource/customer_data_source.dart';
import 'package:admin_panel/features/customer/data/datasource/customer_data_source_impl.dart';
import 'package:admin_panel/features/customer/data/repository/customer_repository_impl.dart';
import 'package:admin_panel/features/customer/domain/repository/customer_repositories.dart';
import 'package:admin_panel/features/customer/domain/usecase/create_customer_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/delete_customer_use_case.dart';
import 'package:admin_panel/features/customer/domain/usecase/get_all_customers_use_case.dart';
import 'package:admin_panel/features/customer/presentation/bloc/create_customer/create_customer_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/delete_customer/delete_customer_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_all_customers/get_all_customers_bloc.dart';
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
  ///! Repository
  ///* Worker
  sl.registerLazySingleton<WorkerRepositories>(
        () => WorkerRepositoryImpl(  remote: sl(),),
  );
  ///* Customer
  sl.registerLazySingleton<CustomerRepositories>(
        () => CustomerRepositoryImpl(  remote: sl(),),
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
}


