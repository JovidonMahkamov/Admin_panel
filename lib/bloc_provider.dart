import 'package:admin_panel/core/di/services_locator.dart';
import 'package:admin_panel/features/workers/presentation/bloc/create_worker/create_worker_bloc.dart';
import 'package:admin_panel/features/workers/presentation/bloc/get_all_worker/get_all_worker_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/customer/presentation/bloc/create_customer/create_customer_bloc.dart';
import 'features/customer/presentation/bloc/delete_customer/delete_customer_bloc.dart';
import 'features/customer/presentation/bloc/get_all_customers/get_all_customers_bloc.dart';
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
      ],
      child: child,
    );
  }
}
