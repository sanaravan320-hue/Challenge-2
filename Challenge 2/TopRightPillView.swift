//
//  TopRightPillView.swift
//  Challenge 2
//
//  Created by Sana Ravan on 12/11/25.
//

import SwiftUI

struct TopRightPillView: View {
    // 1. Bindings from ContentView
    @Binding var selectedTool: Tool
    @Binding var selectedColor: Color // <-- NEW BINDING
    
    var body: some View {
        HStack(spacing: 0) {
            
            // Brush Button
            Button(action: {
                selectedTool = .brush
                print("Brush tapped")
            }) {
                Image(systemName: "paintbrush.pointed")
                    .font(.system(size: 20))
                    .frame(width: 50, height: 44)
                    .foregroundColor(selectedTool == .brush ? Color.blue : Color.white)
            }
            
            // Smudge Button
            Button(action: {
                selectedTool = .smudge
                print("Smudge tapped")
            }) {
                Image(systemName: "hand.draw")
                    .font(.system(size: 20))
                    .frame(width: 50, height: 44)
                    .foregroundColor(selectedTool == .smudge ? Color.blue : Color.white)
            }
            
            // Eraser Button
            Button(action: {
                selectedTool = .eraser
                print("Erase tapped")
            }) {
                Image(systemName: "eraser")
                    .font(.system(size: 20))
                    .frame(width: 50, height: 44)
                    .foregroundColor(selectedTool == .eraser ? Color.blue : Color.white)
            }
            
            // Layers Button
            Button(action: {
                print("Layers tapped")
            }) {
                Image(systemName: "square.stack.3d.down.right")
                    .font(.system(size: 20))
                    .frame(width: 50, height: 44)
                    .foregroundColor(.white)
            }
            
            ColorPicker("", selection: $selectedColor)
                .labelsHidden() // Hides the label
                .frame(width: 50, height: 44)
                .padding(.horizontal, 4)

        } // End of HStack
        .padding(.leading, 6)
        
        .background(
            .ultraThinMaterial.opacity(0.8)
        )
        .cornerRadius(22)
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: selectedTool)
    }
}

struct TopRightPillView_Previews: PreviewProvider {
    static var previews: some View {
        TopRightPillView(
            selectedTool: .constant(.brush),
            selectedColor: .constant(.black)
        )
        .background(Color.gray)
    }
}
