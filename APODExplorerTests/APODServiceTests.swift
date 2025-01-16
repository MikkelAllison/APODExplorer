import XCTest
@testable import APODExplorer
import Foundation

final class APODServiceTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
    }

    func testDecodeSingleAPOD() throws {
        let jsonString = """
        {
            "title": "Test APOD",
            "date": "2025-01-15",
            "explanation": "A test explanation",
            "url": "https://test.com/image.jpg",
            "hdurl": "https://test.com/image_hd.jpg",
            "media_type": "image",
            "copyright": "Test Author"
        }
        """
        
        let jsonData = Data(jsonString.utf8)
        
        let decoder = JSONDecoder()
        let apod = try decoder.decode(APODInfo.self, from: jsonData)
        
        XCTAssertEqual(apod.title, "Test APOD")
        XCTAssertEqual(apod.date, "2025-01-15")
        XCTAssertEqual(apod.explanation, "A test explanation")
        XCTAssertEqual(apod.url, "https://test.com/image.jpg")
        XCTAssertEqual(apod.hdurl, "https://test.com/image_hd.jpg")
        XCTAssertEqual(apod.mediaType, "image")
        XCTAssertEqual(apod.copyright, "Test Author")
    }
    
    func testDecodeAPODArray() throws {
        let jsonString = """
        [
            {
                "title": "APOD 1",
                "date": "2025-01-13",
                "explanation": "Description 1",
                "url": "https://test.com/image1.jpg",
                "media_type": "image"
            },
            {
                "title": "APOD 2",
                "date": "2025-01-14",
                "explanation": "Description 2",
                "url": "https://test.com/image2.jpg",
                "media_type": "image"
            }
        ]
        """
        let jsonData = Data(jsonString.utf8)
        let decoder = JSONDecoder()
        let apodArray = try decoder.decode([APODInfo].self, from: jsonData)
        
        XCTAssertEqual(apodArray.count, 2)
        XCTAssertEqual(apodArray[0].title, "APOD 1")
        XCTAssertEqual(apodArray[1].title, "APOD 2")
        XCTAssertEqual(apodArray[1].mediaType, "image")
    }
    
    func testFetchTodayAPOD_Success() {
        let mockService = MockAPODService()
        
        let testAPOD = APODInfo(
            title: "Mock Title",
            date: "2025-01-15",
            explanation: "Mock Explanation",
            url: "https://test.com/mock.jpg",
            hdurl: nil,
            mediaType: "image",
            copyright: nil
        )
        
        mockService.mockFetchPictureOfTheDayResult = .success(testAPOD)
        let viewModel = TodayViewModel(apodService: mockService)
        
        let expectation = expectation(description: "Wait for fetchTodayAPOD to complete")
        
        viewModel.fetchDailyAPOD()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(viewModel.apod?.title, "Mock Title")
            XCTAssertEqual(viewModel.apod?.date, "2025-01-15")
            XCTAssertEqual(viewModel.apod?.mediaType, "image")
            
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1)
    }
        func testFetchTodayAPOD_Failure() {
            let mockService = MockAPODService()
            mockService.mockFetchPictureOfTheDayResult = .failure(NSError(domain: "TestError", code: 0))
            
            let viewModel = TodayViewModel(apodService: mockService)
          
            viewModel.fetchDailyAPOD()
            
            XCTAssertNil(viewModel.apod)
        }
    
    func testLast30DaysDateRange() throws {
        let service = APODService()
        
        guard let (startDateString, endDateString) = service.last30DaysDateRange() else {
            XCTFail("last30DaysDateRange returned nil")
            return
        }
  
        XCTAssertEqual(startDateString.count, 10, "Start date string should match 'yyyy-MM-dd'")
        XCTAssertEqual(endDateString.count, 10, "End date string should match 'yyyy-MM-dd'")

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = formatter.date(from: startDateString),
              let endDate = formatter.date(from: endDateString) else {
            XCTFail("Could not parse date strings from last30DaysDateRange")
            return
        }
        
        let calendar = Calendar.current
        let difference = calendar.dateComponents([.day], from: startDate, to: endDate).day
        
        XCTAssertEqual(difference, 29, "Expected 29 days difference between start and end date")
        
        let today = calendar.startOfDay(for: Date())
        let endDateStartOfDay = calendar.startOfDay(for: endDate)
        XCTAssertLessThanOrEqual(abs(endDateStartOfDay.timeIntervalSince(today)), 24 * 60 * 60,
                                 "End date should be near today's date.")
    }

}
