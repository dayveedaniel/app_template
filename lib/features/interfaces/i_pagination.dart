abstract interface class IPagination {
  bool get canLoadMore;

  void getMore();
}
