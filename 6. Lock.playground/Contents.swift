import UIKit

var str = "Lock"

// Realization only on Unix!
class ReadWriteLock { // Защищает от других потоков - get-ер или set-ер или и то и др!
    
    private var lock = pthread_rwlock_t()
    private var attribute = pthread_rwlockattr_t()
    
    private var globalProperty: Int = 0
    
    init() {
        pthread_rwlock_init(&lock, &attribute)
    }
    
    var workPropery: Int {
        get {
            pthread_rwlock_rdlock(&lock)
            let someValue = globalProperty
            pthread_rwlock_unlock(&lock)
            return someValue
        }
        set {
            pthread_rwlock_wrlock(&lock)
            globalProperty = newValue
            pthread_rwlock_unlock(&lock)
        }
    }
}



//SpinLock was deprecated, but in C it is using.
// Этот замок от потоков использовался ранее эплом. Суть его в том, что он стучится до тех пор, пока объект ему не скажет - хватит! Но это очень энергозатратно!
class SpinLock {
    
    private var lock = OS_SPINLOCK_INIT
    
    func someMethods() {
        OSSpinLockLock(&lock)
        // some logic
        OSSpinLockUnlock(&lock)
    }
}


// Заместо SpinLock сделали новую оболочку:
class UnfairLock {
    
    private var lock = os_unfair_lock_s()
    
    private var array: [Int] = []
    
    func someMethods() {
        os_unfair_lock_lock(&lock)
        array.append(1)
        os_unfair_lock_unlock(&lock)
    }
}


// Popular lock in Objc-C
class Synchronize {
    
    private let lock = NSObject()
    
    private var array: [Int] = []
    
    func someMethod() {
        objc_sync_enter(lock)
        array.append(1)
        objc_sync_exit(lock)
    }
}
