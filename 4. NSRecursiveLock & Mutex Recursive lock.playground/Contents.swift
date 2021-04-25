import UIKit

var str = "NSRecursiveLock & Mutex Recursive Lock"

// Unix - 'C'
class RecursiveMutexTest {
    private var mutexThread = pthread_mutex_t()
    private var attribute = pthread_mutexattr_t()
    
    init() {
        pthread_mutexattr_init(&attribute) // init attribute
        pthread_mutexattr_settype(&attribute, PTHREAD_MUTEX_RECURSIVE) // Set type about our mutexTread have recursive
        pthread_mutex_init(&mutexThread, &attribute) // init mutex thread
    }

    func firstTask() {
        pthread_mutex_lock(&mutexThread)
        secondTask()
        do {
            pthread_mutex_unlock(&mutexThread)
        }
    }
    
    private func secondTask() {
        pthread_mutex_lock(&mutexThread)
        print("Finish")
        do {
            pthread_mutex_unlock(&mutexThread)
        }
    }
    // If don't set type 'PTHREAD_MUTEX_RECURSIVE' - we don't look "finish", because thread will be blocked
}

private let recursiveMutexTest = RecursiveMutexTest()
recursiveMutexTest.firstTask()


// Objc-C
class RecursiveThread: Thread {
    let recursiveLock = NSRecursiveLock()
    
    override func main() {
        recursiveLock.lock()
        print("Main thread locked")
        someTask()
        do {
            recursiveLock.unlock()
        }
        print("Exit main")
    }
    
    private func someTask() {
        recursiveLock.lock()
        print("Main thread locked again")
        do {
            recursiveLock.unlock()
        }
        print("Exit someTask")
    }
}

private let recursiveThread = RecursiveThread()
recursiveThread.start()
