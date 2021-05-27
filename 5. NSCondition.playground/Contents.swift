import UIKit

var str = "pthread_cond, NSCondition()"

var available: Bool = false
var condition = pthread_cond_t()
var mutex = pthread_mutex_t()

// Posix - 'C'
class ConditionMutexPrinter: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil) // init condition
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() { // start point in everyone thread
        printerMethod()
    }
    
    private func printerMethod() {
        pthread_mutex_lock(&mutex)
        print("Printer enter")
        while !available {
            pthread_cond_wait(&condition, &mutex) // condition is wait
        }
        available = false
        defer {
            pthread_mutex_unlock(&mutex)
        }
        print("Printer exit")
    }
}

class ConditionMutexWriter: Thread {
    
    override init() {
        pthread_cond_init(&condition, nil)
        pthread_mutex_init(&mutex, nil)
    }
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod() {
        pthread_mutex_lock(&mutex)
        print("Writer enter")
        available = true
        pthread_cond_signal(&condition) // signal that condition
        defer {
            pthread_mutex_unlock(&mutex)
        }
        print("Writer exit")
    }
}

let conditionMutexPrinter = ConditionMutexPrinter()
let conditionMutexWriter = ConditionMutexWriter()

conditionMutexWriter.start()
conditionMutexPrinter.start()



// Obj-C
let nsCondition = NSCondition()
var available2 = false

class WriterThread: Thread {
    
    override func main() {
        writerMethod()
    }
    
    private func writerMethod() {
        nsCondition.lock()
        print("WriterThread enter")
        available2 = true
        nsCondition.signal()
        nsCondition.unlock()
        print("WriterThread exit")
    }
}

class PrinterThread: Thread {
    
    override func main() {
        printerMethod()
    }
    
    private func printerMethod() {
        nsCondition.lock()
        print("PrinterThread enter")
        while !available2 {
            nsCondition.wait()
        }
        available2 = false
        nsCondition.unlock()
        print("PrinterThread exit")
    }
}

let writerThread = WriterThread()
let printerThread = PrinterThread()
writerThread.start()
printerThread.start()
