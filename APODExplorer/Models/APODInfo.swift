import Foundation

struct APODInfo: Codable {
    let title: String
    let date: String
    let explanation: String
    let url: String
    let hdurl: String?
    let mediaType: String
    let copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case date
        case explanation
        case url
        case hdurl
        case mediaType = "media_type"
        case copyright
    }
}

