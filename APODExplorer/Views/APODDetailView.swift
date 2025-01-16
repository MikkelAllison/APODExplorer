import SwiftUI

struct APODDetailView: View {
    let apod: APODInfo

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let hdString = apod.hdurl, let hdURL = URL(string: hdString) {
                    AsyncImage(url: hdURL) { phase in
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
                    .frame(maxWidth: .infinity)
                    
                } else if let url = URL(string: apod.url) {
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
                    .frame(maxWidth: .infinity)
                }


                Text(apod.title)
                    .font(.title)
                    .padding(.horizontal)

                Text("Date: \(apod.date)")
                    .font(.subheadline)
                    .padding(.horizontal)

                Text(apod.explanation)
                    .font(.body)
                    .padding(.horizontal)
            }
        }
        .navigationTitle(apod.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct APODDetailView_Previews: PreviewProvider {
    static var previews: some View {
        APODDetailView(apod: APODInfo(
            title: "Sample APOD",
            date: "2025-01-01",
            explanation: "Sample sample sample sample...",
            url: "https://apod.nasa.gov/apod/image/2301/sample.jpg",
            hdurl: nil,
            mediaType: "image",
            copyright: nil
        ))
    }
}

