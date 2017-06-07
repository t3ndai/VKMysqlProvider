# VKMysqlProvider

Provide Mysql Kuery abstraction for Vapor 2
Vapor is great! Fluent is amazing!
But...
Sometimes you need to execute queries with projections 
that are not mapped in just one table (SELECT TableA.*, TableB.name FROM TableA JOIN TableB ON (TableA.id = TableB.a_id)), 
and for that Kuery seems to be a better fit than Fluent.

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
