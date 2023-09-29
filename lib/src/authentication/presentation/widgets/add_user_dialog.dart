import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_tutorial/src/authentication/presentation/cubit/authentication_cubit.dart';

class AddUserDialog extends StatelessWidget {
  const AddUserDialog({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white
        ),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'name'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  // context.read<AuthenticationCubit>().createUser(
                  //     name: controller.text,
                  //     createdAt: DateTime.now().toString(),
                  //     avatar: '');
                  Navigator.pop(context);
                },
                child: const Text('Create User'))
          ],
        ),
      ),
    );
  }
}
