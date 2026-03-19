import 'package:admin_panel/core/di/services_locator.dart';
import 'package:admin_panel/features/balans/presentation/bloc/get_balans/balans_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_harajat/delete_harajat_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/delete_kassa/delete_kassa_bloc.dart';
import 'package:admin_panel/features/cost/presentation/bloc/dokon_chiqim/dokon_chiqim_bloc.dart';
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
        BlocProvider<GetAllWorkerBloc>(create: (_) => sl<GetAllWorkerBloc>()),
        BlocProvider<CreateWorkerBloc>(create: (_) => sl<CreateWorkerBloc>()),
        BlocProvider<DeleteWorkerBloc>(create: (_) => sl<DeleteWorkerBloc>()),
        BlocProvider<UpdateWorkerBloc>(create: (_) => sl<UpdateWorkerBloc>()),
        BlocProvider<GetAllCustomersBloc>(create: (_) => sl<GetAllCustomersBloc>()),
        BlocProvider<CreateCustomerBloc>(create: (_) => sl<CreateCustomerBloc>()),
        BlocProvider<DeleteCustomerBloc>(create: (_) => sl<DeleteCustomerBloc>()),
        BlocProvider<UpdateCustomerBloc>(create: (_) => sl<UpdateCustomerBloc>()),
        BlocProvider<GetDashboardBloc>(create: (_) => sl<GetDashboardBloc>()),
        BlocProvider<GetProductsBloc>(create: (_) => sl<GetProductsBloc>()),
        BlocProvider<CreateProductBloc>(create: (_) => sl<CreateProductBloc>()),
        BlocProvider<DeleteProductBloc>(create: (_) => sl<DeleteProductBloc>()),
        BlocProvider<FinishSalesBloc>(create: (_) => sl<FinishSalesBloc>()),
        BlocProvider<GetMonthlySellingBloc>(create: (_) => sl<GetMonthlySellingBloc>()),
        BlocProvider<WorkerDetailBloc>(create: (_) => sl<WorkerDetailBloc>()),
        BlocProvider<GetHistoryBloc>(create: (_) => sl<GetHistoryBloc>()),
        BlocProvider<GetHarajatBloc>(create: (_) => sl<GetHarajatBloc>()),
        BlocProvider<PostCostBloc>(create: (_) => sl<PostCostBloc>()),
        BlocProvider<DeleteHarajatBloc>(create: (_) => sl<DeleteHarajatBloc>()),
        BlocProvider<UpdateHarajatBloc>(create: (_) => sl<UpdateHarajatBloc>()),
        BlocProvider<UpdateProductBloc>(create: (_) => sl<UpdateProductBloc>()),
        BlocProvider<GetKassaBloc>(create: (_) => sl<GetKassaBloc>()),
        BlocProvider<PostKassaBloc>(create: (_) => sl<PostKassaBloc>()),
        BlocProvider<DeleteKassaBloc>(create: (_) => sl<DeleteKassaBloc>()),
        BlocProvider<UpdateKassaBloc>(create: (_) => sl<UpdateKassaBloc>()),
        BlocProvider<FinishMonthlySellingBloc>(create: (_) => sl<FinishMonthlySellingBloc>()),
        BlocProvider<GetCustomerBloc>(create: (_) => sl<GetCustomerBloc>()),
        BlocProvider<UpdateTransferBloc>(create: (_) => sl<UpdateTransferBloc>()),
        BlocProvider<GetBalansBloc>(create: (_) => sl<GetBalansBloc>()),
        // DokonChiqim
        BlocProvider<GetDokonChiqimBloc>(create: (_) => sl<GetDokonChiqimBloc>()),
        BlocProvider<PostDokonChiqimBloc>(create: (_) => sl<PostDokonChiqimBloc>()),
        BlocProvider<PatchDokonChiqimBloc>(create: (_) => sl<PatchDokonChiqimBloc>()),
        BlocProvider<DeleteDokonChiqimBloc>(create: (_) => sl<DeleteDokonChiqimBloc>()),
      ],
      child: child,
    );
  }
}