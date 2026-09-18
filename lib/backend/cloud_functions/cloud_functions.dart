/// Cloud Functions are not used. Supabase Edge Functions would replace them
/// if server-side calls are needed again.
class FFCloudFunction<T> {
  const FFCloudFunction(this.name);
  final String name;

  Future<T?> call([Map<String, dynamic>? params]) async => null;
}
