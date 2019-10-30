# TransformersAtWar
iOS app that provides user interface for Transformers API

The project was build for iOS 10 as "Universal".
Cocoapods was used to install and manage the project dependencies.
The networking support has been implemented with Alamofire.
The local data persistence has been implemented with Realm.
The sensitive information local storage (JTW token) is done with the means of SwiftKeychainWrapper.

App usage instructions
1. Get the files from GitHub: https://github.com/DenisEfremov71/TransformersAtWar
2. Open the "TransformersAtWar.xcworkspace" file with Xcode
3. Build and run 
4. When the app start for the very first time on an iOS device, a JWT token is created and stored in the device's keychain. It will be stored in the keychain for the life time of the app. Only when the app is deleted from the device, the token will be removed with the app.

Assumptions:
1. The JWT token never expires so the "token refresh" feature was not implemented.
2. The loser transformers (who were eliminated during the one-to-one battles) do not need to be deleted from the list.
