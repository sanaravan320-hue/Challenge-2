//
//  ContentView.swift
//  Challenge 2
//
//  Created by Sana Ravan on 11/11/25.
//

import SwiftUI
import PhotosUI // (Import for saving to photos)

// Define Tool
enum Tool {
    case brush
    case smudge
    case eraser
}

// Define a data structure for a single line

struct Line {
    var points: [CGPoint] = []
    var color: Color = .black
    var lineWidth: Double = 1.0 // This is BRUSH SIZE
    var opacity: Double = 1.0   // This is BRUSH OPACITY
    var tool: Tool = .brush
}

struct ContentView: View {
    
    // State Variables
    @State private var brushSize: Int = 40
    @State private var brushOpacity: Int = 87
    @State private var selectedTool: Tool = .brush
    @State private var selectedColor: Color = .black
    
    // Drawing State
    @State private var lines: [Line] = []
    @State private var undoneLines: [Line] = []
    @State private var currentLine = Line()
    @State private var showSavedAlert = false
    
    // CANVAS RENDERER
    @State private var canvasRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            
            // App background
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .edgesIgnoringSafeArea(.all)

            //THE CANVAS
            GeometryReader { geometry in
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        
                        let drawColor = (line.tool == .eraser) ? Color.white : line.color
                        
                        context.stroke(path,
                                       with: .color(drawColor.opacity(line.opacity)), // Use line's saved opacity
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                    
                    var path = Path()
                    path.addLines(currentLine.points)
                    let currentDrawColor = (selectedTool == .eraser) ? Color.white : selectedColor
                    let currentOpacity = (selectedTool == .smudge) ? 0.1 : (Double(brushOpacity) / 100.0)
                    
                    context.stroke(path,
                                   with: .color(currentDrawColor.opacity(currentOpacity)),
                                   style: StrokeStyle(lineWidth: Double(brushSize), lineCap: .round, lineJoin: .round))
                    
                }
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged({ value in
                            let newPoint = value.location
                            
                            currentLine.tool = selectedTool
                            currentLine.lineWidth = Double(brushSize)
                            currentLine.opacity = (selectedTool == .smudge) ? 0.1 : (Double(brushOpacity) / 100.0)
                            currentLine.color = selectedColor
                            currentLine.points.append(newPoint)
                            
                            undoneLines.removeAll()
                        })
                        .onEnded({ value in
                            lines.append(currentLine)
                            currentLine = Line()
                        })
                )
              
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: CanvasRectKey.self, value: geo.frame(in: .global))
                    }
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white) // The white paper
            .cornerRadius(20)
            .padding(60)
            // This detects the canvasRect changing
            .onPreferenceChange(CanvasRectKey.self) { rect in
                self.canvasRect = rect
            }
            
            
            //THE UI LAYER
            VStack(spacing: 0) {
                HStack {
                    TopLeftPillView(saveAction: saveCanvasAsImage)
                    
                    Spacer()
                    
                    TopRightPillView(selectedTool: $selectedTool, selectedColor: $selectedColor)
                    
                } // End of top HStack
                Spacer()
            } // End of main VStack
            .padding()
            
            HStack {
                
                LeftSidebarView(
                    brushSize: $brushSize,
                    brushOpacity: $brushOpacity,
                    lines: $lines,
                    undoneLines: $undoneLines,
                    selectedColor: $selectedColor
                )
                
                Spacer()
            }
            .padding()

        } // End of ZStack
        // 
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your drawing has been saved to your Photo Library.")
        }
    }
    
    // NEW SAVE FUNCTION
    @MainActor
    func saveCanvasAsImage() {
        let renderer = ImageRenderer(
            content:
                Canvas { context, size in
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        let drawColor = (line.tool == .eraser) ? Color.white : line.color
                        context.stroke(path,
                                       with: .color(drawColor.opacity(line.opacity)),
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                }
                .frame(width: canvasRect.width - 1, height: canvasRect.height - 1) // Match the frame
                .background(Color.white) // Ensure the saved image has a white background
        )
        
        // Generate the UIImage from the snapshot
        if let image = renderer.uiImage {
            // Use the PhotosUI framework to save it
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
                if status == .authorized {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    // Show the success alert
                    showSavedAlert = true
                } else {
                    // Handle error: user denied permission
                    print("User denied photo library access")
                }
            }
        }
    }
}

// A PreferenceKey to get the size/position of the canvas
struct CanvasRectKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPad (10th generation)")
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
