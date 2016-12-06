# Swift-Async
Swift版 异步进程工具
```swift
let async = Async()
        async.task().execute { (task) in
            task.ud["key01"] = "async01"
            task.complete(true)
        }
        async.task().execute{ task in
            task.ud["key02"] = "async02"
            task.complete(true)
        }
        async.task("home").execute({ (task) in
            task.ud["key03"] = "async03"
            task.complete(true)
        }).cancel({ task in
            print("Cancel Async")
        })
        async.run { async in
            async.tasks.forEach{ task in
                if let dic = task.ud["key01"]{
                    
                }else if let sessions = task.ud["key02"]{
                    
                }else if let homeSearchs = task.ud["key03"]{
                    
                }
            }
        }

```
