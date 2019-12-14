//
//  EarlGrey+Wei.swift
//  WeMoTests
//
//  Created by zhiwei on 2019/12/14.
//  Copyright © 2019 Wei. All rights reserved.
//

import EarlGrey
import Sencha //for using enum Matcher

//protocol WEIInteraction<Ojc>: GREYInteraction {}
//protocol WEIMatcher<Ojc>: GREYMatcher {}
typealias WEIInteraction = GREYInteraction
typealias WEIMatcher = GREYMatcher

struct WEI {
    
    static func select(with matcher: Matcher, file: StaticString = #file, line: UInt = #line) -> WEIInteraction {
        
        return select(with: matcher.greyMatcher(), file: file, line: line)
        
    }
    
    static func select(with matcher: WEIMatcher, file: StaticString = #file, line: UInt = #line) -> WEIInteraction {
        
        return EarlGrey.selectElement(with: matcher, file: file, line: line)
        
    }
    
}

extension WEIInteraction {
    
    subscript(rootMatcher: Matcher) -> WEIInteraction { return self[rootMatcher.greyMatcher()] }
    
    subscript(rootMatcher: WEIMatcher) -> WEIInteraction { return self.inRoot(rootMatcher) }
    
    subscript(index: UInt) -> WEIInteraction { return self.atIndex(index) }
    
    func wait(for matcher: Matcher, timeout: CFTimeInterval, interval: CFTimeInterval,
              file: StaticString = #file, line: UInt = #line) -> WEIInteraction {
        
        return wait(for: matcher.greyMatcher(), timeout: timeout, interval: interval,
                    file: file, line: line)
        
    }
    
    func wait(for matcher: WEIMatcher, timeout: CFTimeInterval, interval: CFTimeInterval,
              file: StaticString = #file, line: UInt = #line) -> WEIInteraction {
        
        let text = "\(#function) for \(matcher)"
        
        let condition = GREYCondition(name: text) { [weak self] in
            
            var error: NSError?
            
            self?.assert(matcher, error: &error)
            
            return error == nil && self != nil
            
        }
        
        let result = condition.wait(withTimeout: timeout, pollInterval: interval)
        
        GREYAssertTrue(result, reason: "Failed \(text)")
        
        return self
        
    }
    
    @discardableResult
    func assert(for assertion: WEIAssertion) -> WEIInteraction {
        
        return self.assert(assertion.rawValue)
        
    }
    
}

struct WEIAssertion: Equatable {
    
    private let name: String
    
    private var dict: [String: Any] = [:]
    
    fileprivate var rawValue: GREYAssertion!
    
    static func == (lhs: Self, rhs: Self) -> Bool { return lhs.name == rhs.name }
    
}

extension WEIAssertion {
    
    struct TableView {
        
        static let isNotEmpty: WEIAssertion = {
            
            var a = WEIAssertion(name: "tableViewIsNotEmpty")
            
            a.rawValue = GREYAssertionBlock(name: a.name) { (element, error) -> Bool in
                guard let tableView = element as? UITableView else { return false }
                guard tableView.numberOfSections > 0 else { return false }
                let numberOfCells = tableView.numberOfRows(inSection: 0)
                return numberOfCells > 0
            }
            
            return a
            
        }()
        
        static func sectionCount(_ value: Int) -> WEIAssertion {
            
            var a = WEIAssertion(name: "tableViewCellCount")
            
            a.rawValue =  GREYAssertionBlock(name: "section count") { (element, error) -> Bool in
                guard let tableView = element as? UITableView else { return false }
                let numberOfSections = tableView.numberOfSections
                return numberOfSections == value
            }
            
            return a
            
        }
        
        static func cellCount(_ value: Int, inSection section: Int) -> WEIAssertion {
            
            var a = WEIAssertion(name: "tableViewCellCount")
            
            a.rawValue = GREYAssertionBlock(name: "cell count") { (element, error) -> Bool in
                guard let tableView = element as? UITableView else { return false }
                guard tableView.numberOfSections > section else { return false }
                let numberOfCells = tableView.numberOfRows(inSection: section)
                return numberOfCells == value
            }
            
            return a
            
        }
        
    }
    
}
