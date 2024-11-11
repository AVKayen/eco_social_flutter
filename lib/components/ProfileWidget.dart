import 'package:flutter/material.dart';

import '../model/User.dart';

class ProfileWidget extends StatelessWidget {
  final PublicProfile user;

  const ProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // ignore: dead_code
          (true || user.picture != null && user.picture != "")
              ? AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                        image: NetworkImage(user.picture!),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                )
              // ignore: dead_code
              : const SizedBox(),
          const SizedBox(width: 10),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              user.username,
              style: const TextStyle(fontSize: 20),
            ),
            Row(children: [
              const Icon(Icons.hot_tub, size: 20),
              Text(user.streak.toString(),
                  style: const TextStyle(fontSize: 15)),
            ]),
            Row(children: [
              const Icon(Icons.eco, size: 20),
              Text(user.points.toString(),
                  style: const TextStyle(fontSize: 15)),
            ]),
            Row(children: [
              const Icon(Icons.star, size: 20),
              Text((user.level).toString(),
                  style: const TextStyle(fontSize: 15)),
            ]),
            Row(children: [
              const Icon(Icons.person, size: 20),
              Text((user.friendCount).toString(),
                  style: const TextStyle(fontSize: 15)),
            ])
          ]),
        ],
      ),
    );
  }
}
