import 'package:admin_panel/core/di/services_locator.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_harajat/delete_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_kassa/delete_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/get_harajat/get_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_harajat/post_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/post_kassa/post_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_harajat/update_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/update_kassa/update_kassa_bloc.dart';
import 'package:admin_panel/features/customer/presentation/bloc/get_customer/get_customer_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/finish_sales/finish_sales_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/get_dashboard/get_dashboard_bloc.dart';
import 'package:admin_panel/features/dashboard/presentation/bloc/update_transfer/update_transfer_bloc.dart';
import 'package:admin_panel/features/history/presentation/bloc/get_history/get_history_bloc.dart';
import 'package:admin_panel/features/monthly_selling/presentation/bloc/finish_monthly_selling/finish_monthly_selling_bloc.dart';
import 'package:admin_panel/features/products/presentation/bloc/create_product/create_product_bloc.dart';
import 'package:admin_panel/features/products/presentation/bloc/delete_product/delete_product_bloc.dart';
import 'package:admin_panel/features/products/presentation/bloc/get_products/get_products_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/create_worker/create_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/cost/presentation/bloc/get_kassa/get_kassa_bloc.dart';
import 'features/customer/presentation/bloc/create_customer/create_customer_bloc.dart';
import 'features/customer/presentation/bloc/delete_customer/delete_customer_bloc.dart';
import 'features/customer/presentation/bloc/get_all_customers/get_all_customers_bloc.dart';
import 'features/customer/presentation/bloc/update_customer/update_customer_bloc.dart';
import 'features/dashboard/presentation/bloc/worker_detail/worker_detail_bloc.dart';
import 'features/monthly_selling/presentation/bloc/get_monthly_selling/get_monthly_selling_bloc.dart';
import 'features/products/presentation/bloc/update_product/update_product_bloc.dart';
import 'features/workers/presentation/bloc/delete_worker/delete_worker_bloc.dart';
import 'features/workers/presentation/bloc/update_worker/update_worker_bloc.dart';

class MyBlocProvider extends StatelessWidget {
  const MyBlocProvider({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetAllWorkerBloc>(create: (context) => sl<GetAllWorkerBloc>()),
        BlocProvider<CreateWorkerBloc>(create: (context) => sl<CreateWorkerBloc>()),
        BlocProvider<DeleteWorkerBloc>(create: (context) => sl<DeleteWorkerBloc>()),
        BlocProvider<UpdateWorkerBloc>(create: (context) => sl<UpdateWorkerBloc>()),
        BlocProvider<GetAllCustomersBloc>(create: (context) => sl<GetAllCustomersBloc>()),
        BlocProvider<CreateCustomerBloc>(create: (context) => sl<CreateCustomerBloc>()),
        BlocProvider<DeleteCustomerBloc>(create: (context) => sl<DeleteCustomerBloc>()),
        BlocProvider<UpdateCustomerBloc>(create: (context) => sl<UpdateCustomerBloc>()),
        BlocProvider<GetDashboardBloc>(create: (context) => sl<GetDashboardBloc>()),
        BlocProvider<GetProductsBloc>(create: (context) => sl<GetProductsBloc>()),
        BlocProvider<CreateProductBloc>(create: (context) => sl<CreateProductBloc>()),
        BlocProvider<DeleteProductBloc>(create: (context) => sl<DeleteProductBloc>()),
        BlocProvider<FinishSalesBloc>(create: (context) => sl<FinishSalesBloc>()),
        BlocProvider<GetMonthlySellingBloc>(create: (context) => sl<GetMonthlySellingBloc>()),
        BlocProvider<WorkerDetailBloc>(create: (context) => sl<WorkerDetailBloc>()),
        BlocProvider<GetHistoryBloc>(create: (context) => sl<GetHistoryBloc>()),
        BlocProvider<GetHarajatBloc>(create: (context) => sl<GetHarajatBloc>()),
        BlocProvider<PostCostBloc>(create: (context) => sl<PostCostBloc>()),
        BlocProvider<DeleteHarajatBloc>(create: (context) => sl<DeleteHarajatBloc>()),
        BlocProvider<UpdateHarajatBloc>(create: (context) => sl<UpdateHarajatBloc>()),
        BlocProvider<UpdateProductBloc>(create: (context) => sl<UpdateProductBloc>()),
        BlocProvider<GetKassaBloc>(create: (context) => sl<GetKassaBloc>()),
        BlocProvider<PostKassaBloc>(create: (context) => sl<PostKassaBloc>()),
        BlocProvider<DeleteKassaBloc>(create: (context) => sl<DeleteKassaBloc>()),
        BlocProvider<UpdateKassaBloc>(create: (context) => sl<UpdateKassaBloc>()),
        BlocProvider<FinishMonthlySellingBloc>(create: (context) => sl<FinishMonthlySellingBloc>()),
        BlocProvider<GetCustomerBloc>(create: (context) => sl<GetCustomerBloc>()),
        BlocProvider<UpdateTransferBloc>(create: (context) => sl<UpdateTransferBloc>()),
      ],
      child: child,
    );
  }
}
