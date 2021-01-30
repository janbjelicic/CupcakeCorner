import Vapor
import Combine

func routes(_ app: Application) throws {
    
    app.get { req -> EventLoopFuture<View> in
        struct PageData: Content {
            var cupcakes: [Cupcake]
            var orders: [Order]
        }
        
        let cupcakes = Cupcake.query(on: req.db).all()
        let orders = Order.query(on: req.db).all()
        
        return cupcakes.and(orders).flatMap { cupcakes, orders in
            let context = PageData(cupcakes: cupcakes, orders: orders)
            return req.view.render("home", context)
        }
    }
    
    app.post("add") { req -> EventLoopFuture<Response> in
        let cupcake = try req.content.decode(Cupcake.self)
        return cupcake.save(on: req.db).map { cupcake in
            return req.redirect(to: "/")
        }
    }
    
    app.post("order") { req -> EventLoopFuture<Order> in
        let order = try req.content.decode(Order.self)
        let orderCopy = order
        orderCopy.date = Date()
        return orderCopy.save(on: req.db).map {
            order
        }
    }

    app.get("cupcakes") { req -> EventLoopFuture<[Cupcake]> in
        return Cupcake.query(on: req.db).sort(.nameText).all()
    }
}
