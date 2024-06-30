//
//  PokemonDetailViewModelTests.swift
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

class PokemonDetailViewModelTests: XCTestCase {
    var viewModel: PokemonDetailViewModel!
    var scheduler: TestScheduler!
    let disposeBag = DisposeBag()
    let mockApiProvider = MockApiProvider()

    override func setUp() {
        super.setUp()
        viewModel = PokemonDetailViewModel(pId: "1")
        scheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        scheduler = nil
        super.tearDown()
    }
    
    func testfetchPokemonCellData() {
        // Mock the API response
        mockApiProvider.responses = [MockApiProvider.readJSONFromFile(fileName: "pokemon"),
                                     MockApiProvider.readJSONFromFile(fileName: "species")]
        mockApiProvider.isRequestSuccess = true
        viewModel.apiProvider = mockApiProvider
        

        // Create observers to record emitted events
        let titleObserver = scheduler.createObserver(NSAttributedString.self)
        let typesObserver = scheduler.createObserver(String.self)
        let pokemonImgUrlObserver = scheduler.createObserver(String.self)
        
        // Bind the observer
        viewModel.title.bind(to: titleObserver).disposed(by: disposeBag)
        viewModel.types.bind(to: typesObserver).disposed(by: disposeBag)
        viewModel.pokemonImgUrl.bind(to: pokemonImgUrlObserver).disposed(by: disposeBag)
        

        // Call the method
        viewModel.fetchPokemonDetailData()
        
        // Check the emitted events
        let titleEmitted = titleObserver.events.compactMap { $0.value.element }
        let typesEmitted = typesObserver.events.compactMap { $0.value.element }
        let pokemonImgUrlEmitted = pokemonImgUrlObserver.events.compactMap { $0.value.element }
        
        
        XCTAssertNotNil(titleEmitted.last)
        XCTAssertNotNil(typesEmitted.last)
        XCTAssertNotNil(pokemonImgUrlEmitted.last)
        
        XCTAssertEqual(titleEmitted.last?.string, "Bulbasaur  #0001")
        XCTAssertEqual(typesEmitted.last ?? "", "Grass Poison")
        XCTAssertEqual(pokemonImgUrlEmitted.last ?? "", "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/1.png")
    }
}
