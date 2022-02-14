part of 'social_cubit.dart';

@immutable
abstract class SocialState {}

class SocialInitialStates extends SocialState {}

class SocialChangeNavBottomState extends SocialState {}

class SocialNewPostState extends SocialState {}

class SocialLoadingHomeDataState extends SocialState {}
class SocialSuccessHomeDataState extends SocialState {}
class SocialErrorHomeDataState extends SocialState {
  final String error;

  SocialErrorHomeDataState(this.error);
}

//getUsers
class SocialGetUserLoadingState extends SocialState {}
class SocialGetUserSuccessState extends SocialState {}
class SocialGetUserErrorState extends SocialState {
  final String error;

  SocialGetUserErrorState(this.error);

}

//getPosts
class SocialGetPostsLoadingState extends SocialState {}
class SocialGetPostsSuccessState extends SocialState {}
class SocialGetPostsErrorState extends SocialState {
  final String error;

  SocialGetPostsErrorState(this.error);

}

//getUsers
class SocialGetUsersLoadingState extends SocialState {}
class SocialGetUsersSuccessState extends SocialState {}
class SocialGetUsersErrorState extends SocialState {
  final String error;

  SocialGetUsersErrorState(this.error);

}

//like post
class SocialLikePostSuccessState extends SocialState {}
class SocialLikePostErrorState extends SocialState {
  final String error;

  SocialLikePostErrorState(this.error);

}

class SocialGetProfileImageSuccessState extends SocialState {}
class SocialGetProfileImageErrorState extends SocialState {}

class SocialGetCoverImageSuccessState extends SocialState {}
class SocialGetCoverImageErrorState extends SocialState {}

class SocialUploadProfileImageSuccessState extends SocialState {}
class SocialUploadProfileImageErrorState extends SocialState {
  final String error;

  SocialUploadProfileImageErrorState(this.error);
}

class SocialUploadCoverImageSuccessState extends SocialState {}
class SocialUploadCoverImageErrorState extends SocialState {
  final String error;

  SocialUploadCoverImageErrorState(this.error);
}

class SocialUpdateUserLoadingState extends SocialState {}
class SocialUpdateUserErrorState extends SocialState {
  final String error;

  SocialUpdateUserErrorState(this.error);
}

//postPickedImage
class SocialPostPickedImageSuccessState extends SocialState {}
class SocialPostPickedImageErrorState extends SocialState {}

//create post
class SocialCreatePostLoadingState extends SocialState {}
class SocialCreatePostSuccessState extends SocialState {}
class SocialCreatePostErrorState extends SocialState {
  final String error;

  SocialCreatePostErrorState(this.error);

}

class SocialRemovePostImageState extends SocialState {}

//send message
class SocialSendMessageErrorState extends SocialState {}
class SocialSendMessageSuccessState extends SocialState {}


class SocialGetMessageSuccessState extends SocialState {}

class SocialGetNotificationSuccessStates extends SocialState {}



