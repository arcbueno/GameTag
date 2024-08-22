class PlatformQueries {
  static const String getPlatforms = r'''
    query GetAllPlatforms {
      platforms {
        edges {
          node {
            objectId
            name
            PlatformInt
          }
        }
      } 
    }
  ''';
}
