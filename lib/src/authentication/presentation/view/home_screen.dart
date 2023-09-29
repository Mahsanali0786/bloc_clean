import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:tdd_tutorial/src/authentication/presentation/widgets/loading_column.dart';
import '../bloc/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUser() {
    context.read<AuthenticationBloc>().getUser();
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        if(state is GetCachedUserErrorState){
          context.go('/Login');
        }
       else if (state is AuthenticationErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: state is LoadingState
              ? const LoadingColumn(message: 'Fetching User')
              : state is UserLoadedState
                  ? Container(
                      child: Column(
                        children: [
                          Text(state.user.email),
                          Text(state.user.name),
                        ],
                      ),
                    )
                  : const SizedBox(),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              context.go('/login');
              // await showDialog(
              //     context: context,
              //     builder: (context) => AddUserDialog(
              //           controller: nameController,
              //         ));
            },
            label: const Text('Login'),
            icon: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
