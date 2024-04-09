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
      dfs(start: props)
    }
  }

  override func render() -> AnyView {
    AnyView(SNTextView(props: self.props))
  }

}

// Call for node without text parent and with children
func dfs(start: SolidNativeProps) -> Text {
  // print("RUN!")
  // If theres children, essentially we want the text of those children.

  // If no children, we return

  let childrenCount = start.getChildren().count

  if childrenCount == 0 {
    return processTextView(start)
  }

  var txt = dfs(start: start.children[0].props)

  for i in 0...(childrenCount - 1) {
    if i == 0 {
      continue
    }

    let child = start.children[i]

    // Get other children and do the same
    let newText = dfs(start: child.props)

    txt = txt + newText

  }

  return styleTextViewFromSNView(props: start, text: txt)
}

// Convert view with no children to text
func processTextView(_ props: SolidNativeProps) -> Text {
  return Text(props.getString(name: "text"))
}

func styleTextViewFromSNView(props: SolidNativeProps, text: Text) -> Text {
  var styledText = text

  let fontWeight = props.getString(name: "fontWeight", default: "regular")
  let color = props.getString(name: "color")

  if color != "" {
    styledText = styledText.foregroundColor(Color(hex: color))
  }

  let fontWieght = SwiftUIFontWeight(from: fontWeight)

  // Text Decoration (Underline, Strikethrough)
  let textDecorationLine = props.getString(name: "textDecorationLine")

  if textDecorationLine != "" {
    styledText = applyTextDecoration(text: styledText, decoration: textDecorationLine)
  }

  let fontSize = props.getNumber(name: "fontSize", default: 17.0)

  styledText = styledText.font(.system(size: CGFloat(truncating: fontSize), weight: fontWieght))

  return styledText
}

// Helper functions and extensions to support the additional properties

func applyTextDecoration(text: Text, decoration: String) -> Text {
  var newText = text
  switch decoration {
  case "underline":
    newText = newText.underline()
  case "line-through":
    newText = newText.strikethrough()
  default:
    break
  }
  return newText
}

// Additional extensions for fontWeight, fontStyle, etc., can be modeled similar to the UIColor extension provided previously.

func SwiftUIFontWeight(from weight: String) -> Font.Weight {
  switch weight {
  case "bold": return .bold
  case "medium": return .medium
  case "light": return .light
  default: return .regular
  }
}

extension Color {
  init(hex string: String) {
    var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    if string.hasPrefix("#") {
      _ = string.removeFirst()
    }

    // Double the last value if incomplete hex
    if !string.count.isMultiple(of: 2), let last = string.last {
      string.append(last)
    }

    // Fix invalid values
    if string.count > 8 {
      string = String(string.prefix(8))
    }

    // Scanner creation
    let scanner = Scanner(string: string)

    var color: UInt64 = 0
    scanner.scanHexInt64(&color)

    if string.count == 2 {
      let mask = 0xFF

      let g = Int(color) & mask

      let gray = Double(g) / 255.0

      self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)

    } else if string.count == 4 {
      let mask = 0x00FF

      let g = Int(color >> 8) & mask
      let a = Int(color) & mask

      let gray = Double(g) / 255.0
      let alpha = Double(a) / 255.0

      self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)

    } else if string.count == 6 {
      let mask = 0x0000FF
      let r = Int(color >> 16) & mask
      let g = Int(color >> 8) & mask
      let b = Int(color) & mask

      let red = Double(r) / 255.0
      let green = Double(g) / 255.0
      let blue = Double(b) / 255.0

      self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)

    } else if string.count == 8 {
      let mask = 0x0000_00FF
      let r = Int(color >> 24) & mask
      let g = Int(color >> 16) & mask
      let b = Int(color >> 8) & mask
      let a = Int(color) & mask

      let red = Double(r) / 255.0
      let green = Double(g) / 255.0
      let blue = Double(b) / 255.0
      let alpha = Double(a) / 255.0

      self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)

    } else {
      self.init(.sRGB, red: 1, green: 1, blue: 1, opacity: 1)
    }
  }
}
