import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/controller/CurrentPage.dart';

import '/model/Activity.dart';

class ActivityWidget extends StatelessWidget {
  final Activity activity;
  final bool linkToProfile;
  final bool showProfile;
  final bool linkToActivity;

  const ActivityWidget(
      {super.key,
      required this.activity,
      this.linkToProfile = true,
      this.showProfile = true,
      this.linkToActivity = true});

  @override
  Widget build(BuildContext context) {
    return Consumer<CurrentPage>(builder:
        (BuildContext context, CurrentPage currentPage, Widget? child) {
      return Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 104,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          (linkToActivity)
                              ? TextButton(
                                  onPressed: () {
                                    currentPage.redirectToActivity(activity.id);
                                  },
                                  style: ButtonStyle(
                                    overlayColor: WidgetStatePropertyAll(
                                        Theme.of(context)
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
                                )
                              : Text(
                                  activity.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
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
                    (showProfile)
                        ? (linkToProfile)
                            ? Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      currentPage
                                          .redirectToProfile(activity.userId);
                                    },
                                    child: Text('${activity.userId}',
                                        style: const TextStyle(
                                            fontSize: 15,
                                            overflow: TextOverflow.ellipsis,
                                            decoration:
                                                TextDecoration.underline)),
                                  ),
                                ],
                              )
                            : Text('${activity.userId}',
                                style: const TextStyle(
                                  fontSize: 15,
                                  overflow: TextOverflow.ellipsis,
                                ))
                        : const SizedBox(),
                    Text(activity.activityName,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(
                      height: 10,
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
    });
  }
}
