import SwiftUI

struct TodayView: View {
    // 1. Create an instance of TodayViewModel
    @StateObject private var viewModel = TodayViewModel()
    
    var body: some View {
        VStack {
            // 2. Check if `apod` is loaded
            if let apod = viewModel.apod {
                // 3. Display the APOD data (title, explanation, image, etc.)
                
                // For example: AsyncImage (iOS 15+)
                if let url = URL(string: apod.url) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                        case .failure(_):
                            Image(systemName: "exclamationmark.triangle")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.red)
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                }
                
                Text(apod.title)
                    .font(.headline)
                    .padding(.top, 8)
                
                ScrollView {
                    Text(apod.explanation)
                        .font(.body)
                        .padding()
                }
                
            } else {
                // 4. Show a loading indicator if `apod` is nil
                ProgressView("Loading APOD...")
            }
        }
        .onAppear {
            // 5. Fetch the APOD when the view appears
            viewModel.fetchTodayAPOD()
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        // Preview with a fresh instance of TodayView
        TodayView()
    }
}
