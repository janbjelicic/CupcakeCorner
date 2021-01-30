import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) throws {
    // uncomment to serve files from /Public folder
    app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // register routes
    try routes(app)
    app.views.use(.leaf)
    
    app.databases.use(.sqlite(.file("cupcakes.db")), as: .sqlite)
    app.migrations.add(Cupcake())
    app.migrations.add(Order())
    try app.autoMigrate().wait()
}
