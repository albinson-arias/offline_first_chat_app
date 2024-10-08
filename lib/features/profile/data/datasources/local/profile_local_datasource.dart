abstract interface class ProfileLocalDatasource {
  Future<void> updateProfilePicture(String? imageUrl);
  Future<void> updateBio(String bio);
}
