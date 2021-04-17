import Foundation

let queue = DispatchQueue(label: "serial.queue")

print(1)
queue.async {
    print(2)
    queue.sync {
        print(3)
    }
    print(4)
}
print(5)
