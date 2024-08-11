//
//  ContentView.swift
//  RGB-HEX Converter
//
//  Created by Süleyman Ayyılmaz on 11.08.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var red: String = ""
    @State private var green: String = ""
    @State private var blue: String = ""
    @State private var hex: String = ""
    @State private var selectedConversion: Int = 0
    
    private var color: Color {
        if let r = UInt8(red), let g = UInt8(green), let b = UInt8(blue) {
            return Color(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0)
        }
        return Color.white
    }
    
    private var result: String {
        if selectedConversion == 0 {
            return rgbToHex()
        } else {
            return hexToRgb()
        }
    }
    
    private func rgbToHex() -> String {
        guard let r = UInt8(red), let g = UInt8(green), let b = UInt8(blue) else {
            return "Invalid RGB input"
        }
        return String(format: "Hex Color: #%02X%02X%02X", r, g, b)
    }
    
    private func hexToRgb() -> String {
        guard !hex.isEmpty, hex.hasPrefix("#"), hex.count == 7 else {
            return "Invalid HEX input"
        }
        let hexString = String(hex.dropFirst())
        var rgb: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        let r = UInt8((rgb >> 16) & 0xFF)
        let g = UInt8((rgb >> 8) & 0xFF)
        let b = UInt8(rgb & 0xFF)
        return "RGB Color: \(r), \(g), \(b)"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            // Title
            Text("RGB <-> HEX Color Converter")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding()
            
            // Segmented Picker
            Picker("Conversion Type", selection: $selectedConversion) {
                Text("RGB to HEX").tag(0)
                Text("HEX to RGB").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            if selectedConversion == 0 {
                VStack(spacing: 15) {
                    TextField("Red (0-255)", text: $red)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                    
                    TextField("Green (0-255)", text: $green)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                    
                    TextField("Blue (0-255)", text: $blue)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .padding()
                }
                .background(Color(.systemGray6).cornerRadius(10).shadow(radius: 5))
            } else {
                TextField("HEX Color (#RRGGBB)", text: $hex)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .background(Color(.systemGray6).cornerRadius(10).shadow(radius: 5))
            }
            
            Text(result)
                .font(.headline)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
                .padding()
            
            Rectangle()
                .fill(color)
                .frame(width: 150, height: 150)
                .cornerRadius(10)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 1))
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground).edgesIgnoringSafeArea(.all))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

