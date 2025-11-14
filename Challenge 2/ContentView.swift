//
//  ContentView.swift
//  Challenge 2
//
//  Created by Sana Ravan on 11/11/25.
//

import SwiftUI

// --- 1. Define our Tool ---
enum Tool {
    case brush
    case smudge
    case eraser
}

// --- 2. Define a data structure for a single line ---
struct Line {
    var points: [CGPoint] = []
    var color: Color = .black // This will now be set by selectedColor
    var lineWidth: Double = 1.0
    var tool: Tool = .brush
}

struct ContentView: View {
    
    // --- 3. State Variables ---
    @State private var brushSize: Int = 40
    @State private var brushOpacity: Int = 87
    @State private var selectedTool: Tool = .brush
    
    // --- THIS IS THE NEW VARIABLE ---
    @State private var selectedColor: Color = .black // The default color is black
    
    // --- 4. Drawing State ---
    @State private var lines: [Line] = []
    @State private var undoneLines: [Line] = []
    @State private var currentLine = Line()
    
    var body: some View {
        ZStack {
            
            // App background
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .edgesIgnoringSafeArea(.all)

            // --- 5. THE UPDATED CANVAS ---
            Canvas { context, size in
                for line in lines {
                    var path = Path()
                    path.addLines(line.points)
                    
                    // --- Eraser logic is still here ---
                    let drawColor = (line.tool == .eraser) ? Color.white : line.color
                    
                    context.stroke(path,
                                   with: .color(drawColor.opacity(line.lineWidth / 100.0)), // Use line's saved opacity
                                   style: StrokeStyle(lineWidth: Double(line.lineWidth), lineCap: .round, lineJoin: .round))
                }
                
                // This draws the line we are currently drawing
                var path = Path()
                path.addLines(currentLine.points)
                
                // --- Use the main state variables for the current line ---
                let currentDrawColor = (selectedTool == .eraser) ? Color.white : selectedColor
                
                context.stroke(path,
                               with: .color(currentDrawColor.opacity(Double(brushOpacity) / 100.0)),
                               style: StrokeStyle(lineWidth: Double(brushSize), lineCap: .round, lineJoin: .round))
                
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged({ value in
                        let newPoint = value.location
                        
                        // --- Set properties for the new line ---
                        currentLine.tool = selectedTool
                        currentLine.lineWidth = Double(brushOpacity) // <-- FIX: Link to opacity
                        currentLine.color = selectedColor // <-- FIX: Use the selected color
                        currentLine.points.append(newPoint)
                        
                        undoneLines.removeAll()
                    })
                    .onEnded({ value in
                        // --- Store the final line width ---
                        // We store brushSize, not brushOpacity, for the line's width
                        currentLine.lineWidth = Double(brushSize)
                        lines.append(currentLine)
                        currentLine = Line()
                    })
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white) // The white paper
            .cornerRadius(20)
            .padding(60)
            
            // --- 6. THE UI LAYER ---
            VStack(spacing: 0) {
                HStack {
                    TopLeftPillView()
                    Spacer()
                    
                    // --- PASS THE NEW COLOR BINDING ---
                    TopRightPillView(selectedTool: $selectedTool, selectedColor: $selectedColor)
                    
                } // End of top HStack
                Spacer()
            } // End of main VStack
            .padding()
            
            HStack {
                // --- PASS THE LINE BINDINGS ---
                LeftSidebarView(
                    brushSize: $brushSize,
                    brushOpacity: $brushOpacity,
                    lines: $lines,
                    undoneLines: $undoneLines
                )
                
                Spacer()
            }
            .padding()

        } // End of ZStack
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
