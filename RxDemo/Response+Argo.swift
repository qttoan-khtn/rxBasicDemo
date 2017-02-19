//
//  Response+Argo.swift
//  Wrapper
//
//  Created by Imac on 1/25/17.
//  Copyright © 2017 iOS_Devs. All rights reserved.
//

//
//  Response+Argo.swift
//  Pods
//
//  Created by Sam Watts on 23/01/2016.
//
//
import Foundation
import Moya
import Argo

/// Extension on Moya response to map to an object(s) decodable with Argo
public extension Response {
  
  /**
   Maps Moya response to decodable type
   
   - parameter rootKey: Optional root key of JSON to begin mapping
   
   - throws: Throws errors from either mapping to JSON, or Argo decoding
   
   - returns: returns a decoded object
   */
  public func mapObject<T:Decodable>(rootKey: String? = nil) throws -> T where T == T.DecodedType {
    
    do {
      //map to JSON (even if it's wrapped it's still a dict)
      let JSON = try self.mapJSON() as? [String: AnyObject] ?? [:]
      
      //decode with Argo
      let decodedObject:Decoded<T>
      if let rootKey = rootKey {
        decodedObject = decode(JSON, rootKey: rootKey)
      } else {
        decodedObject = decode(JSON)
      }
      
      //return decoded value, or throw decoding error
      return try decodedValue(decoded: decodedObject)
      
    } catch {
      
      throw error
    }
  }
  
  /// Convenience method for mapping an object with a root key
  public func mapObjectWithRootKey<T:Decodable>(rootKey: String) throws -> T where T == T.DecodedType {
    
    return try mapObject(rootKey: rootKey)
  }
  
  /**
   Maps Moya response to an array of decodable type
   
   - parameter rootKey: Optional root key of JSON to begin mapping
   
   - throws: Throws errors from either mapping to JSON, or Argo decoding
   
   - returns: returns an array of decoded object
   */
  public func mapArray<T:Decodable>(rootKey: String? = nil) throws -> [T] where T == T.DecodedType {
    
    do {
      //map to JSON
      let JSON = try self.mapJSON()
      
      //decode with Argo
      let decodedArray:Decoded<[T]>
      if let rootKey = rootKey {
        //we have a root key, so we're dealing with a dict
        let dict = JSON as? [String: AnyObject] ?? [:]
        decodedArray = decode(dict, rootKey: rootKey)
      } else {
        //no root key, it's an array
        guard let array = JSON as? [AnyObject] else {
          throw DecodeError.typeMismatch(expected: "\(T.DecodedType.self)", actual: "\(type(of: JSON))")
        }
        decodedArray = decode(array)
      }
      
      //return array of decoded objects, or throw decoding error
      return try decodedValue(decoded: decodedArray)
      
    } catch {
      
      throw error
    }
  }
  
  /// Convenience method for mapping an array with a root key
  public func mapArrayWithRootKey<T:Decodable>(rootKey: String) throws -> [T] where T == T.DecodedType {
    
    return try mapArray(rootKey: rootKey)
  }
  
  /**
   Helper function which takes a decoded value and returns a value, or throws an error
   
   - parameter decoded: result of Argo decoding
   
   - throws: throws Argo error from decoding process
   
   - returns: returns the decoded value if decoding was successful
   */
  private func decodedValue<T>(decoded: Decoded<T>) throws -> T {
    
    switch decoded {
    case .success(let value):
      return value
    case .failure(let error):
      throw error
    }
  }
}


//import Foundation
//import Moya
//import Argo
//
//public extension Response {
//
//  public func mapObject<T: Decodable>() throws -> T where T == T.DecodedType {
//    guard let jsonDictionary = try mapJSON() as? NSDictionary, let object: T = decode(jsonDictionary) else {
//      throw MoyaError.jsonMapping(self)
//    }
//
//    return object
//  }
//
//  public func mapObject<T: Decodable>(withKeyPath keyPath: String?) throws -> T where T == T.DecodedType {
//    guard let keyPath = keyPath else { return try mapObject() }
//    
//    guard let jsonDictionary = try mapJSON() as? NSDictionary,
//      let objectDictionary = jsonDictionary.value(forKeyPath: keyPath) as? NSDictionary,
//      let object: T = decode(objectDictionary) else {
//        throw MoyaError.jsonMapping(self)
//    }
//    
//    return object
//  }
//  
//  public func mapArray<T: Decodable>() throws -> [T] where T == T.DecodedType {
//    guard let jsonArray = try mapJSON() as? NSArray, let object: [T] = decode(jsonArray) else {
//      throw MoyaError.jsonMapping(self)
//    }
//    
//    return object
//  }
//  
//  public func mapArray<T: Decodable>(withKeyPath keyPath: String?) throws -> [T] where T == T.DecodedType {
//    guard let keyPath = keyPath else { return try mapArray() }
//    
//    guard let jsonDictionary = try mapJSON() as? NSDictionary,
//      let objectArray = jsonDictionary.value(forKeyPath:keyPath) as? NSArray,
//      let object: [T] = decode(objectArray) else {
//        throw MoyaError.jsonMapping(self)
//    }
//    
//    return object
//  }
//}
