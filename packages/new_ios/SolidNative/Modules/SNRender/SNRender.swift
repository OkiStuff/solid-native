//
//  SNRender.swift
//  SolidNative
//
//  Created by Imran Shitta-Bey on 1/18/24.
//

import Foundation
import JavaScriptCore
/**
 Acts as renderer.
 */
class SNRender: SolidNativeModule {
    class override var name: String {
        "SNRender"
    }
    
    private let viewManager = ViewManager()
    
    private let rootView = SolidNativeCore.shared.rootElement
    
    required init() {
        let _ = viewManager.addViewToRegistry(view: rootView)
        
        // TODO: This needs to be dynamic! Since other code needs to be able to access it.
        // TODO: OR, maybe just have some shared module. Or this could just be autogenerated.
        viewManager.registerElement(SNTextView.self);
        viewManager.registerElement(SNView.self);
        viewManager.registerElement(SNButtonView.self);
        
    }
    
    override func getJSValueRepresentation() -> JSValue {
        let builder = JSValueBuilder()
        
        builder.addSyncFunction("print") { (_ str: String) in
            print(str)
        }
        
        builder.addSyncFunction("getRootView") { 
            return self.rootView.id.uuidString
        }
        
        builder.addSyncFunction("getFirstChild") { (_ id: String) in
            let view = self.viewManager.getViewById(id)
            return view.firstChild?.id.uuidString
        }
        
        builder.addSyncFunction("getParent") { (_ id: String) in
            let view = self.viewManager.getViewById(id)
            return view.parentElement?.id.uuidString
        }
        
        builder.addSyncFunction("setProp") { (_ id: JSValue, name: JSValue, value: JSValue) in
            let view = self.viewManager.getViewById(id.toString()!)
            if value.isNull || value.isUndefined {
                view.setProp(name.toString()!, nil)
            } else {
                view.setProp(name.toString()!, value)
            }
            
        }
        
        builder.addSyncFunction("isTextElement") { (_ id: String) in
            let view = self.viewManager.getViewById(id)
            return view.isTextElement
        }
        
        builder.addSyncFunction("removeChild") { (_ id: String, childId: String) in
            let view = self.viewManager.getViewById(id)
            let viewChild = self.viewManager.getViewById(childId)
            view.removeChild(viewChild)
        }
        
        builder.addSyncFunction("insertBefore") { (_ id: JSValue, elementId: JSValue, anchorId: JSValue) in
            let view = self.viewManager.getViewById(id.toString()!)
            let element = self.viewManager.getViewById(elementId.toString()!)
            
            if anchorId.isString {
                let anchor = self.viewManager.getViewById(anchorId.toString()!)
                return view.insertBefore(element, anchor)
            }
            
            return view.insertBefore(element, nil);
        }
        
        builder.addSyncFunction("next") { (_ id: String) in
            let view = self.viewManager.getViewById(id)
            return view.next?.id.uuidString
        }
        
        builder.addSyncFunction("prev") { (_ id: String) in
            let view = self.viewManager.getViewById(id)
            return view.prev?.id.uuidString
        }
        
        builder.addSyncFunction("createNodeByName") { (_ name: String) in
            let viewId = self.viewManager.createViewByName(name);
            return viewId
        }
        
        
        return builder.value
    }
}


// Need some way to build function.
private class ViewManager {
    private var viewRegistry: [String : SolidNativeView.Type] = [:]
    private var createdViewRegistry: [String: SolidNativeView] = [:]
    
    fileprivate func addViewToRegistry(view: SolidNativeView) -> String {
        let id = view.id.uuidString
        createdViewRegistry[id] = view
        return id
    }

    // Only thing it needs is the View type, the View Name, whether or not it a text view
    func registerElement(_ viewType: SolidNativeView.Type) {
        viewRegistry[viewType.name] = viewType.self
    }
    /**
     @returns view id
     */
    func createViewByName(_ name: String) -> String {
        if let viewType = viewRegistry[name] {
            let newView = viewType.init()
            return addViewToRegistry(view: newView)
        }
        assertionFailure("\(name) is not in element registry!")
        return ""
    }
    
    func getViewById(_ id: String) -> SolidNativeView {
        if let view = createdViewRegistry[id] {
            return view
        }
        assertionFailure("view with id \(id) is not in element registry!")
        return SolidNativeView()
    }
    
}
