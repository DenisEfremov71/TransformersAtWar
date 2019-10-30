//
//  Constants.swift
//  TransformersAtWar
//
//  Created by Denis Efremov on 2019-10-26.
//  Copyright © 2019 Denis Efremov. All rights reserved.
//

import Foundation

struct Constants {
    
    struct ApiEndPoints {
        static let apiPrefix = "https://transformers-api"
        static let fetchToken = "https://transformers-api.firebaseapp.com/allspark"
        static let fetchAllTransformers = "https://transformers-api.firebaseapp.com/transformers"
        static let fetchSpecificTransformer = "https://transformers-api.firebaseapp.com/transformers"
        static let createNewTransformer = "https://transformers-api.firebaseapp.com/transformers"
        static let updateTransformer = "https://transformers-api.firebaseapp.com/transformers"
        static let deleteTransformer = "https://transformers-api.firebaseapp.com/transformers"
    }
    
    struct ValidationMessaages {
        static let nameMissing = "Error: name is missing."
        static let teamMissing = "Error: team is missing. Please enter either A or D."
    }

    struct ErrorMessaages {
        static let failedToCreate = "Error: failed to create a new transformer."
        static let failedToDelete = "Error: failed to delete the transformer:"
        static let failedToGetToken = "Error: failed to get token"
        static let failedToUpdate = "Error: failed to update the transformer:"
        static let noTransformerSelected = "Error: no transformer selected for editing"
    }
    
    struct SuccessMessaages {
        static let successCreate = "Successfully created a new transformer."
        static let successUpdate = "Successfully updated the transformer:"
    }
    
    struct TransformerNames {
        static let optimusPrime = "OPTIMUS PRIME"
        static let predaking = "PREDAKING"
    }
    
    struct WarResults {
        static let allDestroyed = "Optimus Prime fought against Predaking. All transformers have been destroyed!"
        static let autobotsWon = "Autobots won the war!"
        static let decepticonsWon = "Decepticons won the war!"
        static let nobodyWon = "It is a tie. The war will continue!"
    }
}
