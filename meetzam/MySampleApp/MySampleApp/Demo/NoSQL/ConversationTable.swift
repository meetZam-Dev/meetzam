//
//  ConversationTable.swift
//  MySampleApp
//
//
// Copyright 2017 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-swift v0.10
//

import Foundation
import UIKit
import AWSDynamoDB
import AWSMobileHubHelper

class ConversationTable: NSObject, Table {
    
    var tableName: String
    var partitionKeyName: String
    var partitionKeyType: String
    var sortKeyName: String?
    var sortKeyType: String?
    var model: AWSDynamoDBObjectModel
    var indexes: [Index]
    var orderedAttributeKeys: [String] {
        return produceOrderedAttributeKeys(model)
    }
    var tableDisplayName: String {

        return "Conversation"
    }
    
    override init() {

        model = Conversation()
        
        tableName = model.classForCoder.dynamoDBTableName()
        partitionKeyName = model.classForCoder.hashKeyAttribute()
        partitionKeyType = "String"
        indexes = [

            ConversationPrimaryIndex(),

            ConversationByCreationDate(),
        ]
        if let sortKeyNamePossible = model.classForCoder.rangeKeyAttribute?() {
            sortKeyName = sortKeyNamePossible
            sortKeyType = "String"
        }
        super.init()
    }
    
    /**
     * Converts the attribute name from data object format to table format.
     *
     * - parameter dataObjectAttributeName: data object attribute name
     * - returns: table attribute name
     */

    func tableAttributeName(_ dataObjectAttributeName: String) -> String {
        return Conversation.jsonKeyPathsByPropertyKey()[dataObjectAttributeName] as! String
    }
    
    func getItemDescription() -> String {
        let hashKeyValue = AWSIdentityManager.default().identityId!
        let rangeKeyValue = "demo-conversationId-500000"
        return "Find Item with userId = \(hashKeyValue) and conversationId = \(rangeKeyValue)."
    }
    
    func getItemWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBObjectModel?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        objectMapper.load(Conversation.self, hashKey: AWSIdentityManager.default().identityId!, rangeKey: "demo-conversationId-500000") { (response: AWSDynamoDBObjectModel?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func scanDescription() -> String {
        return "Show all items in the table."
    }
    
    func scanWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        scanExpression.limit = 5

        objectMapper.scan(Conversation.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as NSError?)
            })
        }
    }
    
    func scanWithFilterDescription() -> String {
        let scanFilterValue = "demo-createdAt-500000"
        return "Find all items with createdAt < \(scanFilterValue)."
    }
    
    func scanWithFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let scanExpression = AWSDynamoDBScanExpression()
        
        scanExpression.filterExpression = "#createdAt < :createdAt"
        scanExpression.expressionAttributeNames = ["#createdAt": "createdAt" ,]
        scanExpression.expressionAttributeValues = [":createdAt": "demo-createdAt-500000" ,]

        objectMapper.scan(Conversation.self, expression: scanExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func insertSampleDataWithCompletionHandler(_ completionHandler: @escaping (_ errors: [NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        var errors: [NSError] = []
        let group: DispatchGroup = DispatchGroup()
        let numberOfObjects = 20
        

        let itemForGet: Conversation! = Conversation()
        
        itemForGet._userId = AWSIdentityManager.default().identityId!
        itemForGet._conversationId = "demo-conversationId-500000"
        itemForGet._chatRoomId = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("chatRoomId")
        itemForGet._createdAt = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("createdAt")
        itemForGet._imageUrlPath = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("imageUrlPath")
        itemForGet._message = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("message")
        
        
        group.enter()
        

        objectMapper.save(itemForGet, completionHandler: {(error: Error?) -> Void in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    errors.append(error)
                })
            }
            group.leave()
        })
        
        for _ in 1..<numberOfObjects {

            let item: Conversation = Conversation()
            item._userId = AWSIdentityManager.default().identityId!
            item._conversationId = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("conversationId")
            item._chatRoomId = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("chatRoomId")
            item._createdAt = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("createdAt")
            item._imageUrlPath = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("imageUrlPath")
            item._message = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("message")
            
            group.enter()
            
            objectMapper.save(item, completionHandler: {(error: Error?) -> Void in
                if error != nil {
                    DispatchQueue.main.async(execute: {
                        errors.append(error! as NSError)
                    })
                }
                group.leave()
            })
        }
        
        group.notify(queue: DispatchQueue.main, execute: {
            if errors.count > 0 {
                completionHandler(errors)
            }
            else {
                completionHandler(nil)
            }
        })
    }
    
    func removeSampleDataWithCompletionHandler(_ completionHandler: @escaping ([NSError]?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId"]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]

        objectMapper.query(Conversation.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            if let error = error as? NSError {
                DispatchQueue.main.async(execute: {
                    completionHandler([error]);
                    })
            } else {
                var errors: [NSError] = []
                let group: DispatchGroup = DispatchGroup()
                for item in response!.items {
                    group.enter()
                    objectMapper.remove(item, completionHandler: {(error: Error?) in
                        if let error = error as? NSError {
                            DispatchQueue.main.async(execute: {
                                errors.append(error)
                            })
                        }
                        group.leave()
                    })
                }
                group.notify(queue: DispatchQueue.main, execute: {
                    if errors.count > 0 {
                        completionHandler(errors)
                    }
                    else {
                        completionHandler(nil)
                    }
                })
            }
        }
    }
    
    func updateItem(_ item: AWSDynamoDBObjectModel, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        

        let itemToUpdate: Conversation = item as! Conversation
        
        itemToUpdate._chatRoomId = NoSQLSampleDataGenerator.randomPartitionSampleStringWithAttributeName("chatRoomId")
        itemToUpdate._createdAt = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("createdAt")
        itemToUpdate._imageUrlPath = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("imageUrlPath")
        itemToUpdate._message = NoSQLSampleDataGenerator.randomSampleStringWithAttributeName("message")
        
        objectMapper.save(itemToUpdate, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(error as? NSError)
            })
        })
    }
    
    func removeItem(_ item: AWSDynamoDBObjectModel, completionHandler: @escaping (_ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        
        objectMapper.remove(item, completionHandler: {(error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(error as? NSError)
            })
        })
    }
}

class ConversationPrimaryIndex: NSObject, Index {
    
    var indexName: String? {
        return nil
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        return "Find all items with userId = \(partitionKeyValue)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.expressionAttributeNames = ["#userId": "userId",]
        queryExpression.expressionAttributeValues = [":userId": AWSIdentityManager.default().identityId!,]

        objectMapper.query(Conversation.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        let filterAttributeValue = "demo-createdAt-500000"
        return "Find all items with userId = \(partitionKeyValue) and createdAt > \(filterAttributeValue)."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId"
        queryExpression.filterExpression = "#createdAt > :createdAt"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#createdAt": "createdAt",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId!,
            ":createdAt": "demo-createdAt-500000",
        ]
        

        objectMapper.query(Conversation.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        let sortKeyValue = "demo-conversationId-500000"
        return "Find all items with userId = \(partitionKeyValue) and conversationId < \(sortKeyValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #conversationId < :conversationId"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#conversationId": "conversationId",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId!,
            ":conversationId": "demo-conversationId-500000",
        ]
        

        objectMapper.query(Conversation.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        let partitionKeyValue = AWSIdentityManager.default().identityId!
        let sortKeyValue = "demo-conversationId-500000"
        let filterValue = "demo-createdAt-500000"
        return "Find all items with userId = \(partitionKeyValue), conversationId < \(sortKeyValue), and createdAt > \(filterValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        
        queryExpression.keyConditionExpression = "#userId = :userId AND #conversationId < :conversationId"
        queryExpression.filterExpression = "#createdAt > :createdAt"
        queryExpression.expressionAttributeNames = [
            "#userId": "userId",
            "#conversationId": "conversationId",
            "#createdAt": "createdAt",
        ]
        queryExpression.expressionAttributeValues = [
            ":userId": AWSIdentityManager.default().identityId!,
            ":conversationId": "demo-conversationId-500000",
            ":createdAt": "demo-createdAt-500000",
        ]
        

        objectMapper.query(Conversation.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
}

class ConversationByCreationDate: NSObject, Index {
    
    var indexName: String? {

        return "ByCreationDate"
    }
    
    func supportedOperations() -> [String] {
        return [
            QueryWithPartitionKey,
            QueryWithPartitionKeyAndFilter,
            QueryWithPartitionKeyAndSortKey,
            QueryWithPartitionKeyAndSortKeyAndFilter,
        ]
    }
    
    func queryWithPartitionKeyDescription() -> String {
        let partitionKeyValue = "demo-chatRoomId-3"
        return "Find all items with chatRoomId = \(partitionKeyValue)."
    }
    
    func queryWithPartitionKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "ByCreationDate"
        queryExpression.keyConditionExpression = "#chatRoomId = :chatRoomId"
        queryExpression.expressionAttributeNames = ["#chatRoomId": "chatRoomId",]
        queryExpression.expressionAttributeValues = [":chatRoomId": "demo-chatRoomId-3",]

        objectMapper.query(Conversation.self, expression: queryExpression) { (response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        }
    }
    
    func queryWithPartitionKeyAndFilterDescription() -> String {
        let partitionKeyValue = "demo-chatRoomId-3"
        let filterAttributeValue = "demo-conversationId-500000"
        return "Find all items with chatRoomId = \(partitionKeyValue) and conversationId > \(filterAttributeValue)."
    }
    
    func queryWithPartitionKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "ByCreationDate"
        queryExpression.keyConditionExpression = "#chatRoomId = :chatRoomId"
        queryExpression.filterExpression = "#conversationId > :conversationId"
        queryExpression.expressionAttributeNames = [
            "#chatRoomId": "chatRoomId",
            "#conversationId": "conversationId",
        ]
        queryExpression.expressionAttributeValues = [
            ":chatRoomId": "demo-chatRoomId-3",
            ":conversationId": "demo-conversationId-500000",
        ]
        

        objectMapper.query(Conversation.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyDescription() -> String {
        let partitionKeyValue = "demo-chatRoomId-3"
        let sortKeyValue = "demo-createdAt-500000"
        return "Find all items with chatRoomId = \(partitionKeyValue) and createdAt < \(sortKeyValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "ByCreationDate"
        queryExpression.keyConditionExpression = "#chatRoomId = :chatRoomId AND #createdAt < :createdAt"
        queryExpression.expressionAttributeNames = [
            "#chatRoomId": "chatRoomId",
            "#createdAt": "createdAt",
        ]
        queryExpression.expressionAttributeValues = [
            ":chatRoomId": "demo-chatRoomId-3",
            ":createdAt": "demo-createdAt-500000",
        ]
        

        objectMapper.query(Conversation.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) -> Void in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterDescription() -> String {
        let partitionKeyValue = "demo-chatRoomId-3"
        let sortKeyValue = "demo-createdAt-500000"
        let filterValue = "demo-conversationId-500000"
        return "Find all items with chatRoomId = \(partitionKeyValue), createdAt < \(sortKeyValue), and conversationId > \(filterValue)."
    }
    
    func queryWithPartitionKeyAndSortKeyAndFilterWithCompletionHandler(_ completionHandler: @escaping (_ response: AWSDynamoDBPaginatedOutput?, _ error: NSError?) -> Void) {
        let objectMapper = AWSDynamoDBObjectMapper.default()
        let queryExpression = AWSDynamoDBQueryExpression()
        

        queryExpression.indexName = "ByCreationDate"
        queryExpression.keyConditionExpression = "#chatRoomId = :chatRoomId AND #createdAt < :createdAt"
        queryExpression.filterExpression = "#conversationId > :conversationId"
        queryExpression.expressionAttributeNames = [
            "#chatRoomId": "chatRoomId",
            "#createdAt": "createdAt",
            "#conversationId": "conversationId",
        ]
        queryExpression.expressionAttributeValues = [
            ":chatRoomId": "demo-chatRoomId-3",
            ":createdAt": "demo-createdAt-500000",
            ":conversationId": "demo-conversationId-500000",
        ]
        

        objectMapper.query(Conversation.self, expression: queryExpression, completionHandler: {(response: AWSDynamoDBPaginatedOutput?, error: Error?) in
            DispatchQueue.main.async(execute: {
                completionHandler(response, error as? NSError)
            })
        })
    }
}
