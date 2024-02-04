//
//  SNTextView.swift
//  solid_native_ios_playground
//
//  Created by Imran Shitta-Bey on 6/12/23.
//

import Foundation
import SwiftUI

class SNTextView: SolidNativeView {
    
    class override var name: String {
        "sn_text"
    }
    
    override var isTextElement: Bool {
        true
    }
    
    struct SNTextView: View {
        
        @ObservedObject var props: SolidNativeProps
        
        var body: some View {
            let text = props.getString(name: "text")
            Text(text)
        }
    }
    
    override func render() -> AnyView
    {
        AnyView(SNTextView(props: self.props))
    }
    
}
