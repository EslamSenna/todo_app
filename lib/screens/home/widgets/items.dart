import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/screens/home/controller.dart';

class DefaultFormField extends StatelessWidget {
  final prefixIcon;
  final labelText;
  final onTap;
  final controller;
  final validator;
  final type;
  final enabled;

  const DefaultFormField(
      {Key? key,
      this.prefixIcon,
      this.labelText,
      this.onTap,
      this.controller,
      this.validator,
      this.type,
      this.enabled})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: TextFormField(
        enabled: enabled,
        keyboardType: type,
        validator: (String? value) {
          if (value!.isEmpty) {
            return validator;
          }
          return null;
        },
        controller: controller,
        onTap: onTap,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
            prefixIcon: Icon(
              prefixIcon,
            ),
            labelText: labelText,
            border: OutlineInputBorder()),
      ),
    );
  }
}

Widget buildTaskItem(Map model, context) => Card(
  child: Container(
    padding: EdgeInsets.all(15),
    child: Row(
      children: [
        CircleAvatar(
          radius: 40,
          child: Text('${model['time']}'),
        ),
        Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${model['title']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              '${model['date']}',
              style: TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        Spacer(
          flex: 3,
        ),
        IconButton(
            onPressed: () {
              AppController.get(context)
                  .updateData(status: 'done', id: model['id']);
            },
            icon: Icon(
              Icons.check_box,
              color: Colors.green,
            )),
        IconButton(
            onPressed: () {
              AppController.get(context)
                  .updateData(status: 'archive', id: model['id']);
            },
            icon: Icon(
              Icons.archive,
              color: Colors.black45,
            )),
        IconButton(
            onPressed: () {
              AppController.get(context)
                  .deleteData( id: model['id']);
            },
            icon: Icon(
              Icons.delete_forever,
              color: Colors.red,
            )),
      ],
    ),
  ),
);


Widget taskBuilder({List<Map>? tasks})=> ConditionalBuilder(
  condition: tasks!.isNotEmpty,
  builder: (context) => ListView.builder(
      itemBuilder: (context, index) =>
          buildTaskItem(tasks[index], context),
      itemCount: tasks.length),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.menu, color: Colors.grey, size: 100),
        Text(
          'No Tasks Yet',
          style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
              fontWeight: FontWeight.bold
          ),
        )
      ],
    ),
  ),
);
