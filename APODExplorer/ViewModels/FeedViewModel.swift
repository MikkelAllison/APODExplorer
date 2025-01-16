import SwiftUI
import Combine

class FeedViewModel: ObservableObject {
    @Published var apods: [APODInfo] = []
    
    private let service: APODService
    
    init(service: APODService = APODService()) {
           self.service = service
       }
    
    func fetchRecentAPODs() {
        guard let (start, end) = last30DaysDateRange() else { return }
        
        service.fetchRecentAPODs(startDate: start, endDate: end) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let apodArray):
                    self?.apods = apodArray
                    print("Fetched \(apodArray.count) items")
                case .failure(let error):
                    print("Error fetching recent APODs: \(error)")
                }
            }
        }

    }
    
    private func last30DaysDateRange() -> (String, String)? {
        let today = Date()
        guard let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -29, to: today) else {
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let start = formatter.string(from: thirtyDaysAgo)
        let end = formatter.string(from: today)
        return (start, end)
    }
}

