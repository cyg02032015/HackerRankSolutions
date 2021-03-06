//
//  HackerRankHelper.swift
//  HRSwift
//
//  Created by yansong li on 2015-11-20.
//  Copyright © 2015 yansong li. All rights reserved.
//

import Foundation

/**
    This document may contain code that use swift1.2 since HackerRank only support swift1.2
 
    But if possible I could write some swift2.* code and I will annotate them.
 
*/
 
// MARK: Basic Operations

/**
    HackerRank GetLine
    
    - Returns: String from stdin
*/

public func getLine() -> String {
    var buf = String()
    var c = getchar()
    // 10 is the ascii code for new line
    while c != EOF && c != 10 {
        buf.append(UnicodeScalar(UInt32(c)))
        c = getchar()
    }
    return buf
}

public func getInt() -> Int {
    return Int(getLine())!
}

public func getLineToArray() -> [String] {
    let currentLine = getLine()
    let retVal = currentLine.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    return retVal.filter { Int($0) != nil }
}

/**
 *  reading into n lines and combine them into an Array
 *  
 *  - parameter n: number of lines you want to read in
 */
public func getLinesToArray(n: Int) -> [String] {
    var retVal: [String] = []
    for _ in 0..<n {
        retVal.append(getLine())
    }
    return retVal
}

/**
    Get all primes up to length
    
    - parameter length: the upper boundary for primes
    - returns : an array of all primes in that range
*/
public func getBetterPrimes(length:Int) -> [Int] {
    // Here the length means how many elements we have
    // This prime finder is a specific one because we want to find gap that is prime
    // so we start from 3
    var primes = [Int]()
    if length < 3 {
        return primes
    }
    
    // here since we want to find gap, length should not be included, start from 2 since 2 is the smallest prime
    for i in 2...length {
        var currentIsPrime = true
        // check prime is general, we should use count from 2 to sqrt(i) to see whether or not it
        // could be divided.
        let higherBounder = sqrt(Double(i))
        let intHigher = Int(higherBounder)
        if intHigher >= 2 {
            for j in 2...intHigher {
                if i % j == 0 {
                    currentIsPrime = false
                    break
                }
            }
        }
        
        if currentIsPrime {
            primes.append(i)
        }
    }
    return primes
}

/**
 
    This method return the num of elements that less than or equal to target
    e.g. [2, 3, 5] input 5, will return 3 means there are 3 elements less than or equal to 5
    
    - parameter inputs: array that to be processed
    - target: target to be found
 
 */

public func binarySearchLessOrEqualIndex(inputs:[Int], target:Int) -> Int {
    var lowerIndex = 0
    var higherIndex = inputs.count - 1
    
    var indexToCheck = (higherIndex + lowerIndex) / 2
    while lowerIndex <= higherIndex {
        if inputs[indexToCheck] == target {
            return indexToCheck + 1
        } else if (inputs[indexToCheck] < target) {
            lowerIndex = indexToCheck + 1
            indexToCheck = (higherIndex + lowerIndex) / 2
        } else {
            higherIndex = indexToCheck - 1
            indexToCheck = (higherIndex + lowerIndex) / 2
        }
    }
    
    // At this point our lower exceed higher
    return higherIndex + 1
}

/**
 *  give an array find the smallest element's index that is larger or equal to key
 *  
 *  - parameter inputs: array to be operated on
 *  - parameter l:      left boundary
 *  - parameter r:      right boundary
 *  - parameter key:    target to be found
 */
public func ceilIndex<T: Comparable>(inputs:[T], var l: Int, var r: Int, key: T) -> Int {
    while r - l > 1 {
        var m = l + (r - l)/2
        if inputs[m] >= key {
            r = m
        } else {
            l = m
        }
    }
    return r
}

func Fibonacci(n: Int) -> Int {
    return n < 2 ? n : Fibonacci(n-1) + Fibonacci(n-2)
}


/**
    Swift implementation of memoization 
    
    - parameter body: a closure with itself type and input, who's input want to be memorized
 
    - returns: a closure who's input has already in a memorized way
 */
func memoize<T: Hashable, U: Comparable>( body:((T)->U, T)->U ) -> (T)->U {
    var memo = Dictionary<T, U>()
    var result: ((T)->U)!
    result = { x in
        if let q = memo[x] { return q }
        let r = body(result, x)
        memo[x] = r
        return r
    }
    return result
}


// MARK: extensions

/**
    Extension: Character
*/
public extension Character {
    /**
     Convert a Character to unicodeScalar value
     e.g turn 'a' to 97
     */
    
    func unicodeScalarCodePoint() -> Int {
        let characterString = String(self)
        let scalars = characterString.unicodeScalars
        
        return Int(scalars[scalars.startIndex].value)
    }
}

public extension Dictionary {
    
//    /**
//        Initialize Dictionary with SequenceTpye
//     */
//    init<S:SequenceType where S.Generator.Element == (Key, Value)>(_ sequence: S) {
//        self = [:]
//        self.merge(sequence)
//    }
//    
//    /**
//     Merge Dictionary
//     
//     Merge other to self, replace those values if key already exists.
//     */
//    mutating func merge<S: SequenceType where S.Generator.Element == (Key, Value)>(other: S) {
//        for (k, v) in other {
//            self[k] = v
//        }
//    }
}

public extension SequenceType where Generator.Element: Hashable {
    
    /**
        Given a sequence of array returns unique element
    */
    func unique() -> [Generator.Element] {
        var seen: Set<Generator.Element> = []
        return filter {
            if seen.contains($0) {
                return false
            } else {
                seen.insert($0)
                return true
            }
        }
    }
}

public extension String {
    /**
     Check whether this string contains all the English Characters, this method treat upper case and lower case the same
     
     - returns: whether or not contains all the english characters
     */
    func containsAllEnglishCharacters() -> Bool {
        guard self.characters.count >= 26 else { return false }
        var englishCharacters: Set<Int> = []
        let a : Character = "a"
        for c in self.characters {
            let lowerCs = String(c).lowercaseString.characters
            let lowerC = lowerCs[lowerCs.startIndex]
            let index = lowerC.unicodeScalarCodePoint() - a.unicodeScalarCodePoint()
            switch index {
                case 0..<26:
                    if !englishCharacters.contains(index) {
                        englishCharacters.insert(index)
                        if englishCharacters.count == 26 {
                            return true
                        }
                    }
                default:
                    continue
            }
        }
        return false
    }
    
    /**
     Convert a string to a Set
     
     - returns: a set of Characters
     */
    func convertToCharacterSet() -> Set<Character> {
        var uniqueCharacters: Set<Character> = []
        for c in self.characters {
            if !uniqueCharacters.contains(c) {
                uniqueCharacters.insert(c)
            }
        }
        return uniqueCharacters
    }
    
    /**
     Check whether or not a string is a palindrome
     
     - returns: boolean value indicate whether or not a string is a palindrome
     */
    func isPalindrome() -> Bool {
        let reversed = String(self.characters.reverse())
        return reversed == self
    }
}

public extension Double {
    func format(f: String) -> String {
        return NSString(format: "%\(f)f", self) as String
    }
}

// MARK: Functional Class

/**
 *   Python range() like Structure
 *
 *   it will generate a sequence from start to end with step. e.g start 1, end 10, step 2 -> 1, 3, 5, 7, 9
 */

struct SRange: SequenceType {
    var start: Int = 0
    var end: Int = 0
    var step: Int = 0
    
    init(start: Int = 0, end: Int, step: Int = 1) {
        self.start = start
        self.end = end
        self.step = step
    }
    
    func generate() -> RangeGenerator {
        return RangeGenerator(start: start, end: end, step: step)
    }
}

class RangeGenerator: GeneratorType {
    let start: Int
    let end: Int
    let step: Int
    let clockWise: Bool
    
    var stepNum = 0
    
    init(start: Int, end: Int, step: Int) {
        self.start = start
        self.end = end
        self.step = step
        clockWise = step > 0
    }
    
    func next() -> Int? {
        if clockWise {
            guard start + stepNum * step < end else { return nil }
            return start + step * stepNum++
        } else {
            guard start + stepNum * step > end else { return nil }
            return start + step * stepNum++
        }
    }
}



// MARK: Data Structures

/**
*  Queue FIFO, this implementation could achieve amortised O(1) enqueue and dequeue
*/

struct Queue<Element> {
    private var left: [Element]
    private var right: [Element]
    
    init() {
        left = []
        right = []
    }
    
    /**
     Enqueue an element into Queue
     
     - parameter element: the element that need to be enqueued
     */
    mutating func enqueue(element: Element) {
        right.append(element)
    }
    
    mutating func dequeue() -> Element? {
        guard !(left.isEmpty && right.isEmpty) else { return nil }
        if left.isEmpty {
            left = right.reverse()
            right.removeAll(keepCapacity: true)
        }
        return left.removeLast()
    }
    
    func isEmpty() -> Bool {
        return left.isEmpty && right.isEmpty
    }
}

extension Queue: CollectionType {
    var startIndex: Int { return 0 }
    var endIndex: Int { return left.count + right.count }
    
    subscript(idx: Int) -> Element {
        guard idx < endIndex else { fatalError("Index out of bounds") }
        if idx < left.endIndex {
            return left[left.count - idx.successor()]
        } else {
            return right[idx - left.count]
        }
    }
}


/**
    LinkedListQueue 
*/
public class LinkedListQueue<Element: CustomStringConvertible> {
    private var head: ListNode<Element>
    private var end: ListNode<Element>
    public var count: Int
    
    init() {
        // dumped node stands for head
        head = ListNode<Element>()
        end = head
        count = 0
    }
    
    public func enqueue(element: Element) {
        let newNode = ListNode(element)
        end.next = newNode
        newNode.pre = end
        end = newNode
        count += 1
    }
    
    func dequeue() -> Element? {
        if isEmpty() {
            return nil
        }
        let retVal = head.next!.value!
        if let nextHead = head.next!.next {
            head.next = nextHead
            nextHead.pre = head
        } else {
            end = head
        }
        count -= 1
        return retVal
    }
    
    func isEmpty() -> Bool {
        return head === end
    }
    
    func description() {
        print(head)
    }
}


/**
 *   ListNode Class
 */
class ListNode<T: CustomStringConvertible>{
    var value: T?
    var next: ListNode?
    var pre: ListNode?
    
    init() {}
    
    convenience init(_ value: T) {
        self.init()
        self.value = value
    }
    
    /**
     Reverse a ListNode return a new ListNode with reversed order
     
     - parameter node: node to be reversed
     
     - returns: a brand new node with reversed elements
     */
    static func reverse(node: ListNode?) -> ListNode? {
        var prev: ListNode? = nil
        var head = node
        while head != nil {
            let newHead = ListNode(head!.value!)
            let tmp = head!.next
            newHead.next = prev
            prev = newHead
            head = tmp
        }
        return prev
    }
    
}

extension ListNode: CustomStringConvertible {
    var description:String {
        if let next = next {
            if let value = value {
                return "Node(v:\(value)) -> \(next)"
            } else {
                return "Node(v: NULL) -> \(next)"
            }
        } else {
            if let value = value {
                return "Node(v:\(value)) -> NULL"
            } else {
                return "Node(v: NULL) -> NULL"
            }
        }
    }
}

// TODO: AVL Tree

//
//  AVLTree.swift
//  AVLTree
//
//  Swift port of immutable AVLTree I implemented with Stephan Partzsch
//
//  Original ObjC implementation: https://github.com/StephanPartzsch/AVLTree
//
//  Copyright (c) 2014 Maxim Zaks. All rights reserved.
//

func ||<T>(optional : Optional<T>, defaultValue : T) -> T {
    if let value = optional {
        return value
    }
    return defaultValue
}

public func +<T>(node : AVLNode<T>, newValue : T) -> AVLNode<T> {
    var newLeft : AVLNode<T>? = node.left
    var newRight : AVLNode<T>? = node.right
    if(newValue < node.value) {
        if let left = node.left {
            newLeft = left + newValue
        } else {
            newLeft = AVLNode(newValue)
        }
    } else if(newValue > node.value) {
        if let right = node.right {
            newRight = right + newValue
        } else {
            newRight = AVLNode(newValue)
        }
    } else {
        return node
    }
    
    let newRoot = AVLNode(value: node.value, left: newLeft, right: newRight)
    
    return newRoot.fixBalance()
}

public func-<T>(node: AVLNode<T>?, value : T) -> AVLNode<T>? {
    return node?.remove(value).result
}

public func +<T>(tree : AVLTree<T>, newValue : T) {
    if let root = tree.root {
        tree.root = root + newValue
    } else {
        tree.root = AVLNode(newValue)
    }
    tree.count = tree.root!.count
}

public func-<T>(tree: AVLTree<T>, value : T) {
    if let root = tree.root {
        tree.root = root - value
        tree.count = tree.root?.count ?? 0
    }
}

public class AVLTree<T: Comparable> {
    var root: AVLNode<T>?
    var count: UInt = 0
}

public extension AVLTree {
    
    convenience init(value: T) {
        self.init()
        root = AVLNode(value)
        count = root!.count
    }
}


public final class AVLNode<T : Comparable> {
    typealias Element = T
    let left : AVLNode<Element>?
    let right : AVLNode<Element>?
    public let count : UInt
    let depth : UInt
    let balance : Int
    let value : Element!
    
    public convenience init(_ value : T){
        self.init(value: value, left: nil, right: nil)
    }
    
    public func contains(value : T) -> Bool{
        if self.value == value {
            return true
        }
        if left?.contains(value) == true {
            return true
        }
        if right?.contains(value) == true {
            return true
        }
        
        return false
    }
    
    init(value : T, left: AVLNode<T>?, right: AVLNode<T>?){
        self.value = value
        self.left = left
        self.right = right
        self.count = 1 + (left?.count || 0) + (right?.count || 0)
        self.depth = 1 + max((left?.depth || 0), (right?.depth || 0))
        self.balance = Int((left?.depth || 0)) - Int((right?.depth || 0))
    }
    
    func fixBalance() -> AVLNode<Element> {
        if abs(balance) < 2 {
            return self
        }
        
        if (balance == 2)
        {
            let leftBalance = self.left?.balance || 0
            
            if (leftBalance == 1 || leftBalance == 0)
            {
                //Easy case:
                return rotateToRight()
            }
            
            if (leftBalance == -1)
            {
                //Rotate Left to left
                let newLeft = left!.rotateToLeft()
                let newRoot = AVLNode(value: value, left: newLeft, right: right)
                
                return newRoot.rotateToRight()
            }
            
            fatalError("LeftNode too unbalanced")
        }
        
        if (balance == -2)
        {
            let rightBalance = right?.balance || 0
            
            if (rightBalance == -1 || rightBalance == 0)
            {
                //Easy case:
                return rotateToLeft()
            }
            
            if (rightBalance == 1)
            {
                //Rotate right to right
                let newRight = right!.rotateToRight()
                let newRoot = AVLNode(value: value, left: left, right: newRight)
                
                return newRoot.rotateToLeft()
            }
            
            fatalError("RightNode too unbalanced")
        }
        
        fatalError("Tree too unbalanced")
    }
    
    func remove(value : Element) -> (result: AVLNode<Element>?, foundFlag :Bool){
        if value < self.value {
            
            let removeResult = left?.remove(value)
            
            if removeResult == nil || removeResult!.foundFlag == false {
                // Not found, so nothing changed
                return (self, false)
            }
            
            let newRoot = AVLNode(value: self.value, left: removeResult!.result, right: right).fixBalance()
            
            return (newRoot, true)
        }
        
        if value > self.value {
            let removeResult = right?.remove(value)
            
            if removeResult == nil || removeResult!.foundFlag == false {
                // Not found, so nothing changed
                return (self, false)
            }
            
            let newRoot = AVLNode(value: self.value, left: left, right: removeResult!.result)
            
            return (newRoot, true)
        }
        
        //found it
        return (removeRoot(), true)
    }
    
    func removeMin()-> (min : AVLNode<Element>, result : AVLNode<Element>?){
        if left == nil {
            //We are the minimum:
            return (self, right)
        } else {
            //Go down:
            let (min, newLeft) = left!.removeMin()
            let newRoot = AVLNode(value: value, left: newLeft, right: right)
            
            return (min, newRoot.fixBalance())
        }
    }
    
    func removeMax()-> (max : AVLNode<Element>, result : AVLNode<Element>?){
        if right == nil {
            //We are the max:
            return (self, left)
        } else {
            //Go down:
            let (max, newRight) = right!.removeMax()
            let newRoot = AVLNode(value: value, left: left, right: newRight)
            
            return (max, newRoot.fixBalance())
        }
    }
    
    func removeRoot() -> AVLNode<Element>? {
        if left == nil {
            return right
        }
        
        if right == nil {
            return left
        }
        
        //Neither are empty:
        if left!.count < right!.count {
            // LeftNode has fewer, so promote from RightNode to minimize depth
            let (min, newRight) = right!.removeMin()
            let newRoot = AVLNode(value: min.value, left: left, right: newRight)
            
            return newRoot.fixBalance()
        }
        else
        {
            let (max, newLeft) = left!.removeMax()
            let newRoot = AVLNode(value: max.value, left: newLeft, right: right)
            
            return newRoot.fixBalance()
        }
    }
    
    func rotateToRight() -> AVLNode<Element> {
        let newRight = AVLNode(value: value, left: left!.right, right: right)
        return AVLNode(value: left!.value, left: left!.left, right: newRight)
    }
    
    func rotateToLeft() -> AVLNode<Element> {
        let newLeft = AVLNode(value: value, left: left, right: right!.left)
        return AVLNode(value: right!.value, left: newLeft, right: right!.right)
    }
}

extension AVLNode : CustomStringConvertible, CustomDebugStringConvertible {
    public var description : String {
        get {
            let empty = "_"
            return "(\(value) \(left?.description || empty) \(right?.description || empty))"
        }
    }
    
    public var debugDescription : String {
        get {
            return self.description
        }
    }
}


//  SequenceType implementation is based on following blog post:
//  http://www.spazcosoft.com/posts/data-structures-in-swift-part-1-wow-thats-an-unstable-compiler/

extension AVLNode : SequenceType {
    public func generate() -> AnyGenerator<T> {
        
        var stack : [AVLNode<Element>] = []
        var current : AVLNode<Element>? = self
        
        return anyGenerator {
            while(stack.count != 0 || current != nil){
                if(current != nil) {
                    stack.append(current!)
                    current = current!.left
                } else {
                    let retval = stack.removeLast();
                    current = retval.right
                    return retval.value
                }
            }
            
            return nil
        }
    }
}

struct ReversedSequenceOfAvlNode<T : Comparable> : SequenceType {
    let node : AVLNode<T>
    func generate() -> AnyGenerator<T> {
        
        var stack : [AVLNode<T>] = []
        var current : AVLNode<T>? = node
        
        return anyGenerator {
            while(stack.count != 0 || current != nil){
                if(current != nil) {
                    stack.append(current!)
                    current = current!.right
                } else {
                    let retval = stack.removeLast();
                    current = retval.left
                    return retval.value
                }
            }
            
            return nil
        }
    }
}

extension AVLNode {
    public var reversed : AnySequence<T> {
        get {
            return AnySequence(ReversedSequenceOfAvlNode(node: self))
        }
    }
}


/**
 * BinaryIndexedTree: a data structure used for storing frequencies and manipulating cumulative frequency.
 *
 * e.g to search a frequency from n..m O(n), by using BIT we could fast get this result O(lgn)
 *
 */

public class BinaryIndexedTree {
    // we ignore 0th element, since it's no sence to count non-exist element's occurence.
    
    // size is actually the maximum count that could occur.
    let size: Int
    var tree: [Int]
    
    
    init(size: Int) {
        self.size = size
        tree = Array(count: size+1, repeatedValue: 0)
    }
    
    /**
     * Update BIT at pos with some val
     *
     * - parameter pos: Index to BIT array, usually means number for item quantity
     * - parameter val: this index's frequency's change
     */
    func update(var pos: Int, val: Int) {
        guard pos > 0 else { return }
        while pos <= size {
            tree[pos] += val
            pos += (Int(pos)&Int(-pos))
        }
    }
    
    /**
     * Query BIT the cumulative frequencies for index pos
     *
     * - parameter pos: Index to query, usually means number for item quantity
     */
    func query(var pos: Int) -> Int {
        var sum = 0
        while pos > 0 {
            sum += tree[pos]
            pos -= (Int(pos)&Int(-pos))
        }
        return sum
    }
}


// TODO: Priority Queue



