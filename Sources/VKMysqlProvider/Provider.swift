import Vapor
import SwiftKuery

public final class Provider: Vapor.Provider {
    
    public static let repositoryName = "kuery-mysql-provider"
    
    let connectionPool: SwiftKuery.ConnectionPool?
    
    public init(config: Config) throws {
        self.connectionPool = try ConnectionPoolCreator(config: config).connectionPool
    }
    
    public func boot(_ config: Config) throws {
    }
    
    public func boot(_ drop: Droplet) throws {
        drop.connectionPool = self.connectionPool
    }
    public func beforeRun(_ drop: Droplet) {}
}
