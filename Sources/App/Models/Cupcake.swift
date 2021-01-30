//
//  File.swift
//  
//
//  Created by Jan Bjelicic on 28/01/2021.
//

import Fluent
import FluentSQLiteDriver
import Foundation
import Vapor

extension FieldKey {
    static var nameText: Self { "nameText" }
    static var description: Self { "description" }
    static var price: Self { "price" }
}

final class Cupcake: Content, Model, Migration {
    
    static let schema = "Cupcake"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .nameText)
    var nameText: String
    
    @Field(key: .description)
    var description: String
    
    @Field(key: .price)
    var price: Int
    
    init() { }

    init(id: UUID? = nil, nameText: String, description: String, price: Int) {
        self.id = id
        self.nameText = nameText
        self.description = description
        self.price = price
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Cupcake.schema)
            .id()
            .field(.nameText, .string, .required)
            .field(.description, .string, .required)
            .field(.price, .int, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Cupcake.schema).delete()
    }
    
}
