//
//  Topic.swift
//  Ecofacts
//
//  Created by Bingo Zohar on 05/04/2023.
//

import Foundation

struct Topic: Hashable, Identifiable, Codable {
    public var id : UUID
    public var name: String
    public var statements: [Statement]
    
    init(id: UUID = UUID(), name: String, statements: [Statement]) {
        self.id = id
        self.name = name
        self.statements = statements
    }
}

extension Topic {
    struct Statement: Hashable, Identifiable, Codable {
        public var id : UUID
        public var text: String
        public var url: String
        public var colorInvert: Bool
        
        init(id: UUID = UUID(), label: String, source: String, colorInvert: Bool) {
            self.id = id
            self.text = label
            self.url = source
            self.colorInvert = colorInvert
        }
    }
    
    struct Data {
        var name: String = ""
        var statements: [Statement] = []
    }
    
    var data: Data {
        Data(name: name, statements: statements)
    }
    
    mutating func update(from data: Data) {
        name = data.name
        statements = data.statements
    }
    
    init(data: Data) {
        id = UUID()
        name = data.name
        statements = data.statements
    }
}

extension Topic.Statement {
    struct Data {
        var text: String = ""
        var url: String = ""
        var colorInvert: Bool = false
    }
    
    var data: Data {
        Data(text: text, url: url, colorInvert: colorInvert)
    }
    
    mutating func update(from data: Data) {
        text = data.text
        url = data.url
        colorInvert = data.colorInvert
    }
    
    init(data: Data) {
        id = UUID()
        text = data.text
        url = data.url
        //replace by highlight
        colorInvert = data.colorInvert
    }
}

extension Topic {
    static let samples : [Topic] = [
        Topic(name: "Topic 1", statements: [
            Statement(label: "s1", source: "xxx.yyyy", colorInvert: false),
            Statement(label: "s2", source: "xxx.yyyy", colorInvert: false)
        ]),
        Topic(name: "Topic 2", statements: [
            Statement(label: "s3", source: "xxx.yyyy", colorInvert: false),
            Statement(label: "s4", source: "xxx.yyyy", colorInvert: false)
            //Statement(label: "s4", source: URL(string: "xxx.yyyy")!, colorInvert: false)
        ])
    ]
}
