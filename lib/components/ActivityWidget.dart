import 'package:flutter/material.dart';

import '../model/Activity.dart';

import '../view/pages/ProfileView.dart';

class ActivityWidget extends StatelessWidget {
  final Activity activity;

  const ActivityWidget({super.key, required this.activity});

  @override
  Widget build(BuildContext context) {
    print(activity.images);
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 150,
      child: Row(
        children: [
          (activity.images != [] && activity.images != null)
              ? AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(activity.images![0]),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              : const SizedBox(),
          const SizedBox(width: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width - 180,
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                TextButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    overlayColor: WidgetStatePropertyAll(Theme.of(context)
                        .colorScheme
                        .secondary
                        .withOpacity(0.1)),
                  ),
                  child: Text(
                    activity.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const Icon(
                  Icons.local_fire_department,
                  size: 20,
                ),
                Text('${activity.streak}',
                    style: const TextStyle(fontSize: 15)),
                const SizedBox(width: 8),
                const Icon(
                  Icons.star,
                  size: 20,
                ),
                Text('${activity.points}',
                    style: const TextStyle(fontSize: 15)),
              ]),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('${activity.userId}',
                        style: const TextStyle(
                            fontSize: 15,
                            decoration: TextDecoration.underline)),
                  ),
                  const SizedBox(width: 8),
                  Text(activity.activityName,
                      overflow: TextOverflow.fade,
                      style: const TextStyle(fontSize: 15)),
                ],
              ),
              (activity.caption != "" || activity.caption != null)
                  ? Text(activity.caption!,
                      overflow: TextOverflow.fade,
                      maxLines: 3,
                      textWidthBasis: TextWidthBasis.longestLine,
                      style: const TextStyle(
                        fontSize: 15,
                      ))
                  : const SizedBox(),
            ]),
          ),
        ],
      ),
    );
  }
}
