//
//  ViewController.swift
//  bumble
//
//  Created by Alberto Penas Amor on 24/5/22.
//

import UIKit

final class ViewController: UIViewController {
    private let parentView: UIView = .init(frame: .zero)
    private let childView: UIView = .init(frame: .zero)
    private let childView2: UIView = .init(frame: .zero)
    private let nonChildView: UIView = .init(frame: .zero)
    private let parentConstraintView: UIView = .init(frame: .zero)
    private let childConstraintView: UIView = .init(frame: .zero)
    private let nonChildConstraintView: UIView = .init(frame: .zero)
    private let uiControl: UIControl = .init(frame: .zero)
    private let clipToBoundsButton: UIButton = .init(frame: .zero)
    private let imageView: UIImageView = .init(frame: .zero)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupFrames()
        setupConstraints()
        hitTestUsage()
        clipToBoundsUsage()
        collectionSlices()
        autoreleasePool()
        dispatchBarrier()
        deadLock()
        treeSearch()
    }

    private func setupFrames() {
        view.addSubview(parentView)
        view.addSubview(clipToBoundsButton)
        parentView.addSubview(childView)
        parentView.addSubview(childView2)
        view.addSubview(nonChildView)
        view.addSubview(uiControl)
        parentView.backgroundColor = .green
        childView.backgroundColor = .brown
        childView2.backgroundColor = .red
        nonChildView.backgroundColor = .gray
        uiControl.backgroundColor = .black

        parentView.frame = CGRect(x: 16, y: 24, width: 128, height: 256) // relative to its parent
        childView.frame = CGRect(x: 32, y: 32, width: 64, height: 64) // relative to its parent
        childView2.frame = CGRect(x: 110, y: 116, width: 32, height: 32) // relative to its parent
        nonChildView.frame = CGRect(x: 96, y: 200, width: 64, height: 64) // NON relative to its parent as it is not nested
        uiControl.frame = CGRect(x: view.frame.width - 96, y: 24, width: 64, height: 64)
        clipToBoundsButton.frame = CGRect(x: view.frame.width - 145, y: 128, width: 140, height: 30)

        UIView.animate(withDuration: 3, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            let identity = CGAffineTransform.identity
            let rotated = identity.rotated(by: -CGFloat.pi / 4)
            self.childView.transform = rotated
        } completion: { completion in
            print("frame \(self.childView.frame)")   // frame changed (18.7, 18.7, 90.5, 90.5)
            print("bounds \(self.childView.bounds)") // bounds not change as they are internal representation. (0, 0, 64, 64)
        }

        uiControl.addTarget(self, action: #selector(click(_:)), for: .touchUpInside)
    }

    @objc private func click(_ control: UIControl?) {
        print(control?.description ?? #function)
    }

    private func setupConstraints() {
        parentConstraintView.translatesAutoresizingMaskIntoConstraints = false
        childConstraintView.translatesAutoresizingMaskIntoConstraints = false
        nonChildConstraintView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(parentConstraintView)
        parentConstraintView.addSubview(childConstraintView)
        view.addSubview(nonChildConstraintView)
        parentConstraintView.backgroundColor = .green
        childConstraintView.backgroundColor = .brown
        nonChildConstraintView.backgroundColor = .gray

        NSLayoutConstraint.activate([
            parentConstraintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            parentConstraintView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            parentConstraintView.widthAnchor.constraint(equalToConstant: 128),
            parentConstraintView.heightAnchor.constraint(equalToConstant: 256),

            // nested view
            childConstraintView.leadingAnchor.constraint(equalTo: parentConstraintView.leadingAnchor, constant: 16),
            childConstraintView.topAnchor.constraint(equalTo: parentConstraintView.topAnchor, constant: 32),
            childConstraintView.widthAnchor.constraint(equalToConstant: 64),
            childConstraintView.heightAnchor.constraint(equalToConstant: 64),

            // non nested view
            nonChildConstraintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 96),
            nonChildConstraintView.bottomAnchor.constraint(equalTo: parentConstraintView.bottomAnchor, constant: -32),
            nonChildConstraintView.widthAnchor.constraint(equalToConstant: 64),
            nonChildConstraintView.heightAnchor.constraint(equalToConstant: 64),
        ])
    }

    private func hitTestUsage() {
        //https://developer.apple.com/documentation/uikit/uiview/1622469-hittest
        let uiControlPoint = CGPoint(x: uiControl.frame.origin.x, y: uiControl.frame.origin.y)
        let handlerView = view.hitTest(uiControlPoint, with: nil)
        print("hitTest UIControl")
        print(handlerView)
        print(uiControl)
        print("-------------")


        let uiNestedViewPoint = CGPoint(x: 96, y: 56)
        let handlerUIView = view.hitTest(uiControlPoint, with: nil)
        print("hitTest UIView")
        print(handlerUIView) // none of the views matches, position or hitTest is not hiteable?
        print(childView)
        print(parentView)
        print(view)
        print("-------------")
    }

    private func clipToBoundsUsage() {
        clipToBoundsButton.setTitle("clip bounds", for: .normal)
        clipToBoundsButton.backgroundColor = .red
        clipToBoundsButton.addTarget(self, action: #selector(clipToBounds(_:)), for: .touchUpInside)
        clipToBoundsButton.layer.cornerRadius = 8
        clipToBoundsButton.layer.shadowColor = UIColor.black.cgColor
        clipToBoundsButton.layer.shadowOffset = CGSize.init(width: 1, height: -1)
        clipToBoundsButton.layer.shadowOpacity = 0.4 // opacity or transparence
        clipToBoundsButton.layer.shadowRadius = 6.0  // blur
        clipToBoundsButton.layer.masksToBounds = false // not needed explicitly
    }

    @objc private func clipToBounds(_ button: UIButton) {
        parentView.clipsToBounds = !parentView.clipsToBounds
        if parentView.clipsToBounds {
            clipToBoundsButton.setTitle("not clip bounds", for: .normal)
        } else {
            clipToBoundsButton.setTitle("clip bounds", for: .normal)
        }
    }

    private func collectionSlices() {
        //https://developer.apple.com/documentation/swift/swift_standard_library/collections
        // collections: array + Dictionary, Set + OptionSet, Range + ClosedRange, CollectionOfOne, EmptyCollection, KeyValuePairs
        // collection inherits from sequence
        // collection functions: https://developer.apple.com/documentation/swift/collection
        // sequence functions:  https://developer.apple.com/documentation/swift/sequence
        let collection = Array(arrayLiteral: 1, 2, 3, 4, 5, 6, 8, 10, 7, 6)

        // indices
        print("first index item \(collection[collection.startIndex])")
        print("collection indices \(collection.indices)")
        print("indices description\(collection.indices.map { $0.description })")
        // print("end one \(collection[collection.endIndex])") one element past last one

        print("capacity \(collection.capacity)")
        print("distance \(collection.distance(from: collection.startIndex, to: collection.index(before: collection.endIndex)))")
        print("first index of 3 \(collection.firstIndex(of: 3))")

        print("slices")
        collection[collection.indices] // ranged access via indices
        let prefix = collection.prefix(2)
        print("prefix 2 items \(prefix)")
        var iterator = prefix.makeIterator()
        while let next = iterator.next() {
            print("iterator \(next)")
        }
        print("hardcoded subscript until+included index 4 \(collection[...4])")
        print("hardcoded subscript before index 4 \(collection[..<4])")
        print("hardcoded subscript after+included index 4 \(collection[4...])")

        print("first index of 7 \(collection.firstIndex(of: 7))")
        if let start = collection.firstIndex(of: 6), let end = collection.lastIndex(of: 6) {
            let slice = collection[collection.index(after: start)..<end]
            print("slice between six \(slice)")
        }

        // finding in ranges
        let absences = [0, 2, 0, 4, 0, 3, 1, 0]
        let halfSize = absences.count / 2
        let absencesSuffix = absences.suffix(halfSize)
        if let max = absencesSuffix.max(), let maxIndex = absencesSuffix.firstIndex(of: max) {
            // slice index matches with original collection index
            print("max index of second half of absences \(maxIndex), value \(absencesSuffix[maxIndex])")
        }
        if let maxIndex = absencesSuffix.indices.max(by: { i0, i1 in absencesSuffix[i0] < absencesSuffix[i1]}) {
            print("max index of second half of absences \(maxIndex), value \(absencesSuffix[maxIndex])")
        }

        // slice not references original, so mutating does not impact
        var items = [0, 2, 0, 4, 0, 3, 1, 0]
        let slice = items.suffix(from: halfSize)
        items[7] = 1
        print("mutated array \(items)")
        print("slice \(slice)")

        // traversing using indices produces same elements than using an iterator
        let word = "chuift"
        print("iterator vs iterate indices")
        for letter in word {
            print(letter)
        }
        print("iterator vs iterate indices")
        for i in word.indices {
            print(word[i])
        }

        // collection performance O(1)

        // split
        let sentence = "hi! my name is swift      "
        let words = sentence.split(separator: " ", maxSplits: Int.max, omittingEmptySubsequences: true)
        print(words)


        let dictionary = ["1": 1, "2": 2, "3": 3, "4": 4]
        let prefixUntil3 = dictionary.prefix { (key: String, value: Int) in
            return key == "3"
        }

        let prefixLength2 = dictionary.prefix(2)
        var iterator2 = prefixLength2.makeIterator()
        while let next = iterator2.next() {
            print(next)
        }
    }

    func autoreleasePool() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: clipToBoundsButton.bottomAnchor, constant: 16),
            imageView.widthAnchor.constraint(equalToConstant: 128),
            imageView.heightAnchor.constraint(equalToConstant: 128),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
        guard let url = URL(string: "https://picsum.photos/200") else {
            return
        }
        let bgQueue = DispatchQueue.global(qos: .userInitiated)
        let mainQueue = DispatchQueue.main
        repeatFetch()

        func repeatFetch() {
            (0...100).forEach { _ in
                bgQueue.async {
                    autoreleasepool { // relinquish ownership of an object, but avoid the possibility of it being deallocated immediately
                        if let image = fetchImage(url: url) { // image will be released at the end of autorelease block
                            mainQueue.async { [weak self] in
                                self?.imageView.image = image
                            }
                        }
                    } // at the end of the block the unneeded memory will be deallocated
                    // if we don't use autoreleasepool it will be deallocated when the block in execution ends, but too much memory allocated in the meanwhile
                }
            }
        }
        func fetchImage(url: URL) -> UIImage? {
            // Data will retain a +1 in ARC counter inside NSData
            guard let data = try? Data(contentsOf: url), let image = UIImage(data: data) else {
                return nil
            }
            return image
        }
    }

    private func dispatchBarrier() {
        let bgQueue = DispatchQueue(label: "concurrent-queue", qos: .background, attributes: .concurrent)
        bgQueue.async {
            Thread.sleep(forTimeInterval: 1)
            print("leaving 1s sleep \(Date())")
        }
        bgQueue.async {
            Thread.sleep(forTimeInterval: 2)
            print("leaving 2s sleep \(Date())")
        }
        bgQueue.async {
            print("leaving 0s sleep \(Date())")
        }
        // signals the queue to not allow more work until the barrier has been executed
        bgQueue.async(flags: .barrier) { //must be used on a concurrent queue, otherwise work will be handled sequentially
            print("starting barrier \(Date())")
            Thread.sleep(forTimeInterval: 1)
            print("leaving barrier \(Date())")
        }
        bgQueue.async {
            print("post barrier - leaving 1s sleep \(Date())")
        }
    }

    private func deadLock() {
        return
        let bgQueue = DispatchQueue(label: "concurrent-queue2") // using a .concurrent doesn't crash
        bgQueue.async { // or sync
            print("deadlock started")
            bgQueue.sync { // crash, bgQueue can not operate sync while it is running a block, resource in use and we request to use it
                print("never reaches this point")
            }
            print("never reaches this point")
        }
    }

    private func treeSearch() {
        let root = Tree<Int>()
        let node1 = Tree<Int>(data: 1)
        let node2 = Tree<Int>(data: 2)
        let node3 = Tree<Int>(data: 3)

        root.nodes.append(node1)
        root.nodes.append(node2)
        root.nodes.append(node3)

        node1.nodes.append(Tree<Int>(data: 10))
        node1.nodes.append(Tree<Int>(data: 11))
        node3.nodes.append(Tree<Int>(data: 30))

        let searchResult = root.search(value: 10)
        print("tree search \(searchResult?.description)")
    }
}

class Tree<T: Equatable> {
    var data: T?
    var nodes: [Tree<T>] = [Tree<T>]()

    init(data: T? = nil) {
        self.data = data
    }
}

extension Tree: CustomStringConvertible {
    var description: String {
        return data.debugDescription
    }
}


// We need to implement this method
extension Tree {
    func search(value: T) -> Tree? {
        if let current = data, current == value {
            return self
        } else {
            var target: Tree?
            for node in nodes {
                if let found = node.search(value: value) {
                    target = found
                    break
                }
            }
            return target
        }
    }
}
