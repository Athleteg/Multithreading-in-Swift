import UIKit

var pthread = pthread_t(bitPattern: 0)
var attribute = pthread_attr_t()
pthread_attr_init(&attribute)
pthread_attr_set_qos_class_np(&attribute, QOS_CLASS_USER_INITIATED, 0) // Set new QOS

pthread_create(&pthread, &attribute, { (pointer) -> UnsafeMutableRawPointer? in
    print("Hello world!")
    pthread_set_qos_class_self_np(QOS_CLASS_UTILITY, 0) // Change current QOS
    return nil
}, nil)

let nsThread = Thread {
    print("Hello world!")
    print(QOS_CLASS_USER_INITIATED)
}
nsThread.qualityOfService = .userInitiated
nsThread.start()
