//
//  PokemonBookTests.swift
//  PokemonBookTests
//
//  Created by Raymondting on 2024/6/29.
//

import XCTest
import RxSwift
import RxTest
import SwiftyJSON
import Moya
@testable import PokemonBook

class PokemonCellViewModelTests: XCTestCase {
    var viewModel: PokemonCellViewModel!
    var scheduler: TestScheduler!
    let disposeBag = DisposeBag()
    let mockApiProvider = MockApiProvider()

    override func setUp() {
        super.setUp()
        viewModel = PokemonCellViewModel()
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testfetchPokemonCellData() {
        // Mock the API response
        mockApiProvider.responseJSON = MockApiProvider.readJSONFromFile(fileName: "pokemon")
        mockApiProvider.isRequestSuccess = true
        viewModel.apiProvider = mockApiProvider

        // Create observers to record emitted events
        let displayIdObserver = scheduler.createObserver(String.self)
        let nameObserver = scheduler.createObserver(String.self)
        let pokemonImgUrlObserver = scheduler.createObserver(String.self)
        let typesObserver = scheduler.createObserver(String.self)
        
        // Bind the observer
        viewModel.displayId.bind(to: displayIdObserver).disposed(by: disposeBag)
        viewModel.name.bind(to: nameObserver).disposed(by: disposeBag)
        viewModel.pokemonImgUrl.bind(to: pokemonImgUrlObserver).disposed(by: disposeBag)
        viewModel.types.bind(to: typesObserver).disposed(by: disposeBag)

        // Call the method
        viewModel.fetchPokemonCellData("1")
        
        // Check the emitted events
        let displayIdEmitted = displayIdObserver.events.compactMap { $0.value.element }
        let nameEmitted = nameObserver.events.compactMap { $0.value.element }
        let pokemonImgUrlEmitted = pokemonImgUrlObserver.events.compactMap { $0.value.element }
        let typesEmitted = typesObserver.events.compactMap { $0.value.element }
        
        XCTAssertTrue(mockApiProvider.callRequest)
        
        XCTAssertNotNil(displayIdEmitted.last)
        XCTAssertNotNil(nameEmitted.last)
        XCTAssertNotNil(pokemonImgUrlEmitted.last)
        XCTAssertNotNil(typesEmitted.last)
        
        XCTAssertEqual(displayIdEmitted.last ?? "", "#0001")
        XCTAssertEqual(nameEmitted.last ?? "", "Bulbasaur")
        XCTAssertEqual(pokemonImgUrlEmitted.last ?? "", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
        XCTAssertEqual(typesEmitted.last ?? "", "Grass Poison")
    }
}
