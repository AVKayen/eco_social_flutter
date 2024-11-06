import 'package:flutter/material.dart';

import '../model/Activity.dart';

class ActivityWidget extends StatelessWidget {
  final Activity activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 150,
      width: double.infinity,
      child: Row(
        children: [
          (activity.images != [] || activity.images != null)
              ? AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(activity.images![0]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              activity.title,
              style: const TextStyle(fontSize: 20),
            ),
            Row(children: [
              Text(activity.activityName, style: const TextStyle(fontSize: 15)),
            ]),
            Row(children: [
              (activity.caption != "" || activity.caption != null)
                  ? Text(activity.caption!,
                      style: const TextStyle(fontSize: 15))
                  : const SizedBox(),
            ]),
          ]),
        ],
      ),
    );
  }
}
