import Foundation

class APODService {
  
    let apiKey = "hDZehTug6rO5Ng9uEOvOjh2EdNWki8Led1D3vyWl"
 
    /// Fetches the daily APOD from NASA's API.
    func fetchDailyAPOD(completion: @escaping (Result<APODInfo, Error>) -> Void) {
      
        let baseURL = "https://api.nasa.gov/planetary/apod"
        guard var urlComponents = URLComponents(string: baseURL) else {
            fatalError("Could not construct URLComponents with baseURL: \(baseURL)")
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = urlComponents.url else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                   guard (200...299).contains(httpResponse.statusCode) else {
                       let statusError = NSError(
                           domain: "APODServiceError",
                           code: httpResponse.statusCode,
                           userInfo: [NSLocalizedDescriptionKey: "HTTP status code \(httpResponse.statusCode)"]
                       )
                       completion(.failure(statusError))
                       return
                   }
               }

            guard let data = data else {
                return
            }

            do {
                let apodInfo = try JSONDecoder().decode(APODInfo.self, from: data)
                completion(.success(apodInfo))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
    
    /// Fetches the APOD's from the past 30 days from NASA's API.
    func fetchRecentAPODs(
        startDate: String,
        endDate: String,
        completion: @escaping (Result<[APODInfo], Error>) -> Void
    ) {
        let baseURL = "https://api.nasa.gov/planetary/apod"
        guard var urlComponents = URLComponents(string: baseURL) else { return }
     
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "start_date", value: startDate),
            URLQueryItem(name: "end_date", value: endDate)
        ]
        
        guard let url = urlComponents.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let apodArray = try JSONDecoder().decode([APODInfo].self, from: data)
                completion(.success(apodArray))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }

    func last30DaysDateRange() -> (String, String)? {
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
