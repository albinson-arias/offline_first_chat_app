// ignore_for_file: one_member_abstracts

abstract interface class ProfileLocalDatasource {
  Future<void> updateProfilePicture(String imageUrl);
  Future<void> updateBio(String bio);
}
