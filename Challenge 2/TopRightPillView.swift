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
            
            // --- 2. THIS IS THE NEW COLOR PICKER ---
            ColorPicker("", selection: $selectedColor) // The "" label makes it icon-only
                .labelsHidden() // Hides the label
                .frame(width: 50, height: 44)
                .padding(.horizontal, 4) // Give it a little space inside the pill

        } // End of HStack
        .padding(.leading, 6) // Add padding to the start
        // We remove .padding(.horizontal) to let the ColorPicker's padding work
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

// --- This Preview is for this file ONLY ---
struct TopRightPillView_Previews: PreviewProvider {
    static var previews: some View {
        // We must add the new binding to the preview
        TopRightPillView(
            selectedTool: .constant(.brush),
            selectedColor: .constant(.black)
        )
        .background(Color.gray)
    }
}
