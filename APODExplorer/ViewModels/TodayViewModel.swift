import SwiftUI
import Combine

/// A ViewModel responsible for fetching today's APOD (Astronomy Picture of the Day).
class TodayViewModel: ObservableObject {
    @Published var apod: APODInfo? = nil
    @Published var errorMessage: String? = nil


    private let apodService: APODService
    
    init(apodService: APODService = APODService()) {
         self.apodService = apodService
     }

    func fetchDailyAPOD() {
        print("fetchTodayAPOD called")
        apodService.fetchDailyAPOD { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let info):
                    self?.apod = info
                case .failure(let error):
                    self?.errorMessage = "Error fetching APOD: \(error.localizedDescription)"
                }
            }
        }
    }
}

