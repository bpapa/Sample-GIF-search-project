#  GIF Search

Simple app to search for GIFs via the Giphy API. Enter a search term, and the GIFs will be displayed in a grid.

The user enters the query into a search bar that is installed in the Navigation Bar via UISearchController. The results are then displayed by a UICollectionViewController subclass. That View Controller's parent is a container UIViewController subclass that manages the UI state with an enum.

The collection view controller's flow layout is configured with an item size of 100x100 to work well across modern devices. Per the Giphy Rendition guide, the GIFs are displayed using the fixed width version encoded as an MP4. Each cell in the collection view controller is configured with an AVPlayerLooper that renders the content.

