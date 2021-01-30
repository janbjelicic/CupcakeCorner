//
//  File.swift
//  
//
//  Created by Jan Bjelicic on 29/01/2021.
//

import Vapor
import Fluent
import FluentSQLiteDriver

extension FieldKey {
    static var cakeName: Self { "cakeName" }
    static var buyerName: Self { "buyerName" }
    static var date: Self { "date" }
}

final class Order: Content, Model, Migration {
    
    static let schema = "Order"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: .cakeName)
    var cakeName: String
    
    @Field(key: .buyerName)
    var buyerName: String
    
    @OptionalField(key: .date)
    var date: Date?
    
    init() { }

    init(id: UUID? = nil, cakeName: String, buyerName: String, date: Date?) {
        self.id = id
        self.cakeName = cakeName
        self.buyerName = buyerName
        self.date = date
    }
    
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Order.schema)
            .id()
            .field(.cakeName, .string, .required)
            .field(.buyerName, .string, .required)
            .field(.date, .date, .required)
            .create()
    }
    
    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(Order.schema).delete()
    }
    
}

