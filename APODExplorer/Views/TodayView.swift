import SwiftUI

struct TodayView: View {
    @StateObject private var viewModel = TodayViewModel()
    
    var body: some View {
        VStack {
            if let apod = viewModel.apod {
                
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
                ProgressView("Loading APOD...")
            }
        }
        .onAppear {
            viewModel.fetchDailyAPOD()
        }
    }
}

struct TodayView_Previews: PreviewProvider {
    static var previews: some View {
        TodayView()
    }
}
