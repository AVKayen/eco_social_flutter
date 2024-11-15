import 'package:flutter/material.dart';

import '../model/User.dart';
import '/constants.dart';

class ProfileWidget extends StatelessWidget {
  final PublicProfile user;

  const ProfileWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ignore: dead_code
        (user.picture != null && user.picture != Constants.imageUrl)
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
            const Icon(Icons.local_fire_department, size: 20),
            Text(user.streak.toString(), style: const TextStyle(fontSize: 15)),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.star, size: 20),
            Text(user.points.toString(), style: const TextStyle(fontSize: 15)),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.person, size: 20),
            Text((user.friendCount).toString(),
                style: const TextStyle(fontSize: 15)),
          ]),
        ]),
      ],
    );
  }
}
