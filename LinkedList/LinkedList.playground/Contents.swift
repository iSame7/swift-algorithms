class LinkedList<T> {
    
    // LinkedListNode
    class LinkedListNode<T> {
        var value: T
        var next: LinkedListNode?
        weak var previous: LinkedListNode?
        
        init(value: T) {
            self.value = value
        }
    }
    
    typealias Node = LinkedListNode<T>
    
    private var head: Node?
    
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
