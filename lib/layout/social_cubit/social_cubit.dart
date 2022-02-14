import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:social_app/models/message_model.dart';
import 'package:social_app/models/post_model.dart';
import 'package:social_app/models/request_friends_model.dart';
import 'package:social_app/models/user_model.dart';
import 'package:social_app/modules/Post_screen.dart';
import 'package:social_app/modules/chat_screen.dart';
import 'package:social_app/modules/feed_screen.dart';
import 'package:social_app/modules/profile_screen.dart';
import 'package:social_app/modules/users_screen.dart';
import 'package:social_app/shared/components/constents.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

part 'social_state.dart';

class SocialCubit extends Cubit<SocialState> {
  SocialCubit() : super(SocialInitialStates());

  static SocialCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUserData() {
    emit(SocialGetUserLoadingState());
    FirebaseFirestore.instance.collection('user').doc(uId).get().then((value) {
      userModel = UserModel.fromJson(value.data()!);
      print(value.data());
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    ChatScreen(),
    PostScreen(),
    UserScreen(),
    ProfileScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chat',
    'New posts',
    'Users',
    'Setting',
  ];

  void changeNavBottom(int index) {
    if (index == 1) getAllUsers();
    if (index == 2)
      emit(SocialNewPostState());
    else {
      currentIndex = index;
      emit(SocialChangeNavBottomState());
    }
  }

  File? profileImage;
  final ImagePicker profileImagePicker = ImagePicker();

  Future<void> getProfileImage() async {
    final profilePickedImage =
        await profileImagePicker.pickImage(source: ImageSource.gallery);

    if (profilePickedImage != null) {
      profileImage = File(profilePickedImage.path);
      emit(SocialGetProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialGetProfileImageErrorState());
    }
  }

  File? coverImage;
  final ImagePicker profileCoverPicker = ImagePicker();

  Future<void> getCoverImage() async {
    final profilePickedImage =
        await profileCoverPicker.pickImage(source: ImageSource.gallery);

    if (profilePickedImage != null) {
      coverImage = File(profilePickedImage.path);
      emit(SocialGetProfileImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialGetProfileImageErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print('<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>');
        print('<<$value >>');
        emit(SocialUploadProfileImageSuccessState());
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          image: value,
        );
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorState(error.toString()));
    });
  }

  void uploadCoverImage({
    required String name,
    required String phone,
    required String bio,
  }) {
    emit(SocialUpdateUserLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('user/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        emit(SocialUploadCoverImageSuccessState());
        updateUserData(
          name: name,
          phone: phone,
          bio: bio,
          cover: value,
        );
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorState(error.toString()));
    });
  }

  void updateUserData({
    required String name,
    required String phone,
    required String bio,
    String? image,
    String? cover,
  }) {
    emit(SocialUpdateUserLoadingState());

    UserModel model = UserModel(
      name: name,
      phone: phone,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      email: userModel!.email,
      bio: bio,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUpdateUserErrorState(error.toString()));
    });
    print(model.image);
  }

  File? postImage;
  final postImagePicker = ImagePicker();

  void removePostImage() {
    postImage = null;
    emit(SocialRemovePostImageState());
  }

  Future<void> getPostImage() async {
    final profilePickedImage =
        await postImagePicker.pickImage(source: ImageSource.gallery);

    if (profilePickedImage != null) {
      postImage = File(profilePickedImage.path);
      emit(SocialPostPickedImageSuccessState());
    } else {
      print('No image selected');
      emit(SocialPostPickedImageErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String date,
  }) {
    emit(SocialCreatePostLoadingState());
    firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createPost(
          text: text,
          date: date,
          postImage: value,
        );
      }).catchError((error) {
        emit(SocialCreatePostErrorState(error.toString()));
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorState(error.toString()));
    });
  }

  PostModel? postModel;

  void createPost({
    required String text,
    required String date,
    String? postImage,
  }) {
    emit(SocialCreatePostLoadingState());

    PostModel postModel = PostModel(
      name: userModel!.name,
      text: text,
      date: date,
      postImage: postImage ?? '',
      image: userModel!.image,
      uId: userModel!.uId,
    );
    FirebaseFirestore.instance
        .collection('post')
        .add(postModel.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessState());
    }).catchError((error) {
      emit((SocialCreatePostErrorState(error.toString())));
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  void getAllPosts() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('post').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          posts.add(PostModel.fromJson(element.data()));
          likes.add(value.docs.length);
          postId.add(element.id);
        }).catchError((error) {});
        postId.add(element.id);
        posts.add(PostModel.fromJson(element.data()));
      }

      // value.docs.forEach((element) {
      //   element.reference.collection('likes').get().then((value) {
      //     posts.add(PostModel.fromJson(element.data()));
      //     likes.add(value.docs.length);
      //     postId.add(element.id);
      //   }).catchError((error) {});
      //   postId.add(element.id);
      //   posts.add(PostModel.fromJson(element.data()));
      // });
      emit(SocialGetPostsSuccessState());
    }).catchError(
      (error) {
        emit(SocialGetPostsErrorState(error.toString()));
      },
    );
  }

  List<UserModel> users = [];

  void getLikePost({required String postId}) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uId)
        .set({
      'like': true,
    }).then(
      (value) {
        emit(SocialLikePostSuccessState());
      },
    ).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void getAllUsers() {
    emit(SocialGetPostsLoadingState());
    FirebaseFirestore.instance.collection('user').get().then((value) {
      value.docs.forEach((element) {
        // if (element.data()['uId'] != userModel!.uId)
        users = [];
        users.add(UserModel.fromJson(element.data()));
      });
      emit(SocialGetUsersSuccessState());
    }).catchError((error) {
      emit(SocialGetUsersErrorState(error.toString()));
    });
  }

  void sendMessage({
    String? text,
    String? dataTime,
    String? receiverId,
  }) {
    MessageModel messageModel = MessageModel(
      text: text,
      dataTime: dataTime,
      receiverId: receiverId,
      senderIn: userModel!.uId,
    );

    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('message')
        .add(messageModel.toMapMessage())
        .then(
      (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialSendMessageErrorState());
      },
    );
    // FirebaseFirestore.instance
    //     .collection('user')
    //     .doc(userModel!.uId)
    //     .collection('chats')
    //     .doc(receiverId)
    //     .collection('messages')
    //     .add(model.toMapMessage())
    //     .then((value) {
    //   emit(SocialSendMessageSuccessState());
    // }).catchError(() {
    //   emit(SocialSendMessageErrorState());
    // });

    FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uId)
        .collection('message')
        .add(messageModel.toMapMessage())
        .then(
      (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
      (error) {
        emit(SocialSendMessageErrorState());
      },
    );
  }

  List<MessageModel> messages = [];

  void getMessages({
    String? receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessState());
    });
  }

  bool pending = false;
  void pendingFriend({
    required String receiverId,
    required String dataTime,
    String? imageComment,
    required String name,
    required String image,
  }) {
    SendRequestFriend sendRequestFriend = SendRequestFriend(
        receiverId: receiverId,
        senderIn: userModel!.uId,
        dataTime: dataTime,
        name: name,
        image: image);
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('pendingFriends')
        .doc(receiverId)
        .collection('friend')
        .add(sendRequestFriend.toMap())
        .then(
          (value) {
        pending = true;
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
          (error) {
        emit(SocialSendMessageErrorState());
      },
    );

    FirebaseFirestore.instance
        .collection('user')
        .doc(receiverId)
        .collection('confirmedFriends')
        .doc(receiverId)
        .collection('friend')
        .add(sendRequestFriend.toMap())
        .then(
          (value) {
        emit(SocialSendMessageSuccessState());
      },
    ).catchError(
          (error) {
        emit(SocialSendMessageErrorState());
      },
    );
  }


  List<SendRequestFriend> not = [];

  void getRequestNot() {
    FirebaseFirestore.instance
        .collection('user')
        .doc(userModel!.uId)
        .collection('confirmedFriends')
        .orderBy('dataTime')
        .snapshots()
        .listen((event) {
      not = [];
      event.docs.forEach((element) {
        not.add(SendRequestFriend.fromJson(element.data()));
        // print(messages.toList());
      });
      emit(SocialGetNotificationSuccessStates());
    });
  }
}
