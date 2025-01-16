# APODExplorer

A simple SwiftUI application that displays NASA’s Astronomy Picture of the Day (APOD). It fetches:
- **Today’s APOD** on the **Today** tab.
- **A list of 30 most recent APODs** on the **Feed** tab.

## 1. How to Run / Build the Project

- **Xcode Version**: Built and tested on Xcode 16+.

To run the project:
1. Open `APODExplorer.xcodeproj` in Xcode.
2. Select an iOS simulator or a physical device.
3. Press the **Run** button ( ▶ ) or use `Cmd + R`.

## 2. Project Structure

Here's an overview of where the main logic sits:

- **Models/**  
  - `APODInfo.swift`: Data model representing the APOD response fields (title, date, explanation, etc.).

- **Services/**  
  - `APODService.swift`: Handles the network calls to NASA’s APOD API. Includes:
    - `fetchDailyAPOD(...)`: Fetches today’s APOD.
    - `fetchRecentAPODs(...)`: Fetches a list of APOD entries for a given date range.
    - `last30DaysDateRange()`: Helper to generate the last 30 days’ date range.

- **ViewModels/**  
  - `FeedViewModel.swift`: Orchestrates fetching the recent (last 30 days) APOD entries and exposes them to the FeedView.
  - `TodayViewModel.swift`: Responsible for fetching today’s APOD and exposing it to the TodayView.

- **Views/**  
  - `TodayView.swift`: Displays today’s APOD image and explanation.
  - `FeedView.swift`: Shows the list of recent APODs. Tapping on an item navigates to its detail view.
  - `APODDetailView.swift`: A detailed view of a single APOD, showing an image (or HD image if available) and full text.
  - `MainTabView.swift`: A tab-based container for the “Today” and “Feed” views.

- **APODExplorerTests/**  
  - `APODServiceTests.swift`: Unit tests focusing on the `APODService` and related decoding logic.

## 3. Known Limitations or Issues

- **Hardcoded API Key**: The NASA API key is stored directly in `APODService.swift`. In a production app, I'd typically store this securely or use a configuration file/secret manager.
- **No Offline Handling**: If the network is unavailable or the NASA API is down, the app will show a loading indicator or fail silently in some places without an adequete fallback UI.
- **Media Type Limitations**: Assumes most APODs are images. For items where `media_type = "video"`, no special handling is implemented.
- **Minimal Error Handling**: Errors are primarily printed to the console or displayed as text messages. A more user-friendly error UI could be added.

## 4. Future Improvements

- **Better Error & Offline Handling**: Display user-friendly error messages and caching for offline usage.
- **Enhanced UI/UX**: Create custom loading indicators, error states, and improved layout for videos or different media types.
- **API Key Management**: Move sensitive data (like the NASA API key) to a secure location or environment variable.
- **UI Tests**: Although we have some unit tests, UI tests could be added to validate user flows.
- **Image Caching**: For repeated viewing of the same images, implement an image cache to improve performance.

