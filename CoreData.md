Entity

```swift
extension NSPersistentContainer {
    var productEntityName: String {
        "ProductEntity"
    }
    
    var productCategoryEntityName: String {
        "ProductCategoryEntity"
    }
}
```

Base View Model
```swift
class BaseVM: NSObject {
    var container: NSPersistentContainer {
        let _container = NSPersistentContainer(name: "ShoppiModel")
        _container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load quiz stores: \(error)")
            }
        }
        
        return _container
    }
}
```


```swift
import CoreData

extension NSPersistentContainer {    
    private var productEntityDesc: NSEntityDescription? {
        NSEntityDescription.entity(forEntityName: "ProductEntity", in: viewContext)
    }
    
    var products: [Product] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: productEntityName)
        request.returnsObjectsAsFaults = false
        
        var products = [Product]()
        
        do {
            let result = try viewContext.fetch(request)
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "id") as! String
                let name = data.value(forKey: "name") as! String
                let category = data.value(forKey: "category") as! String
                let count = data.value(forKey: "count") as! Int
                
                let product = Product(id: id, name: name, category: category, count: count)
                products.append(product)
            }
        } catch {
            print("Failed")
        }
        
        return products
    }
    
    func addProduct(_ product: Product) {
        let productObject = NSManagedObject(entity: productEntityDesc!, insertInto: viewContext)
        productObject.setValue(product.id, forKey: "id")
        productObject.setValue(product.name, forKey: "name")
        productObject.setValue(product.category, forKey: "category")
        productObject.setValue(product.count, forKey: "count")
        
        do {
            try viewContext.save()
        } catch {
           print("Failed saving")
        }
    }
    
    func deleteProduct(_ product: Product) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: productEntityName)
        let predicate = NSPredicate(format: "id = %@", product.id)
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try viewContext.fetch(request)
            for object in result as! [NSManagedObject] {
                viewContext.delete(object)
                try viewContext.save()
            }
        } catch {
            print("Delete Failed.")
        }
        
    }
}
```
