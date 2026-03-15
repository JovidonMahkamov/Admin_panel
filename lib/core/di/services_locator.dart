import 'package:admin_panel/core/networks/dio_client.dart';
import 'package:admin_panel/features/cost/data/datasource/cost_data_source.dart';
import 'package:admin_panel/features/cost/data/datasource/cost_data_source_impl.dart';
import 'package:admin_panel/features/cost/data/repository/cost_repo_impl.dart';
import 'package:admin_panel/features/cost/domain/repository/cost_repo.dart';
import 'package:admin_panel/features/cost/domain/usecase/delete_harajat_use_case.dart';
import 'package:admin_panel/features/cost/domain/usecase/delete_kassa_use_case.dart';
import 'package:admin_panel/features/cost/domain/usecase/get_harajat_use_case.dart';
import 'package:admin_panel/features/cost/domain/usecase/get_kassa_use_case.dart';
import 'package:admin_panel/features/cost/domain/usecase/post_kassa_use_case.dart';
import 'package:admin_panel/features/cost/domain/usecase/update_harajat_use_case.dart';
import 'package:admin_panel/features/cost/domain/usecase/update_kassa_use_case.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_harajat/delete_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_kassa/delete_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/get_harajat/get_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/get_kassa/get_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_harajat/post_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_kassa/post_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_harajat/update_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_kassa/update_kassa_bloc.dart';
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
import 'package:admin_panel/features/dashboard/domain/usecase/finish_sales_use_case.dart';
import 'package:admin_panel/features/dashboard/domain/usecase/get_dashboard_use_case.dart';
import 'package:admin_panel/features/dashboard/domain/usecase/worker_detail_use_case.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/finish_sales/finish_sales_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/worker_detail/worker_detail_bloc.dart';
import 'package:admin_panel/features/history/data/datasource/history_data_source.dart';
import 'package:admin_panel/features/history/data/datasource/history_data_source_impl.dart';
import 'package:admin_panel/features/history/data/repository/history_repo_impl.dart';
import 'package:admin_panel/features/history/domain/repository/history_repo.dart';
import 'package:admin_panel/features/history/domain/usecase/history_use_case.dart';
import 'package:admin_panel/features/history/presentation/bloc/get_history/get_history_bloc.dart';
import 'package:admin_panel/features/monthly_selling/data/datasource/monthly_selling_data_source.dart';
import 'package:admin_panel/features/monthly_selling/data/datasource/monthly_selling_data_source_impl.dart';
import 'package:admin_panel/features/monthly_selling/data/repository/monthly_selling_repository_impl.dart';
import 'package:admin_panel/features/monthly_selling/domain/repository/monthly_selling_repositories.dart';
import 'package:admin_panel/features/monthly_selling/domain/usecase/finish_monthly_sales_use_case.dart';
import 'package:admin_panel/features/monthly_selling/domain/usecase/get_monthly_selling_use_case.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/finish_monthly_selling/finish_monthly_selling_bloc.dart';
import 'package:admin_panel/features/products/data/datasource/product_data_source.dart';
import 'package:admin_panel/features/products/data/datasource/product_data_source_impl.dart';
import 'package:admin_panel/features/products/data/repository/product_repository_impl.dart';
import 'package:admin_panel/features/products/domain/repository/product_repositories.dart';
import 'package:admin_panel/features/products/domain/usecase/create_product_use_case.dart';
import 'package:admin_panel/features/products/domain/usecase/delete_product_usecase.dart';
import 'package:admin_panel/features/products/domain/usecase/get_products_use_case.dart';
import 'package:admin_panel/features/products/domain/usecase/update_product_use_case.dart';
import 'package:admin_panel/features/products/presentation/bloc/create_product/create_product_bloc.dart';
import 'package:admin_panel/features/products/presentation/bloc/delete_product/delete_product_bloc.dart';
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
import '../../features/cost/domain/usecase/post_harajat_use_case.dart';
import '../../features/monthly_selling/presentation/bloc/get_monthly_selling/get_monthly_selling_bloc.dart';
import '../../features/products/presentation/bloc/update_product/update_product_bloc.dart';

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
  ///* Oylik Savdo
  sl.registerLazySingleton<MonthlySellingDataSource>(
        () => MonthlySellingDataSourceImpl(),
  );
  ///*Tarix
  sl.registerLazySingleton<HistoryDataSource>(
        () => HistoryDataSourceImpl(),
  );
  ///*Harajat
  sl.registerLazySingleton<CostDataSource>(
        () => CostDataSourceImpl(),
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
  ///* Oylik Savdo
  sl.registerLazySingleton<MonthlySellingRepositories>(
        () => MonthlySellingRepositoryImpl(  remote: sl(),),
  );
  ///*Tarix
  sl.registerLazySingleton<HistoryRepo>(
        () => HistoryRepoImpl(remote: sl(),),
  );
  ///*Harajat
  sl.registerLazySingleton<CostRepo>(
        () => CostRepoImpl(remote: sl(),),
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
  sl.registerLazySingleton(()=>FinishSalesUseCase(sl()));
  sl.registerLazySingleton(()=>WorkerDetailUseCase(sl()));

  ///*Products
  sl.registerLazySingleton(()=>GetProductUseCase(sl()));
  sl.registerLazySingleton(()=>CreateProductUseCase(sl()));
  sl.registerLazySingleton(()=>DeleteProductUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateProductUseCase(sl()));

  ///*Oylik Savdo
  sl.registerLazySingleton(()=>GetMonthlySellingUseCase(sl()));
  sl.registerLazySingleton(()=>FinishMonthlySalesUseCase(sl()));

  ///*Tarix
  sl.registerLazySingleton(()=>HistoryUseCase(sl()));
  ///*Harajat
  sl.registerLazySingleton(()=>GetHarajatUseCase(sl()));
  sl.registerLazySingleton(()=>PostHarajatUseCase(sl()));
  sl.registerLazySingleton(()=>DeleteHarajatUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateHarajatUseCase(sl()));
  ///*Kassa
  sl.registerLazySingleton(()=>GetKassaUseCase(sl()));
  sl.registerLazySingleton(()=>PostKassaUseCase(sl()));
  sl.registerLazySingleton(()=>DeleteKassaUseCase(sl()));
  sl.registerLazySingleton(()=>UpdateKassaUseCase(sl()));


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
  sl.registerLazySingleton(()=> FinishSalesBloc(sl()));
  sl.registerLazySingleton(()=> WorkerDetailBloc(sl()));

  ///* Products
  sl.registerLazySingleton(()=> GetProductsBloc(sl()));
  sl.registerLazySingleton(()=> CreateProductBloc(sl()));
  sl.registerLazySingleton(()=> DeleteProductBloc(sl()));
  sl.registerLazySingleton(()=> UpdateProductBloc(sl()));

  ///* Oylik Savdo
  sl.registerLazySingleton(()=> GetMonthlySellingBloc(sl()));
  sl.registerLazySingleton(()=> FinishMonthlySellingBloc(sl()));

  ///* Tarix
  sl.registerLazySingleton(()=> GetHistoryBloc(sl()));
  ///* Harajat
  sl.registerLazySingleton(()=> GetHarajatBloc(sl()));
  sl.registerLazySingleton(()=> PostCostBloc(sl()));
  sl.registerLazySingleton(()=> DeleteHarajatBloc(sl()));
  sl.registerLazySingleton(()=> UpdateHarajatBloc(sl()));

  ///* Kassa
  sl.registerLazySingleton(()=> GetKassaBloc(sl()));
  sl.registerLazySingleton(()=> PostKassaBloc(sl()));
  sl.registerLazySingleton(()=> DeleteKassaBloc(sl()));
  sl.registerLazySingleton(()=> UpdateKassaBloc(sl()));
}


