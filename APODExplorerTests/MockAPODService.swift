import Foundation
@testable import APODExplorer

class MockAPODService: APODService {

    var mockFetchPictureOfTheDayResult: Result<APODInfo, Error>?
    var mockFetchRecentAPODsResult: Result<[APODInfo], Error>?

    override func fetchDailyAPOD(
        completion: @escaping (Result<APODInfo, Error>) -> Void
    ) {
        if let result = mockFetchPictureOfTheDayResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockAPODServiceError", code: -1, userInfo: nil)))
        }
    }

    override func fetchRecentAPODs(
        startDate: String,
        endDate: String,
        completion: @escaping (Result<[APODInfo], Error>) -> Void
    ) {
        if let result = mockFetchRecentAPODsResult {
            completion(result)
        } else {
            completion(.failure(NSError(domain: "MockAPODServiceError", code: -1, userInfo: nil)))
        }
    }
}
