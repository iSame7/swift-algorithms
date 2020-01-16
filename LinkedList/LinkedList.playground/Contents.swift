final class LinkedList<T> {
    
    // LinkedListNode
    class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?
        
        init(value: T) {
            self.value = value
        }
    }
    
    /// Default initializer
    init() {}
    
    typealias Node = LinkedListNode<T>
    
    private(set) var head: Node?
    
    var isEmpty: Bool {
        return head == nil
    }
    
    var first: Node? {
        return head
    }
    
    var last: Node? {
        guard var node = head else {
            return nil
        }
        
        while let next = node.next {
            node = next
        }
        
        return node
    }
    
    // count
    var count: Int {
        guard var node = head else {
            return 0
        }
        
        var count = 1
        while let next = node.next {
            node = next
            count += 1
        }
        
        return count
    }
    
    // append
    func append(value: T) {
        let newNode = Node(value: value)
        if let lastNode = last {
            newNode.previous = lastNode
            lastNode.next = newNode
        } else {
            head = newNode
        }
    }
    
    func node(atIndex index: Int) -> Node {
        if index == 0 {
            return head!
        } else {
            var node = head?.next
            
            for _ in 1..<index {
                node = node?.next
                if node == nil {
                    break
                }
            }
            
            return node!
        }
    }
    
    subscript(index: Int) -> T {
        let foundNode = node(atIndex: index)
        return foundNode.value
    }
    
    func insert(_ value: T, atIndex index: Int) {
        let newNode = LinkedListNode(value: value)
        if index == 0 {
            newNode.next = head
            head?.previous = newNode
            head = newNode
        } else {
            let prev = self.node(atIndex: index-1)
            let next = prev.next
            
            newNode.previous = prev
            newNode.next = prev.next
            prev.next = newNode
            next?.previous = newNode
        }
    }
    
    func removeAll() {
        head = nil
    }
    
    public func remove(_ node: Node) -> T {
        let prev = node.previous
        let next = node.next
        
        if let prev = prev {
            prev.next = next
        } else {
            head = next
        }
        next?.previous = prev
        
        node.previous = nil
        node.next = nil
        return node.value
    }
    
    func removeLast() -> T {
        assert(!isEmpty)
        
        return remove(last!)
    }
    
    func removeAt(_ index: Int) -> T {
        let foundNode = node(atIndex: index)
        return remove(foundNode)
    }
    
    func reverse() {
        var node = head
        //      tail = node // If you had a tail pointer
        while let currentNode = node {
            node = currentNode.next
            print("[currentNode]: \(String(describing: currentNode.value))")
            print("[currentNode.next]: \(String(describing: currentNode.next?.value))")
            print("[currentNode.previous]: \(String(describing: currentNode.previous?.value))")
            print("Description before swapping: \(description)")
            swap(&currentNode.next, &currentNode.previous)
            head = currentNode
            print("Head: \(String(describing: head?.value))")
            print("Description: \(description)")
        }
    }
    
    // Map
    func map<U>(transform: (T) -> U) -> LinkedList<U> {
        let result = LinkedList<U>()
        var node = head
        while let nd = node {
            result.append(value: transform(nd.value))
            node = nd.next
        }
        return result
    }
}

// MARK: - LinkedList's higher order functions

extension LinkedList {
    func filter(predicate: (T) -> Bool) -> LinkedList<T> {
        let result = LinkedList<T>()
        var node = head
        while let nd = node {
            if predicate(nd.value) {
                result.append(value: nd.value)
            }
            
            node = nd.next
        }
        return result
    }
}


// MARK: - Extension to enable initialization from an Array
extension LinkedList {
    convenience init(array: Array<T>) {
        self.init()
        
        array.forEach { append(value: $0) }
    }
}

// MARK: - Extension to enable initialization from an Array Literal
extension LinkedList: ExpressibleByArrayLiteral {
    convenience init(arrayLiteral elements: T...) {
        self.init()
        
        elements.forEach { append(value: $0) }
    }
}

// MARK: - Custome debug message

extension LinkedList: CustomStringConvertible {
    var description: String {
        var s = "["
        var node = head
        while node != nil {
            s += "\(node!.value)"
            node = node!.next
            if node != nil {
                s += ", "
            }
        }
        return s + "]"
    }
}


// MARK: - Collection
extension LinkedList: Collection {
    
    public typealias Index = LinkedListIndex<T>
    
    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    /// - Complexity: O(1)
    public var startIndex: Index {
        get {
            return LinkedListIndex<T>(node: head, tag: 0)
        }
    }
    
    /// The collection's "past the end" position---that is, the position one
    /// greater than the last valid subscript argument.
    /// - Complexity: O(n), where n is the number of elements in the list. This can be improved by keeping a reference
    ///   to the last node in the collection.
    public var endIndex: Index {
        get {
            if let h = self.head {
                return LinkedListIndex<T>(node: h, tag: count)
            } else {
                return LinkedListIndex<T>(node: nil, tag: startIndex.tag)
            }
        }
    }
    
    public subscript(position: Index) -> T {
        get {
            return position.node!.value
        }
    }
    
    public func index(after idx: Index) -> Index {
        return LinkedListIndex<T>(node: idx.node?.next, tag: idx.tag + 1)
    }
}

// MARK: - Collection Index
/// Custom index type that contains a reference to the node at index 'tag'
struct LinkedListIndex<T>: Comparable {
    let node: LinkedList<T>.LinkedListNode<T>?
    let tag: Int
    
    public static func==<T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag == rhs.tag)
    }
    
    public static func< <T>(lhs: LinkedListIndex<T>, rhs: LinkedListIndex<T>) -> Bool {
        return (lhs.tag < rhs.tag)
    }
}

// MARK: - Tests  / Debugging

let list = LinkedList<String>()
list.isEmpty
list.first

list.append(value: "Hello")
list.isEmpty
list.first?.value
list.last?.value

list.append(value: "World")
list.first?.value
list.last?.value

list.first?.previous
list.first?.next?.value
list.last?.previous?.value
list.last?.next

list.count

list.node(atIndex: 0).value
list.node(atIndex: 1).value
//list.node(atIndex: 2)

list[0]
list[1]

list.insert("Swift", atIndex: 1)
list[0]
list[1]
list[2]

//list.removeAll()
//list[0]
//list[1]
//list[2]

list.description

//list.reverse()

list.remove(list.first!)
list.count
list[0]
list[1]

list.removeLast()
list.count
list[0]


list.removeAt(0)
list.count


let stringlist = LinkedList<String>()
stringlist.append(value: "Hello")
stringlist.append(value: "Swifty")
stringlist.append(value :"Universe")
stringlist.count

print("S...")
let m = stringlist.map { s in
    s.count
}
m  // [5, 6, 8]

let filteredList = stringlist.filter { s in
    s.count > 5
}
filteredList

import XCTest
// MARK: - Unit testing
class LinkedListTests: XCTestCase {
    // MARK: - Test Properties
    
    let numbers = [8, 2, 10, 9, 7, 5]
    
    fileprivate func buildList() -> LinkedList<Int> {
        let list = LinkedList<Int>()
        for number in numbers {
            list.append(value: number)
        }
        return list
    }
    
    func testSwift4() {
        // last checked with Xcode 9.0b4
        #if swift(>=4.0)
        print("Hello, Swift 4!")
        #endif
    }
    
    func testEmptyList() {
        let list = LinkedList<Int>()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testListWithOneElement() {
        let list = LinkedList<Int>()
        list.append(value: 123)
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 1)
        
        XCTAssertNotNil(list.first)
        XCTAssertNil(list.head!.previous)
        XCTAssertNil(list.head!.next)
        XCTAssertEqual(list.head!.value, 123)
        
        XCTAssertNotNil(list.last)
        XCTAssertNil(list.last!.previous)
        XCTAssertNil(list.last!.next)
        XCTAssertEqual(list.last!.value, 123)
        
        XCTAssertTrue(list.head === list.last)
    }
    
    func testListWithTwoElements() {
        let list = LinkedList<Int>()
        list.append(value: 123)
        list.append(value: 456)
        
        XCTAssertEqual(list.count, 2)
        
        XCTAssertNotNil(list.first)
        XCTAssertEqual(list.head!.value, 123)
        
        XCTAssertNotNil(list.last)
        XCTAssertEqual(list.last!.value, 456)
        
        XCTAssertTrue(list.head !== list.last)
        
        XCTAssertNil(list.head!.previous)
        XCTAssertTrue(list.head!.next === list.last)
        XCTAssertTrue(list.last!.previous === list.head)
        XCTAssertNil(list.last!.next)
    }
    
    func testListWithThreeElements() {
        let list = LinkedList<Int>()
        list.append(value: 123)
        list.append(value: 456)
        list.append(value: 789)
        
        XCTAssertEqual(list.count, 3)
        
        XCTAssertNotNil(list.first)
        XCTAssertEqual(list.head!.value, 123)
        
        let second = list.head!.next
        XCTAssertNotNil(second)
        XCTAssertEqual(second!.value, 456)
        
        XCTAssertNotNil(list.last)
        XCTAssertEqual(list.last!.value, 789)
        
        XCTAssertNil(list.head!.previous)
        XCTAssertTrue(list.head!.next === second)
        XCTAssertTrue(second!.previous === list.head)
        XCTAssertTrue(second!.next === list.last)
        XCTAssertTrue(list.last!.previous === second)
        XCTAssertNil(list.last!.next)
    }
    
    func testNodeAtIndexInListWithOneElement() {
        let list = LinkedList<Int>()
        list.append(value: 123)
        
        let node = list.node(atIndex: 0)
        XCTAssertNotNil(node)
        XCTAssertEqual(node.value, 123)
        XCTAssertTrue(node === list.head)
    }
    
    func testNodeAtIndex() {
        let list = buildList()
        
        let nodeCount = list.count
        XCTAssertEqual(nodeCount, numbers.count)
        
        let first = list.node(atIndex: 0)
        XCTAssertNotNil(first)
        XCTAssertTrue(first === list.head)
        XCTAssertEqual(first.value, numbers[0])
        
        let last = list.node(atIndex: nodeCount - 1)
        XCTAssertNotNil(last)
        XCTAssertTrue(last === list.last)
        XCTAssertEqual(last.value, numbers[nodeCount - 1])
        
        for i in 0..<nodeCount {
            let node = list.node(atIndex: i)
            XCTAssertNotNil(node)
            XCTAssertEqual(node.value, numbers[i])
        }
    }
    
    func testSubscript() {
        let list = buildList()
        for i in 0 ..< list.count {
            XCTAssertEqual(list[i], numbers[i])
        }
    }
    
    func testInsertAtIndexInEmptyList() {
        let list = LinkedList<Int>()
        list.insert(123, atIndex: 0)
        
        XCTAssertFalse(list.isEmpty)
        XCTAssertEqual(list.count, 1)
        
        let node = list.node(atIndex: 0)
        XCTAssertNotNil(node)
        XCTAssertEqual(node.value, 123)
    }
    
    func testInsertAtIndex() {
        let list = buildList()
        let prev = list.node(atIndex: 2)
        let next = list.node(atIndex: 3)
        let nodeCount = list.count
        
        list.insert(444, atIndex: 3)
        
        let node = list.node(atIndex: 3)
        XCTAssertNotNil(node)
        XCTAssertEqual(node.value, 444)
        XCTAssertEqual(nodeCount + 1, list.count)
        
        XCTAssertFalse(prev === node)
        XCTAssertFalse(next === node)
        XCTAssertTrue(prev.next === node)
        XCTAssertTrue(next.previous === node)
    }

    
    func testRemoveAtIndexOnListWithOneElement() {
        let list = LinkedList<Int>()
        list.append(value: 123)
        
        let value = list.removeAt(0)
        XCTAssertEqual(value, 123)
        
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testRemoveAtIndex() {
        let list = buildList()
        let prev = list.node(atIndex: 2)
        let next = list.node(atIndex: 3)
        let nodeCount = list.count
        
        list.insert(444, atIndex: 3)
        
        let value = list.removeAt(3)
        XCTAssertEqual(value, 444)
        
        let node = list.node(atIndex: 3)
        XCTAssertTrue(next === node)
        XCTAssertTrue(prev.next === node)
        XCTAssertTrue(node.previous === prev)
        XCTAssertEqual(nodeCount, list.count)
    }
    
    func testRemoveLastOnListWithOneElement() {
        let list = LinkedList<Int>()
        list.append(value: 123)
        
        let value = list.removeLast()
        XCTAssertEqual(value, 123)
        
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testRemoveLast() {
        let list = buildList()
        let last = list.last
        let prev = last!.previous
        let nodeCount = list.count
        
        let value = list.removeLast()
        XCTAssertEqual(value, 5)
        
        XCTAssertNil(last!.previous)
        XCTAssertNil(last!.next)
        
        XCTAssertNil(prev!.next)
        XCTAssertTrue(list.last === prev)
        XCTAssertEqual(nodeCount - 1, list.count)
    }
    
    func testRemoveAll() {
        let list = buildList()
        list.removeAll()
        XCTAssertTrue(list.isEmpty)
        XCTAssertEqual(list.count, 0)
        XCTAssertNil(list.first)
        XCTAssertNil(list.last)
    }
    
    func testReverseLinkedList() {
        let list = buildList()
        let first = list.head
        let last = list.last
        let nodeCount = list.count
        
        list.reverse()
        
        XCTAssertTrue(first === list.last)
        XCTAssertTrue(last === list.head)
        XCTAssertEqual(nodeCount, list.count)
    }
    
    func testArrayLiteralInitTypeInfer() {
        let arrayLiteralInitInfer: LinkedList = [1.0, 2.0, 3.0]
        
        XCTAssertEqual(arrayLiteralInitInfer.count, 3)
        XCTAssertEqual(arrayLiteralInitInfer.head?.value, 1.0)
        XCTAssertEqual(arrayLiteralInitInfer.last?.value, 3.0)
        XCTAssertEqual(arrayLiteralInitInfer[1], 2.0)
        XCTAssertEqual(arrayLiteralInitInfer.removeLast(), 3.0)
        XCTAssertEqual(arrayLiteralInitInfer.count, 2)
    }
    
    func testArrayLiteralInitExplicit() {
        let arrayLiteralInitExplicit: LinkedList<Int> = [1, 2, 3]

        XCTAssertEqual(arrayLiteralInitExplicit.count, 3)
        XCTAssertEqual(arrayLiteralInitExplicit.head?.value, 1)
        XCTAssertEqual(arrayLiteralInitExplicit.last?.value, 3)
        XCTAssertEqual(arrayLiteralInitExplicit[1], 2)
        XCTAssertEqual(arrayLiteralInitExplicit.removeLast(), 3)
        XCTAssertEqual(arrayLiteralInitExplicit.count, 2)
    }
    
    func testConformanceToCollectionProtocol() {
        let collection: LinkedList<Int> = [1, 2, 3, 4, 5]
        let index2 = collection.index(collection.startIndex, offsetBy: 2)
        let value = collection[index2]
        
        XCTAssertTrue(value == 3)
    }
}

// To not miss failures, this test observer triggers an assertion failure in case of a test failure.
class TestObserver: NSObject, XCTestObservation {
    func testCase(_ testCase: XCTestCase,
                  didFailWithDescription description: String,
                  inFile filePath: String?,
                  atLine lineNumber: Int) {
        assertionFailure(description, line: UInt(lineNumber))
    }
}

let testObserver = TestObserver()
XCTestObservationCenter.shared.addTestObserver(testObserver)
// run tests with defaultTestSuite
LinkedListTests.defaultTestSuite.run()
