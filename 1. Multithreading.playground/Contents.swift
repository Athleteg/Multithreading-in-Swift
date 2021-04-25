import UIKit

// Thread
// Operation
// GCD


// Unix - posix   'C'
var thread = pthread_t(bitPattern: 0)
var attribute = pthread_attr_t()

pthread_attr_init(&attribute)  // In the C - in the parameter,
                               // link on the another structure or properties throw '&'

pthread_create(&thread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("Hello world")
    return nil
}, nil)


// Thread in Objc-c
var nsThread = Thread {
    print("Hello world")  // Here short logic, but in code of above
}
nsThread.start()
nsThread.threadPriority = 1
nsThread.cancel()


