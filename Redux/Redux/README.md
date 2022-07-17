# Flux architecture

Flux architecture minimun implementation and showcase

## TODOs

* Investigate some/any instead of erasing with Any(Middleware)
* Testing
* DependencyInjection strategies:
  * ServiceLocator
  * Injector
  * ManualInjection
* Candidates to demo:
  * crypto explorer: Cosmos?
    * tx, address, block
  * crypto find something that is not implemented on mobile yet
  * crypto usage of web3 libs

## DONE

* Transferring state multiple times for an action
* Reducer emits only once
  * Store has this issue
* Reducer emits multiple times, using Combine? using _Concurrency AsyncSequence(it seems that doesn't fit, review more)? SOLVED WITH AsyncSequence
  * Store
    * CON:
      * not handles multiple state changes during one action
  * StoreV2 solves it but, hard to understand or not the easiest flow. NEED to find an async sequence of events instead
    * PRO:
      * clear, no loops in store, no returning a newAction in the reducer
      * no extra cases in state
    * CON:
      * probably reducer will be kind of more complex, but is what it is.
  * StoreV3 will try to solve V2 problems:
    * AsyncStream, can generate multiple values over the time and fit with async/await but it seems that fits better for legacy closures code
      * https://developer.apple.com/documentation/swift/asyncstream
    * CheckedContinuation, can generate ONLY one event. It has checks to enforce it.
      * [CheckedContinuation](https://developer.apple.com/documentation/swift/checkedcontinuation)
      * https://developer.apple.com/documentation/swift/withcheckedcontinuation(function:_:)
    * POSSIBLE ISSUE: thinl what would happen if I need to forward the state between loading and fetch. How to deal with that?
* Middleware handle also posting new actions after reduce one of it
* Handle Task cancellation? SwiftUI native cancels them when view disappears
* Task cancellation before start a new task

## Bibliography

* [Michael Collins](https://medium.com/neudesic-innovation/managing-swiftui-state-using-redux-525a8879c1be)
* [Majid Jabrayilov](https://swiftwithmajid.com/2022/02/17/redux-like-state-container-in-swiftui-part5/)
* [@StateObject](https://developer.apple.com/documentation/swiftui/stateobject)
* [AsyncSequence](https://www.avanderlee.com/concurrency/asyncsequence)

* // https://www.hackingwithswift.com/quick-start/concurrency/how-to-create-a-custom-asyncsequence
// https://www.avanderlee.com/concurrency/asyncsequence/
<!-- 
https://github.com/krasimir/react-in-patterns/tree/master/book/chapter-08
https://www.raywenderlich.com/22096649-getting-a-redux-vibe-into-swiftui
https://www.swiftbeta.com/arquitectura-redux-en-swiftui/
Multiple chained actions + Combine + Concurrency https://swiftwithmajid.com/2022/02/17/redux-like-state-container-in-swiftui-part5/
 -->
