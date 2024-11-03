import 'package:flutter/material.dart';

import '../model/User.dart';

class ProfileWidget extends StatelessWidget {
  final User user;

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
          AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                  image: NetworkImage(
                      'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/afd2a691-136e-45aa-b282-8b2913755418/dfi1ani-8d64366f-e428-4f28-8a73-4344be58761c.png/v1/fit/w_750,h_750,q_70,strp/furry_sketch_commission_by_syronica_dfi1ani-375w-2x.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTI4MCIsInBhdGgiOiJcL2ZcL2FmZDJhNjkxLTEzNmUtNDVhYS1iMjgyLThiMjkxMzc1NTQxOFwvZGZpMWFuaS04ZDY0MzY2Zi1lNDI4LTRmMjgtOGE3My00MzQ0YmU1ODc2MWMucG5nIiwid2lkdGgiOiI8PTEyODAifV1dLCJhdWQiOlsidXJuOnNlcnZpY2U6aW1hZ2Uub3BlcmF0aW9ucyJdfQ.qkBI_St0TfZIW6eaKlc4bblGnTvtCz3dnaOQ3Icf4OE'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
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
              Text((user.points / 10).toString(),
                  style: const TextStyle(fontSize: 15)),
            ]),
            Row(children: [
              const Icon(Icons.person, size: 20),
              Text((user.friends.length).toString(),
                  style: const TextStyle(fontSize: 15)),
            ])
          ]),
        ],
      ),
    );
  }
}
