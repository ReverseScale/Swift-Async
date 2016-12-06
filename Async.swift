//
//  Async.swift
//  DajiaZhongyi
//
//  Created by yunchou on 2016/12/1.
//  Copyright © 2016年 dajiazhongyi. All rights reserved.
//

import Foundation
class Async {
    private var canceled = false
    private var group = dispatch_group_create()
    var tasks:[AsyncTask] = []
    private func complete(){
        dispatch_group_leave(group)
    }
    private func run(task:AsyncTask){
        dispatch_group_enter(group)
        task.run()
    }
    func cancel(){
        canceled = true
        self.tasks.forEach{$0.cancalTask()}
    }
    func run(complete: (Async) -> Void) {
        tasks.forEach { task in
            self.run(task)
        }
        dispatch_group_notify(group, dispatch_get_main_queue()) { 
            if self.canceled { return }
            complete(self)
        }
    }
    func task(name:String = "") -> AsyncTask{
        let task = AsyncTask(async: self)
        task.name = name
        tasks.append(task)
        return task
    }
    
    
    enum AsyncTaskState{
        case pending
        case complete(success:Bool)
    }
    
    class AsyncTask{
        var state:AsyncTaskState = .pending
        var ud:[String:Any] = [:]
        weak var async:Async? = nil
        var name:String = ""
        
        private init(async:Async) {
            self.async = async
        }
        var executeBlock:(task:AsyncTask) -> Void = {task in
            task.complete(false)
        }
        var cancelBlock:(task:AsyncTask) -> Void = {task in}
        func run(){
            self.executeBlock(task: self)
        }
        func complete(success:Bool){
            self.state = .complete(success: success)
            self.async?.complete()
        }
        private func cancalTask() {
            self.cancelBlock(task: self)
        }
        func cancel( block: (task:AsyncTask) -> Void) -> AsyncTask{
            self.cancelBlock = block
            return self
        }
        func execute(block: (task:AsyncTask) -> Void) -> AsyncTask{
            self.executeBlock = block
            return self
        }
    }
}
