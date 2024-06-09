//
//  SNTextView.swift
//  solid_native_ios_playground
//
//  Created by Imran Shitta-Bey on 6/12/23.
//

import Foundation
import SwiftUI
import YogaSwiftUI

class SNView: SolidNativeView {
    
    class override var name: String {
        "sn_view"
    }

    struct _SNView: View {
        @ObservedObject var props: SolidNativeProps
        
        var body: some View {
            Flex(direction: .column) {
                let children = props.getChildren()
                ForEach(children, id: \.id) { child in
                    child.render()
                }
            }

        }
    }
    
    override func render() -> AnyView {
        return AnyView(_SNView(props: self.props))
    }
    
}
