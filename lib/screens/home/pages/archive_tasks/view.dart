import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller.dart';
import '../../states.dart';
import '../../widgets/items.dart';

class ArchivedTasksScreen extends StatelessWidget {
  const ArchivedTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppController, AppStates> (
      listener: (context, state) {},
      builder: (context, state) {
        final tasks = AppController.get(context).archivedTasks;
        return taskBuilder(tasks: tasks );
      },
    );
  }
}
