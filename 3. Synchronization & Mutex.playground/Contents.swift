 import UIKit
 
 var str = "Synchronization & Mutex"
 
 //Везде, где мы видим в доке 'safe thread' это значит, что используются mutex у объекта и он потокозащищён!
 
 
 //Unix - 'C'
 class SaveThread {
    private var mutex = pthread_mutex_t()
    
    init() {
        pthread_mutex_init(&mutex, nil)
    }
    
    func someMethods(completion: () -> ()) {
        pthread_mutex_lock(&mutex)  // Lock logic from another threads
        
        // There is some code of logic
        completion()
        
        do {
            pthread_mutex_unlock(&mutex)  // Unlock logic for another threads
        }
    }
 }
 
 private var array: [String] = []
 private let saveThread = SaveThread()
 
 saveThread.someMethods {
    print("Test")
    array.append("Thread 1")
 }
 
 
 //Objc-C
 
 class NSSaveThread {
    private let NSMutex = NSLock()
    
    func someMethods(completion: () -> ()) {
        NSMutex.lock()
        completion()
        do {
            NSMutex.unlock()
        }
    }
 }
 
 private var someArray: [String] = []
 private let nsSaveThread = NSSaveThread()
 
 nsSaveThread.someMethods {
    print("Test 2")
    someArray.append("NSTread 1")
 }
