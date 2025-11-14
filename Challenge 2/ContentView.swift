//
//  ContentView.swift
//  Challenge 2
//
//  Created by Sana Ravan on 11/11/25.
//

import SwiftUI
import PhotosUI // <-- 1. IMPORT FOR SAVING TO PHOTOS

// --- 1. Define our Tool ---
enum Tool {
    case brush
    case smudge
    case eraser
}

// --- 2. Define a data structure for a single line ---
// (We've added 'opacity' to fix the smudge/opacity bug)
struct Line {
    var points: [CGPoint] = []
    var color: Color = .black
    var lineWidth: Double = 1.0 // This is BRUSH SIZE
    var opacity: Double = 1.0   // This is BRUSH OPACITY
    var tool: Tool = .brush
}

struct ContentView: View {
    
    // --- 3. State Variables ---
    @State private var brushSize: Int = 40
    @State private var brushOpacity: Int = 87
    @State private var selectedTool: Tool = .brush
    @State private var selectedColor: Color = .black
    
    // --- 4. Drawing State ---
    @State private var lines: [Line] = []
    @State private var undoneLines: [Line] = []
    @State private var currentLine = Line()
    
    // --- 5. NEW STATE FOR SAVE ALERT ---
    @State private var showSavedAlert = false
    
    // --- 6. CANVAS RENDERER ---
    // This allows us to snapshot the canvas for saving
    @State private var canvasRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            
            // App background
            Color(red: 0.2, green: 0.2, blue: 0.2)
                .edgesIgnoringSafeArea(.all)

            // --- 7. THE CANVAS ---
            // We wrap the Canvas in a GeometryReader to find its size
            GeometryReader { geometry in
                Canvas { context, size in
                    // Draw all the finished lines
                    for line in lines {
                        var path = Path()
                        path.addLines(line.points)
                        
                        let drawColor = (line.tool == .eraser) ? Color.white : line.color
                        
                        context.stroke(path,
                                       with: .color(drawColor.opacity(line.opacity)), // Use line's saved opacity
                                       style: StrokeStyle(lineWidth: line.lineWidth, lineCap: .round, lineJoin: .round))
                    }
                    
                    // This draws the line we are currently drawing
                    var path = Path()
                    path.addLines(currentLine.points)
                    
                    // --- Use the main state variables for the current line ---
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
                            
                            // --- Set properties for the new line ---
                            currentLine.tool = selectedTool
                            currentLine.lineWidth = Double(brushSize) // Corrected
                            currentLine.opacity = (selectedTool == .smudge) ? 0.1 : (Double(brushOpacity) / 100.0) // Corrected
                            currentLine.color = selectedColor
                            currentLine.points.append(newPoint)
                            
                            undoneLines.removeAll()
                        })
                        .onEnded({ value in
                            lines.append(currentLine)
                            currentLine = Line()
                        })
                )
                // This preference key stores the canvas's size and position
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
            
            
            // --- 8. THE UI LAYER ---
            VStack(spacing: 0) {
                HStack {
                    // --- PASS THE NEW SAVE ACTION ---
                    TopLeftPillView(saveAction: saveCanvasAsImage)
                    
                    Spacer()
                    
                    TopRightPillView(selectedTool: $selectedTool, selectedColor: $selectedColor)
                    
                } // End of top HStack
                Spacer()
            } // End of main VStack
            .padding()
            
            HStack {
                // --- PASS ALL BINDINGS ---
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
        // --- 9. "SAVED!" ALERT ---
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Your drawing has been saved to your Photo Library.")
        }
    }
    
    // --- 10. NEW SAVE FUNCTION ---
    @MainActor
    func saveCanvasAsImage() {
        // This is a "snapshot" of the Canvas view
        let renderer = ImageRenderer(
            content:
                Canvas { context, size in
                    // We must redraw all lines here for the snapshot
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
