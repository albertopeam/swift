import Foundation

// Thread usage
// https://developer.apple.com/documentation/foundation/thread

class MyThread: Thread {
    override func main() {
        print("\(self) main - \(Date())")
        Thread.sleep(forTimeInterval: 1)
        print("\(self) main finished - \(Date())")
    }
}

let thread = MyThread()

func printMyThreadState() {
    print("\(thread) is executing \(thread.isExecuting); is canceled \(thread.isCancelled); is finished \(thread.isFinished)")
}

thread.start()
while !thread.isFinished {
    printMyThreadState()
    Thread.sleep(forTimeInterval: 2)
}
printMyThreadState()
thread.cancel()
printMyThreadState()
// thread.start() // a thread can't be started twice

print("Thread.current \(Thread.current); Thread.main \(Thread.main); Thread.isMainThread \(Thread.isMainThread)")
print("------------------------------------")

// Thread shared memory issue

let limit = 500

class Shared2 {
    var memory: Int = 0
}
class MyThread2: Thread {
    private let shared: Shared2

    init(_ shared: Shared2) {
        self.shared = shared
    }

    override func main() {
        var value = shared.memory // shared memory issue
        value = value + 1
        shared.memory = value
    }
}
let shared = Shared2()
let threads = (0..<limit).map { _ in MyThread2(shared) }
threads.forEach { $0.start() }
Thread.sleep(forTimeInterval: 10)
print("\(shared.memory) isEqualTo \(limit)?; if not equal then shared memory is not protected from multiple threads accessing concurrently")

// thread shared memory correctly

print("------------------------------------")

class Shared3 {
    private var memory: Int = 0
    private let lock: NSRecursiveLock = .init()

    func getMemory() -> Int {
        defer { lock.unlock() }
        lock.lock()
        return memory
    }

    func update(_ closure: (_ current: Int) -> Int) {
        // concurrent memory handling
        lock.lock()
        let newValue = closure(memory)
        memory = newValue
        lock.unlock()
    }
}
class MyThread3: Thread {
    private let shared: Shared3

    init(_ shared: Shared3) {
        self.shared = shared
    }

    override func main() {
        shared.update { current in
            current + 1
        }
    }
}
let shared3 = Shared3()
let threads3 = (0..<limit).map { _ in MyThread3(shared3) }
threads3.forEach { $0.start() }
Thread.sleep(forTimeInterval: 10) // change this time interval if all the threads doesn't finish
print("\(shared3.getMemory()) isEqualTo \(limit)?; if not equal then shared memory is not protected from multiple threads accessing concurrently")


// DispatchQueue
// https://developer.apple.com/documentation/dispatch/dispatchqueue

print("------------------------------------")

let queue = DispatchQueue(label: "bg", qos: .userInitiated)
queue.async {
    print("async start")
// DEADLOCK
//    queue.sync {
//        print("sync")
//    }
    queue.async {
        print("async nested")
    }
    print("async end")
}

Thread.sleep(forTimeInterval: 1)

// WORKITEM
let workItem = DispatchWorkItem.init {
    print(Thread.current)
    print("work item start \(Date())")
    Thread.sleep(forTimeInterval: 1)
    print("work item end  \(Date())")
}
let workItem2 = DispatchWorkItem.init {
    print(Thread.current)
    print("work item 2 start \(Date())")
    Thread.sleep(forTimeInterval: 1)
    print("work item 2 end  \(Date())")
}

workItem.notify(queue: queue, execute: workItem2)
workItem.perform() // start execution on current thread
workItem.cancel() // no effect, item was executed synchronously
print("work item isCancelled \(workItem.isCancelled)")


// DispatchGroup
// https://developer.apple.com/documentation/dispatch/dispatchgroup

print("------------------------------------")

let group = DispatchGroup.init()

func workItemFactory(id: Int, delay: TimeInterval) -> DispatchWorkItem {
    group.enter()
    return DispatchWorkItem.init {
        print("work item \(id) start \(Date()) - \(Thread.current)")
        Thread.sleep(forTimeInterval: delay)
        print("work item \(id) end  \(Date())")
        group.leave()
    }
}

let workItem3 = workItemFactory(id: 1, delay: 1)
let workItem4 = workItemFactory(id: 2, delay: 3)

group.notify(queue: DispatchQueue.main) {
    print("DispatchGroup finished \(Thread.current)")
}

Thread { workItem3.perform() }
    .start()
Thread { workItem4.perform() }
    .start()


// OperationQueue
// https://developer.apple.com/documentation/foundation/operationqueue
print("------------------------------------")

print("mainQueue \(OperationQueue.main)")
print("currentQueue \(OperationQueue.current)")

func operationFactory(id: Int, delay: TimeInterval) -> BlockOperation {
    return BlockOperation {
        print("block op. \(id) start \(Date()) - \(Thread.current)")
        Thread.sleep(forTimeInterval: delay)
        print("block op. \(id) end  \(Date())")
    }
}

let operationQueue = OperationQueue.init()
operationQueue.name = "MyQueue"
operationQueue.qualityOfService = .userInitiated
operationQueue.maxConcurrentOperationCount = 2

let operation1 = operationFactory(id: 1, delay: 1)
let operation2 = operationFactory(id: 2, delay: 2)
operationQueue.addOperation(operation1)
operationQueue.addOperation(operation2)
operationQueue.waitUntilAllOperationsAreFinished() // be careful as it blocks current thread
print("op1 and op2 finished")

// OperationQueue dependencies
print("------------------------------------")

let operation3 = operationFactory(id: 3, delay: 1)
let operation4 = operationFactory(id: 4, delay: 2)
operation4.addDependency(operation3)

operationQueue.addOperation(operation3)
operationQueue.addOperation(operation4) // as it has a dependency on operation3 it won't start until if finish

