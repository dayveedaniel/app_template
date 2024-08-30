abstract interface class ISearch {
  bool isSearchShown = false;

  void handleSearch(String query);

  void resetList();

  void searchForData(String query);
}
