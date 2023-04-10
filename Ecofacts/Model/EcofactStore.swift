//
//  EcoFactsStore.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import Foundation
import SwiftUI

enum FileContainer {
    case local
    case appGroup
}

class EcofactStore: ObservableObject {
    @Published var topics: [Topic] = []
    
    /* Option possible pour créer un binding depuis un UUID:
        - */
    public func topicBinding(for id: Topic.ID) -> Binding<Topic> {
        Binding<Topic> {
            guard let index = self.topics.firstIndex(where: { $0.id == id }) else {
                fatalError()
            }
            return self.topics[index]
        } set: { newValue in
            guard let index = self.topics.firstIndex(where: { $0.id == id }) else {
                fatalError()
            }
            return self.topics[index] = newValue
        }
    }
    
    private static func fileURL(container: FileContainer = .appGroup) throws -> URL {
        if container == .appGroup {
            let appGroup = "group.u14e5.ecofacts"
            return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup)!.appendingPathComponent("ecofacts.json")
        }
        else {
            return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                .appendingPathComponent("ecofacts.json")
        }
    }

    static func load(completion: @escaping (Result<[Topic], Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let fileURL = try fileURL()
                
                guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                    DispatchQueue.main.async {
                        completion(.success([]))
                    }
                    return
                }
                let topics = try JSONDecoder().decode([Topic].self, from: file.availableData)
                
                DispatchQueue.main.async {
                    completion(.success(topics))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private static func save(container: FileContainer, topics: [Topic], completion: @escaping (Result<Int, Error>)->Void) {
        DispatchQueue.global(qos: .background).async {
            do {
                let data = try JSONEncoder().encode(topics)
                let outfile = try fileURL(container: container)
                try data.write(to: outfile)
                
                DispatchQueue.main.async {
                    completion(.success(topics.count))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    static func save(topics: [Topic], completion: @escaping (Result<Int, Error>)->Void) {
        self.save(container: .appGroup, topics: topics, completion: completion)
    }
    
    static func exportToLocalContainer(topics: [Topic], completion: @escaping (Result<Int, Error>) -> Void) {
        self.save(container: .local, topics: topics, completion: completion)
    }
    
    // Code permettant de faire une sauvegarde dans le fichier JSON directement depuis l'extension
    // Ne supporte pas l'asynchrone donc duppliqué en code async
    // Pas utlisé au final
    /*
    static func load() -> [Topic]? {
        do {
            let fileURL = try fileURL()
            
            guard let file = try? FileHandle(forReadingFrom: fileURL) else {
                return []
            }
            let topics = try JSONDecoder().decode([Topic].self, from: file.availableData)
            return topics
        } catch {
            return nil
        }
    }
    
    static func save(topics: [Topic]) -> Int {
        self.save(container: .appGroup, topics: topics)
    }
    
    private static func save(container: FileContainer, topics: [Topic]) -> Int {
        do {
            let data = try JSONEncoder().encode(topics)
            let outfile = try fileURL(container: container)
            try data.write(to: outfile)
            return topics.count
        } catch {
            return -1
        }
    }*/
}
