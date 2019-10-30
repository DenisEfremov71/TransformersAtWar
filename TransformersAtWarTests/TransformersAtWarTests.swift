//
//  TransformersAtWarTests.swift
//  TransformersAtWarTests
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import XCTest
@testable import TransformersAtWar

class TransformersAtWarTests: XCTestCase {
    
    var optimusPrime: Transformer?
    var predaking: Transformer?
    var autobotWeak: Transformer?
    var autobotStrong: Transformer?
    var decepticonWeak: Transformer?
    var decepticonStrong: Transformer?

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        optimusPrime = Transformer.init(id: "123456", name: Constants.TransformerNames.optimusPrime, team: "A", team_icon: nil, courage: 10, endurance: 10, firepower: 8, intelligence: 10, rank: 10, skill: 10, speed: 8, strength: 10)
        predaking = Transformer.init(id: "987654", name: Constants.TransformerNames.predaking, team: "D", team_icon: nil, courage: 10, endurance: 5, firepower: 10, intelligence: 8, rank: 7, skill: 9, speed: 9, strength: 8)
        autobotWeak = Transformer.init(id: "qwerty", name: "Weak Autobot", team: "A", team_icon: nil, courage: 1, endurance: 1, firepower: 1, intelligence: 1, rank: 1, skill: 1, speed: 1, strength: 1)
        autobotStrong = Transformer.init(id: "dfretu", name: "Strong Autobot", team: "A", team_icon: nil, courage: 10, endurance: 10, firepower: 10, intelligence: 10, rank: 10, skill: 10, speed: 10, strength: 10)
        decepticonWeak = Transformer.init(id: "sdguyjk", name: "Ramjet", team: "D", team_icon: nil, courage: 1, endurance: 1, firepower: 1, intelligence: 1, rank: 1, skill: 1, speed: 1, strength: 1)
        decepticonStrong = Transformer.init(id: "sgykyulo", name: "Ramjet", team: "D", team_icon: nil, courage: 10, endurance: 10, firepower: 10, intelligence: 10, rank: 10, skill: 10, speed: 10, strength: 10)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testOptimusPrimeVsPredaking() {
        // Given
        // Optimus Prime is facing Predaking
        var transformers = [Transformer]()
        transformers.append(optimusPrime!)
        transformers.append(predaking!)
        
        // When they fight against each other
        let presenter = TransformerListPresenter()
        presenter.wageTheWar(transformers: transformers) { (output) in
            // Then the war output will be "All Destroyed"
            XCTAssertEqual(output, "War is over. \(Constants.WarResults.allDestroyed)", "The war result is not all destroyed!")
        }
    }
    
    func testOptimusPrimeVsDecepticon() {
        // Given
        // Optimus Prime is facing decepticon other than Predaking
        var transformers = [Transformer]()
        transformers.append(optimusPrime!)
        transformers.append(decepticonStrong!)
        
        // When they fight against each other
        let presenter = TransformerListPresenter()
        presenter.wageTheWar(transformers: transformers) { (output) in
            // Then the war output will be "autobots won"
            XCTAssertEqual(output, "War is over. \(Constants.WarResults.autobotsWon)", "The war result is not autobots won!")
        }
    }
    
    func testAutobotVsPredaking() {
        // Given
        // An autobot other than Optimus Prime is facing Predaking
        var transformers = [Transformer]()
        transformers.append(autobotStrong!)
        transformers.append(predaking!)
        
        // When they fight against each other
        let presenter = TransformerListPresenter()
        presenter.wageTheWar(transformers: transformers) { (output) in
            // Then the war output will be "decepticons won"
            XCTAssertEqual(output, "War is over. \(Constants.WarResults.decepticonsWon)", "The war result is not decepticons won!")
        }
    }
    
    func testStrongAutobotVsWeakDecepticon() {
        // Given
        // A strong autobot is facing a weaker decepticon
        var transformers = [Transformer]()
        transformers.append(autobotStrong!)
        transformers.append(decepticonWeak!)
        
        // When they fight against each other
        let presenter = TransformerListPresenter()
        presenter.wageTheWar(transformers: transformers) { (output) in
            // Then the war output will be "autobots won"
            XCTAssertEqual(output, "War is over. \(Constants.WarResults.autobotsWon)", "The war result is not autobots won!")
        }
    }
    
    func testStrongDecepticonVsWeakAutobot() {
        // Given
        // A strong decepticon is facing a weaker autobot
        var transformers = [Transformer]()
        transformers.append(autobotWeak!)
        transformers.append(decepticonStrong!)
        
        // When they fight against each other
        let presenter = TransformerListPresenter()
        presenter.wageTheWar(transformers: transformers) { (output) in
            // Then the war output will be "decepticons won"
            XCTAssertEqual(output, "War is over. \(Constants.WarResults.decepticonsWon)", "The war result is not decepticons won!")
        }
    }
    
    func testTie() {
        // Given
        // A strong autobot is facing an equally strong decepticon
        var transformers = [Transformer]()
        transformers.append(autobotStrong!)
        transformers.append(decepticonStrong!)
        
        // When they fight against each other
        let presenter = TransformerListPresenter()
        presenter.wageTheWar(transformers: transformers) { (output) in
            // Then the war output will be "it is a tie"
            XCTAssertEqual(output, "War is over. \(Constants.WarResults.nobodyWon)", "The war result is not it is a tie!")
        }
    }

}
