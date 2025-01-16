import SwiftUI
import Combine

class TodayViewModel: ObservableObject {
    @Published var apod: APODInfo? = nil

    private let apodService: APODService
    
    init(apodService: APODService = APODService()) {
         self.apodService = apodService
     }

    func fetchTodayAPOD() {
        print("fetchTodayAPOD called")
        apodService.fetchPictureOfTheDay { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.apod = info
                case .failure(let error):
                    print("Error fetching APOD: \(error)")
                }
            }
        }
    }
}

