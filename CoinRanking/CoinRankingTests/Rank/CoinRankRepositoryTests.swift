//
//  CoinRankingTests.swift
//  CoinRankingTests
//
//  Created by Ashish Karna on 20/02/2025.
//

import XCTest
import Combine
@testable import CoinRanking  // Replace with your actual module name

class CoinRankRepositoryTests: XCTestCase {
    
    var mockNetworkManager: MockNetworkManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        cancellables = Set<AnyCancellable>()
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchCoinList_Success() {
        // Given
        let rawJSON = """
        {
            "data": {
                "coins": [
                    {
                        "uuid": "Qwsogvtv82FCd",
                        "name": "Bitcoin",
                        "symbol": "BTC",
                        "price": "45000.00",
                        "change": "2.5",
                        "iconUrl": "https://example.com/bitcoin.png",
                        "color": "#f7931a",
                        "sparkline": ["45000", "45100", "45200"],
                        "allTimeHigh": null,
                        "marketCap": "1000000000000",
                        "priceAt": null
                    }
                ]
            }
        }
        """
        
        guard let jsonData = rawJSON.data(using: .utf8) else {
            XCTFail("Failed to encode mock JSON data")
            return
        }
        
        mockNetworkManager.mockData = jsonData
        mockNetworkManager.mockError = nil
        
        let expectation = XCTestExpectation(description: "Fetch coin list success")
        
        // When
        mockNetworkManager.request(.getCoinList(CoinListParameters(limit: 10, offset: 1, orderBy: "marketCap")))
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { (response: CoinResponse) in
                XCTAssertEqual(response.data.coins.count, 1)
                XCTAssertEqual(response.data.coins.first?.name, "Bitcoin")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
    }



    func testFetchCoinList_Failure() {
        // Given
        mockNetworkManager.mockData = nil  // No data to force failure
        mockNetworkManager.mockError = .noInternetConnection  // Simulate no internet connection
        
        let expectation = XCTestExpectation(description: "Fetch coin list failure")
        
        // When
        mockNetworkManager.request(.getCoinList(CoinListParameters(limit: 10, offset: 1, orderBy: "marketCap")))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .noInternetConnection)  // Validate the correct error
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { (response: CoinResponse) in
                XCTFail("Expected failure but received a value")
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
    }

    
    func testFetchCoinDetail_Success() {
        // Given
        let rawJSON = """
        {
            "data": {
                "coin": {
                        "uuid": "Qwsogvtv82FCd",
                        "name": "Bitcoin",
                        "symbol": "BTC",
                        "price": "45000.00",
                        "change": "2.5",
                        "iconUrl": "https://example.com/bitcoin.png",
                        "color": "#f7931a",
                        "sparkline": ["45000", "45100", "45200"],
                        "allTimeHigh": null,
                        "marketCap": "1000000000000",
                        "priceAt": null
                    }
            }
        }
        """
        
        guard let jsonData = rawJSON.data(using: .utf8) else {
            XCTFail("Failed to encode mock JSON data")
            return
        }
        
        mockNetworkManager.mockData = jsonData
        mockNetworkManager.mockError = nil
        
        let expectation = XCTestExpectation(description: "Fetch coin detail success")
        
        // When
        mockNetworkManager.request(.getCoinDetail("Qwsogvtv82FCd", CoinDetailParameter(timePeriod: "24h")))
            .sink(receiveCompletion: { completion in
                if case .failure = completion {
                    XCTFail("Expected success but got failure")
                }
            }, receiveValue: { (response: CoinDetailResponse) in
                XCTAssertEqual(response.data.coin.uuid, "Qwsogvtv82FCd")
                XCTAssertEqual(response.data.coin.name, "Bitcoin")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchCoinDetail_Failure() {
        // Given
        mockNetworkManager.mockData = nil  // No data to force failure
        mockNetworkManager.mockError = .invalidURL // Simulate no invalid url
        
        let expectation = XCTestExpectation(description: "Fetch coin detail failure")
        
        // When
        mockNetworkManager.request(.getCoinDetail("Qwsogvtv82FCd", CoinDetailParameter(timePeriod: "24h")))
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTAssertEqual(error, .invalidURL)  // Validate the correct error
                    expectation.fulfill()
                } else {
                    XCTFail("Expected failure but got success")
                }
            }, receiveValue: { (response: CoinDetailResponse) in
                XCTFail("Expected failure but received a value")
            })
            .store(in: &cancellables)
        
        // Then
        wait(for: [expectation], timeout: 5.0)
    }
}

