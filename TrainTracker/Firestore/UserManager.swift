//
//  UserManager.swift
//  TrainTracker
//
//  Created by Baptiste Griva on 03/05/2024.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct DBUser: Codable {
    let userId: String
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let pseudo: String?
    let friends: [String]?
    
    init(auth: AuthDataResultModel) {
        self.userId = auth.uid
        self.email = auth.email
        self.photoUrl = auth.photoUrl
        self.dateCreated = Date()
        self.pseudo = nil
        self.friends = nil
    }
    
    init(userId: String,
         email: String? = nil,
         photoUrl: String? = nil,
         dateCreated: Date? = nil,
         pseudo: String? = nil,
         friends: [String]? = nil
    ) {
        
        self.userId = userId
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.pseudo = pseudo
        self.friends = friends
    }
    
    enum CodingKeys: String, CodingKey{
        case userId = "user_id"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case pseudo = "pseudo"
        case friends = "friends"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        userId = try container.decode(String.self, forKey: .userId)
        email = try container.decodeIfPresent(String.self, forKey: .email)
        photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        pseudo = try container.decodeIfPresent(String.self, forKey: .pseudo)
        friends = try container.decodeIfPresent([String].self, forKey: .friends)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(userId, forKey: .userId)
        try container.encodeIfPresent(email, forKey: .email)
        try container.encodeIfPresent(photoUrl, forKey: .photoUrl)
        try container.encodeIfPresent(dateCreated, forKey: .dateCreated)
        try container.encodeIfPresent(pseudo, forKey: .pseudo)
        try container.encodeIfPresent(friends, forKey: .friends)
    }
}



final class UserManager{
    
    static let shared = UserManager()
    private init() { }
    
    private let userCollection = Firestore.firestore().collection("users")
    
    private func userDocument(userId: String) -> DocumentReference{
        userCollection.document(userId)
    }
    
    func createNewUser(auth: AuthDataResultModel, pseudo: String) async throws {
        var userData: [String:Any] = [
            "user_id" : auth.uid,
            DBUser.CodingKeys.pseudo.rawValue : pseudo,
            "date_created" : Timestamp()
        ]
        if let email = auth.email{
            userData["email"] = email
        }
        if let photoUrl = auth.photoUrl{
            userData["photo_url"] = photoUrl
        }
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    
    func getUser(userId: String) async throws -> DBUser{
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        guard let data = snapshot.data(), let userId = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date
        let pseudo = data["pseudo"] as? String
        let friends = data["friends"] as? [String]
        
        return DBUser(userId: userId, email: email, photoUrl: photoUrl, dateCreated: dateCreated, pseudo: pseudo, friends: friends)
    }
    
    func addUserFriend(userId: String, friendId: String) async throws{
        let data: [String:Any] = [
            DBUser.CodingKeys.friends.rawValue : FieldValue.arrayUnion([friendId])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func removeUserFriend(userId: String, friendId: String) async throws{
        let data: [String:Any] = [
            DBUser.CodingKeys.friends.rawValue : FieldValue.arrayRemove([friendId])
        ]
        
        try await userDocument(userId: userId).updateData(data)
    }
    
    func addTrainingSession(userId: String, session: TrainingSession) async throws{
        
        let document = userDocument(userId: userId).collection("training_sessions").document()
        let documentId = document.documentID
        
        if let exercises = session.training?.exercises {
            let exerciseData = exercises.map { exercise in
                return [
                    FirestoreExercise.CodingKeys.id.rawValue : exercise.id.uuidString,
                    FirestoreExercise.CodingKeys.name.rawValue : exercise.exercise.name,
                    FirestoreExercise.CodingKeys.muscle_group.rawValue : exercise.exercise.muscleGroup,
                    FirestoreExercise.CodingKeys.sets.rawValue : exercise.sets as Any,
                    FirestoreExercise.CodingKeys.reps.rawValue : exercise.reps as Any,
                    FirestoreExercise.CodingKeys.weight.rawValue : exercise.weight as Any
                ]
            }
            
            let data: [String:Any] = [
                FirestoreSession.CodingKeys.id.rawValue : documentId,
                FirestoreSession.CodingKeys.session_id.rawValue : session.id.uuidString,
                FirestoreSession.CodingKeys.date.rawValue : session.date,
                FirestoreSession.CodingKeys.name.rawValue : session.training?.name as Any,
                FirestoreSession.CodingKeys.duration.rawValue : session.duration as Any,
                FirestoreSession.CodingKeys.exercises.rawValue : exerciseData
                
            ]
            
            
            try await document.setData(data, merge: false)
        }
    }
    
    func getAllTrainingSessions(userId: String) async throws  -> [FirestoreSession]{
        let snapshot = try await userDocument(userId: userId).collection("training_sessions").order(by: "date", descending: true).getDocuments()
        
       
        return snapshot.documents.compactMap { document in
            do{
                return try document.data(as: FirestoreSession.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
    
    func getLastTrainingSession(userId: String) async throws -> FirestoreSession?{
        let snapshot = try await userDocument(userId: userId).collection("training_sessions").order(by: "date", descending: true).limit(to: 1).getDocuments()
        
        return snapshot.documents.compactMap { document in
            do{
                return try document.data(as: FirestoreSession.self)
            }catch{
                print(error)
                return nil
            }
        }.first
    }
    
    func getAllUsers() async throws -> [DBUser]{
        let snapshot = try await userCollection.getDocuments()
        
        return snapshot.documents.compactMap { document in
            do{
                return try document.data(as: DBUser.self)
            }catch{
                print(error)
                return nil
            }
        }
    }
    
    func getUserFriends(userId: String) async throws -> [DBUser] {
        let snapshot = try await userDocument(userId: userId).getDocument()
        var allFriends: [DBUser] = []
        
        guard let data = snapshot.data(), let friends = data["friends"] as? [String] else {
            throw URLError(.badServerResponse)
        }
        
        for friend in friends {
            let user = try await getUser(userId: friend)
            allFriends = allFriends + [user]
        }
        
        return allFriends
    }

}

struct FirestoreSession: Codable{
    let id: String
    let session_id: String
    let date: Date
    let name: String
    let duration: Double
    let exercises: [FirestoreExercise]
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(session_id, forKey: .session_id)
        try container.encode(date, forKey: .date)
        try container.encode(name, forKey: .name)
        try container.encode(duration, forKey: .duration)
        try container.encode(exercises, forKey: .exercises)
    }
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case session_id = "session_id"
        case date = "date"
        case name = "name"
        case duration = "duration"
        case exercises = "exercises"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.session_id = try container.decode(String.self, forKey: .session_id)
        self.date = try container.decode(Date.self, forKey: .date)
        self.name = try container.decode(String.self, forKey: .name)
        self.duration = try container.decode(Double.self, forKey: .duration)
        self.exercises = try container.decode([FirestoreExercise].self, forKey: .exercises)
    }
}
 
struct FirestoreExercise: Codable{
    let id: String
    let name: String
    let muscle_group: String
    let sets: Int
    let reps: Int
    let weight: Int
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(muscle_group, forKey: .muscle_group)
        try container.encode(sets, forKey: .sets)
        try container.encode(reps, forKey: .reps)
        try container.encode(weight, forKey: .weight)
    }
    
    enum CodingKeys: String, CodingKey{
        case id = "id"
        case name = "name"
        case muscle_group = "muscle_group"
        case sets = "sets"
        case reps = "reps"
        case weight = "weight"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.muscle_group = try container.decode(String.self, forKey: .muscle_group)
        self.sets = try container.decode(Int.self, forKey: .sets)
        self.reps = try container.decode(Int.self, forKey: .reps)
        self.weight = try container.decode(Int.self, forKey: .weight)
    }
    
}
