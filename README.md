# VKMysqlProvider #

Provide IBM Kuery Mysql abstraction for Vapor 2.

Vapor is great! Fluent is amazing!

But...

Sometimes you need to execute queries with projections 
that are not mapped in just one table, just like
```SQL
SELECT TableA.*, TableB.name FROM TableA JOIN TableB ON (TableA.id = TableB.a_id)
```
 
So, for that Kuery seems to be a better fit than Fluent.

This project aims make it simple to integrate Kuery MySql with Vapor.


kuery-mysql.json
``` json
{
    "hostname":"localhost",
    "user":"root",
    "password":"Your_Password",
    "database":"vapor-kuery",
    "pool":{
        "initialCapacity":3,
        "maxCapacity":15,
        "timeout":10000
    }
}
```

More info about Kuery and connection pools at: https://github.com/IBM-Swift/SwiftKueryMySQL




### Tip:
- You will need to keep a Fluent `Model` and a Kuery `Table` class. To make it easier to remember of update both classes you can put in the same file the Kuery `Table` class and the `Preparation` extension of your Fluent `Model`.

Ex:
TeamTable.swift
``` swift

import SwiftKuery
import Fluent
final class TeamTable: Table {
    let tableName = "teams"
    
    let name = Column("name", Varchar.self, length: 256)
    let companyName = Column("company_name", Varchar.self, length: 256)
    let division = Column("division", Varchar.self, length: 256)
    let timezone = Column("timezone", Varchar.self, length: 100, defaultValue: "America/Sao_Paulo")
    
}

extension Team: Preparation {
    static func prepare(_ database: Database) throws {
        try database.create(self) { builder in
            builder.id()
            builder.string("name", length: 256, unique: true)
            builder.string("company_name", length: 256)
            builder.string("division", length: 256)
            builder.string("timezone", length: 100, default: "America/Sao_Paulo")
        }
    }
    
    static func revert(_ database: Database) throws {
        try database.delete(self)
    }
}

```
