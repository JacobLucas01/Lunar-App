//
//  AuthService.swift
//  Lunar
//
//  Created by Jacob Lucas on 12/25/21.
//

import Foundation
import Firebase
import FirebaseAuth
import UIKit
import SwiftUI
import GeoFire

let REF_FIRESTORE = Firestore.firestore()
let REF_USERS = REF_FIRESTORE.collection("users")

class AuthService {
    
    static let instance = AuthService()
    var loading: Bool = false
    
    let geofireRef = Database.database().reference()
    
    func logInUserToFirebase(credential: AuthCredential, handler: @escaping (_ providerID: String?, _ isError: Bool, _ isNewUser: Bool?, _ userID: String?) -> ()) {
        Auth.auth().signIn(with: credential) { (result, error) in
            
            // Check for errors
            if error != nil {
                print("error logging into Firebase")
                handler(nil, true, nil, nil)
                return
            }
            
            // Check for provider ID
            guard let providerID = result?.user.uid else {
                print("Error getting provider ID")
                handler(nil, true, nil, nil)
                return
            }
            
            self.checkIfUserExistsInDatabase(providerID: providerID) { (returnedUserID) in
                if let userID = returnedUserID {
                    handler(providerID, false, false, userID)
                } else {
                    handler(providerID, false, true, nil)
                }
            }
        }
    }
    
    func logInUserToApp(userID: String, handler: @escaping (_ success: Bool) -> ()) {
        getUserInfo(forUserID: userID) { returnedName, returnedUsername in
            if let name = returnedName, let username = returnedUsername {
                
                handler(true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    UserDefaults.standard.set(userID, forKey: "user_id")
                    UserDefaults.standard.set(username, forKey: "username")
                    UserDefaults.standard.set(name, forKey: "name")
                }
                
            } else {
                handler(false)
            }
            self.setUserLocation(location: CLLocation(latitude: 37.3496, longitude: -121.939), userID: userID)
        }
    }
    
     func setUserLocation(location: CLLocation, userID: String) {
        let geoFire = GeoFire(firebaseRef: geofireRef)
        
        geoFire.setLocation(location, forKey: userID)
    }
    
    func getUserInfo(forUserID userID: String, handler: @escaping (_ name: String?, _ username: String?) -> ()) {
        REF_USERS.document(userID).getDocument { documentSnapshot, error in
            if let document = documentSnapshot, let name = document.get("name") as? String, let username = document.get("username") as? String {
                print("Success getting user info")
                handler(name, username)
                return
            } else {
                print("Error getting user info")
                handler(nil, nil)
                return
            }
        }
    }
    
    //THIS CODE
    private func checkIfUserExistsInDatabase(providerID: String, handler: @escaping (_ existingUserID: String?) -> ()) {
        // If user ID is returned, user exists
        REF_USERS.whereField("provider_id", isEqualTo: providerID).getDocuments { (querySnapshot, error) in
            if let snapshot = querySnapshot, snapshot.count > 0, let document = snapshot.documents.first {
                let existingUserID = document.documentID
                handler(existingUserID)
                return
            } else {
                handler(nil)
            }
        }
    }
    
    func createNewUserInDatabase(name: String, username: String, age: String, gender: String, providerID: String, provider: String, profileImage: UIImage, handler: @escaping (_ userID: String?) -> ()) {
        
        let document = REF_USERS.document()
        let userID = document.documentID
        
        ImageManager.instance.uploadProfileImage(userID: userID, image: profileImage)
        
        let userData: [String: Any] = [
            "name": name,
            "username": username,
            "age": age,
            "gender": gender,
            "provider_id": providerID,
            "provider": provider,
            "user_id": userID,
            "date_created": FieldValue.serverTimestamp(),
        ]
        
        document.setData(userData) { error in
            if let error = error {
                print("Error uploading data to user document. \(error)")
                handler(nil)
            } else {
                handler(userID)
            }
        }
    }
    
    func logOutUser(handler: @escaping (_ success: Bool) -> ()) {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error \(error)")
            handler(false)
        }
        handler(true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            let defaultsDictionary = UserDefaults.standard.dictionaryRepresentation()
            defaultsDictionary.keys.forEach { key in
                UserDefaults.standard.removeObject(forKey: key)
            }
        }
    }
    
    //EMAIl ACCOUNT CREATION
    func createAccountWithEmail(email: String, password: String, handler: @escaping (_ success: Bool) -> ()) {
        self.loading = true
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let x = error {
                let err = x as NSError
                switch err.code {
                case AuthErrorCode.wrongPassword.rawValue:
                    print("wrong password")
                case AuthErrorCode.invalidEmail.rawValue:
                    print("invalid email")
                case AuthErrorCode.accountExistsWithDifferentCredential.rawValue:
                    print("accountExistsWithDifferentCredential")
                case AuthErrorCode.emailAlreadyInUse.rawValue: //<- Your Error
                    print("email is alreay in use")
                default:
                    print("unknown error: \(err.localizedDescription)")
                }
                handler(false)
            } else {
                print("Success")
                self.loading = false
                handler(true)
            }
        }
    }
    
    // MARK: UPDATE USER DISPLAY NAME IN DATABASE
    func updateUserDisplayName(userID: String, name: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            "name" : name
        ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
    func updateUserUsername(userID: String, username: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            "username" : username
        ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
    
    func updateUserGender(userID: String, gender: String, handler: @escaping (_ success: Bool) -> ()) {
        
        let data: [String:Any] = [
            "gender" : gender
        ]
        
        REF_USERS.document(userID).updateData(data) { (error) in
            if let error = error {
                print("Error updating user display name. \(error)")
                handler(false)
                return
            } else {
                handler(true)
                return
            }
        }
        
    }
}
