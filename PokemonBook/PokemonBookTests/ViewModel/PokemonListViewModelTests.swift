//
//  PokemonListViewModelTests.swift
//  PokemonBookTests
//
//  Created by Raymondting on 2024/6/30.
//

import XCTest
import RxSwift
import RxTest
import SwiftyJSON
import Moya
@testable import PokemonBook

class PokemonListViewModelTests: XCTestCase {
    var viewModel: PokemonListViewModel!
    var scheduler: TestScheduler!
    let disposeBag = DisposeBag()
    let mockApiProvider = MockApiProvider()

    override func setUp() {
        super.setUp()
        viewModel = PokemonListViewModel()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testfetchPokemonCellData() {
        // Mock the API response
        mockApiProvider.responseJSON = MockApiProvider.readJSONFromFile(fileName: "list")
        mockApiProvider.isRequestSuccess = true
        viewModel.apiProvider = mockApiProvider

        // Create observers to record emitted events
        let pokemonIdObserver = scheduler.createObserver([String].self)
        
        // Bind the observer
        viewModel.pokemonDataProvider.pokemonIdList.bind(to: pokemonIdObserver).disposed(by: disposeBag)
        

        // Call the method
        viewModel.fetchPokemonList()
        
        // Check the emitted events
        let pokemonIdEmitted = pokemonIdObserver.events.compactMap { $0.value.element }
        
        XCTAssertTrue(mockApiProvider.callRequest)
        
        XCTAssertNotNil(pokemonIdEmitted.last)
        
        XCTAssertEqual(pokemonIdEmitted.last?.count, 50)
        XCTAssertEqual(pokemonIdEmitted.last?.prefix(5), ["1","2","3","4","5"])
    }
}
