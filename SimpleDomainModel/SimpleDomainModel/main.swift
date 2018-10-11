//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

open class TestMe {
  open func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
    public var amount : Int
    public var currency : String
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    private func toUSD(_ amount: Int, _ currency: String) -> Int {
        switch currency {
        case "GBP":
            return amount * 2
        case "EUR":
            return amount * 2 / 3
        case "CAN":
            return amount * 4 / 5
        default:
            return amount
        }
    }
    
    public func convert(_ to: String) -> Money {
        let usdValue = toUSD(amount, currency)
        switch to {
        case "GBP":
            return Money(amount: usdValue * 1 / 2, currency: "GBP")
        case "EUR":
            return Money(amount: usdValue * 3 / 2, currency: "EUR")
        case "CAN":
            return Money(amount: usdValue * 5 / 4, currency: "CAN")
        default:
            return Money(amount: usdValue, currency: "USD")
        }
    }
    
    public func add(_ to: Money) -> Money {
        let converted = self.convert(to.currency)
        return Money(amount: converted.amount + to.amount, currency: to.currency)
    }
    
    public func subtract(_ from: Money) -> Money {
        let converted = self.convert(from.currency)
        return Money(amount: from.amount - converted.amount, currency: from.currency)
    }
}

////////////////////////////////////
// Job
//
open class Job {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch type {
        case let .Hourly(amount):
            return Int(amount * Double(hours))
        case let .Salary(amount):
            return amount
        }
    }
    
    open func raise(_ amt: Double) {
        switch type {
        case let .Hourly(amount):
            type = .Hourly(amount + amt)
        case let .Salary(amount):
            type = .Salary(amount + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    fileprivate var _job: Job? = nil
    open var job : Job? {
        get {
            if age < 16 {
                _job = nil
            }
            return _job
        }
        set(value) {
            _job = value
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            if age < 16 {
                _spouse = nil
            }
            return _spouse
        }
        set(value) {
            _spouse = value
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(String(age)) job:\(String(describing: job?.type)) spouse:\(String(describing: spouse?.firstName))]"
    }
}

////////////////////////////////////
// Family
//
open class Family {
    fileprivate var members : [Person] = []
    
    public init(spouse1: Person, spouse2: Person) {
        if spouse1.spouse == nil && spouse2.spouse == nil {
            members.append(spouse1)
            members.append(spouse2)
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if members[0].age < 21  && members[1].age < 21 {
            return false
        } else {
            members.append(child)
            return true
        }
    }
    
    open func householdIncome() -> Int {
        var total: Int = 0
        for member in members {
            if member.job != nil {
                total += member.job!.calculateIncome(2000)
            }
        }
        return total
    }
}





