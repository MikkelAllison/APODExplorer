import SwiftUI

struct FeedView: View {
    @StateObject private var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.apods, id: \.date) { apodItem in
                NavigationLink(destination: APODDetailView(apod: apodItem)) {
                                    VStack(alignment: .leading) {
                                        Text(apodItem.title)
                                            .font(.headline)
                                        Text(apodItem.date)
                                            .font(.subheadline)
                                    }
                                }
                            }
                            .navigationTitle("APOD Feed")
        }
        .onAppear {
            viewModel.fetchRecentAPODs()
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
