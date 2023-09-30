import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tdd_tutorial/src/authentication/presentation/widgets/loading_column.dart';
import '../bloc/authentication_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void getUser() {
    context.read<AuthenticationBloc>().add(GetCachedUserEvent());
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
        if (state is GetCachedUserErrorState) {
          context.go('/Login');
        } else if (state is LoginState) {
          getUser();
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: state is LoadingState
                ? const LoadingColumn(message: 'Loading')
                : state is UserLoadedState
                    ? Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.teal),
                            color: Colors.white70),
                        child: Column(
                          children: [
                            Text(state.user.email),
                            Text(state.user.name),
                          ],
                        ),
                      )
                    : const SizedBox(),
            floatingActionButton: Visibility(
              visible: state is UserLoadedState ? false : true,
              child: FloatingActionButton.extended(
                onPressed: () {
                  context.go('/login');
                },
                label: const Text('Login'),
                icon: const Icon(Icons.add),
              ),
            ));
      },
    );
  }
}
