
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/social_cubit/social_cubit.dart';
import 'package:social_app/models/request_friends_model.dart';
import 'package:social_app/shared/components/components.dart';
import 'package:social_app/shared/styles/icon_broken.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        SocialCubit.get(context).getRequestNot();
        return Scaffold(
          appBar: defaultAppBarr(
            leading: IconButton(
              icon: const Icon(IconBroken.Arrow___Left_2),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            text: 'Notification',
            context: context,
          ),
          body: BlocConsumer<SocialCubit, SocialState>(
              listener: (context, states) {},
              builder: (context, states) {
                var cubit = SocialCubit.get(context);
                print(cubit.not.length);
                return ListView.separated(
                    shrinkWrap: true,
                    itemBuilder: (context, index) =>
                        builderNotItem(context, cubit.not[index], cubit),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                    itemCount: cubit.not.length
                );
              }),
        );
      }
    );
  }


  Widget builderNotItem(
      context, SendRequestFriend model, SocialCubit cubit) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 35.0,
              backgroundImage: NetworkImage('${model.image}'),
            ),
            SizedBox(
              width: 15.0,
            ),
            Expanded(
              child: Text('${model.name}',
                style: TextStyle(
                  fontSize: 17.0,
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      );
}

