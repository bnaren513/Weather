//
//  CoreDataProvider.swift
//  WeatherSample
//
//  Created by Narendra Biswa on 17/06/21.
//

import UIKit
import CoreData

class CoredataProvider: NSObject {
    
    override init() {
        
    }

    func createData(data:WeatherObject)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Weathers", in: context)
        let exist = isExist(name: data.name ?? "")
        if exist == false && data.name?.isEmptyString == false
        {
            let newUser = NSManagedObject(entity: entity!, insertInto: context)
            newUser.setValue(data.name, forKey: "name")
            newUser.setValue(data.weather?.description_str, forKey: "description_Str")
            newUser.setValue(data.main?.feels_like, forKey: "feels_like")
            newUser.setValue(data.main?.humidity, forKey: "humidity")
            newUser.setValue(data.main?.temp, forKey: "temp")
            newUser.setValue(data.coord?.lat, forKey: "lat")
            newUser.setValue(data.coord?.lon, forKey: "lon")
            newUser.setValue(data.wind?.speed, forKey: "speed")
            newUser.setValue(data.sys?.sunset, forKey: "sunset")
            newUser.setValue(data.sys?.sunrise, forKey: "sunrise")
            newUser.setValue(data.visibility, forKey: "visibility")
            
            do {
               try context.save()
                print("success")
              } catch {
               print("Failed saving")
            }
        }
    }
    
    func isExist(name: String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Weathers")
        fetchRequest.predicate = NSPredicate(format: "name CONTAINS[c] %@",name)
        let res = try! context.fetch(fetchRequest)
        return res.count > 0 ? true : false
    }

    func fetchrequest(completion: @escaping ([NSManagedObject]?) -> Void)
    {
        var data = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Weathers")
        
        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        do {
            guard let result = try context.fetch(fetchRequest) as? [NSManagedObject] else { return }
            data.append(contentsOf: result)
            completion(data)
            
        } catch _ as NSError {
            completion(nil)
        }
    }
    func deleteAllData(_ entity:String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        do {
            let context = appDelegate.persistentContainer.viewContext
            let results = try context.fetch(fetchRequest)
            for object in results {
                guard let objectData = object as? NSManagedObject else {continue}
                context.delete(objectData)
            }
        } catch let error {
            print("Detele all data in \(entity) error :", error)
        }
    }
    
}

