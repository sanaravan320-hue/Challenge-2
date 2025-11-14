//
//  LeftSidebarView.swift
//  Challenge 2
//
//  Created by Sana Ravan on 12/11/25.



import SwiftUI
import UIKit // We need this to create the custom slider

// --- 1. Make sure the struct name matches ---
struct LeftSidebarView: View {
    
    // --- 2. @Binding Variables ---
    // These connect to ContentView's @State
    @Binding var brushSize: Int
    @Binding var brushOpacity: Int
    @Binding var lines: [Line]
    @Binding var undoneLines: [Line]
    
    // --- 3. Local State for Keyboard ---
    @FocusState private var isSizeFieldFocused: Bool
    @FocusState private var isOpacityFieldFocused: Bool
    
    // --- 4. Number Formatter for TextFields ---
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minimum = 0
        formatter.maximum = 100
        return formatter
    }()
    
    // --- 5. Style constants for the compact look ---
    private let sidebarWidth: CGFloat = 70
    private let stepperHeight: CGFloat = 28
    private let stepperFontSize: CGFloat = 13
    private let sliderHeight: CGFloat = 70
    private let toolButtonSize: CGFloat = 17
    private let toolButtonHeight: CGFloat = 30
    
    // --- Main View Body ---
    // We break the body into smaller helper views
    // to prevent the "compiler is unable to type-check" error.
    var body: some View {
        VStack(spacing: 8) { // This spacing controls the gap between groups
            
            // --- First Group ---
            sizeControls
            
            // --- Second Group ---
            opacityControls
            
            // --- Third Group ---
            toolAndHistoryButtons
            
        } // End of main VStack
        .padding(.vertical, 16) // Padding at the very top and bottom
        .padding(.horizontal, 6)
        .frame(width: sidebarWidth) // Set the final, compact width
        .background(.ultraThinMaterial.opacity(0.8)) // Liquid Glass effect
        .cornerRadius(sidebarWidth / 2) // Perfect pill shape
        .overlay(
            RoundedRectangle(cornerRadius: sidebarWidth / 2)
                .stroke(Color.white.opacity(0.2), lineWidth: 1)
        )
        // This pushes the pill to the center vertically
        .frame(maxHeight: .infinity, alignment: .center)
        
        // --- This adds the "Done" button to the keyboard ---
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    clampValues()
                    isSizeFieldFocused = false
                    isOpacityFieldFocused = false
                }
            }
        }
    }
    
    // --- HELPER VIEW for Size Controls ---
    @ViewBuilder
    private var sizeControls: some View {
        VStack(spacing: 6) { // Tighter spacing for this sub-group
            Text("Size")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
            
            // --- THIS IS THE NEW CUSTOM SLIDER ---
            CustomVerticalSlider(value: Binding(
                get: { Double(brushSize) },
                set: { brushSize = Int($0) }
            ), in: 0...100)
            .frame(width: 30, height: sliderHeight)
            
            // Custom Compact Stepper
            HStack(spacing: 2) {
                TextField("", value: $brushSize, formatter: numberFormatter)
                    .keyboardType(.numberPad)
                    .focused($isSizeFieldFocused)
                    .font(.system(size: stepperFontSize, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 24)
                    .padding(.leading, 6)
                
                Text("px")
                    .font(.system(size: 9, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 14)
                    .offset(x: -2)
                
                VStack(spacing: 2) {
                    Button(action: { incrementSize() }) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 9, weight: .medium))
                            .frame(width: 16, height: 12)
                    }
                    Button(action: { decrementSize() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .medium))
                            .frame(width: 16, height: 12)
                    }
                }
                .foregroundColor(.white)
                .padding(.trailing, 4)
            }
            .frame(height: stepperHeight)
            .background(Color.black.opacity(0.15))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        } // End of Size VStack
    }
    
    // --- HELPER VIEW for Opacity Controls ---
    @ViewBuilder
    private var opacityControls: some View {
        VStack(spacing: 6) {
            Text("Opacity")
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.8))
                .frame(maxWidth: .infinity, alignment: .center)
            
            // --- THIS IS THE NEW CUSTOM SLIDER ---
            CustomVerticalSlider(value: Binding(
                get: { Double(brushOpacity) },
                set: { brushOpacity = Int($0) }
            ), in: 0...100)
            .frame(width: 30, height: sliderHeight)
            
            // Custom Compact Stepper
            HStack(spacing: 2) {
                TextField("", value: $brushOpacity, formatter: numberFormatter)
                    .keyboardType(.numberPad)
                    .focused($isOpacityFieldFocused)
                    .font(.system(size: stepperFontSize, weight: .medium))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 24)
                    .padding(.leading, 6)
                
                Text("%")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(width: 14)
                    .offset(x: -2)
                
                VStack(spacing: 2) {
                    Button(action: { incrementOpacity() }) {
                        Image(systemName: "chevron.up")
                            .font(.system(size: 9, weight: .medium))
                            .frame(width: 16, height: 12)
                    }
                    Button(action: { decrementOpacity() }) {
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .medium))
                            .frame(width: 16, height: 12)
                    }
                }
                .foregroundColor(.white)
                .padding(.trailing, 4)
            }
            .frame(height: stepperHeight)
            .background(Color.black.opacity(0.15))
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
        } // End of Opacity VStack
    }
    
    // --- HELPER VIEW for Tool & History Buttons ---
    @ViewBuilder
    private var toolAndHistoryButtons: some View {
        VStack(spacing: 12) {
            Button(action: { print("Eyedropper tapped") }) {
                Image(systemName: "eyedropper")
                    .font(.system(size: toolButtonSize))
                    .frame(width: 40, height: toolButtonHeight)
                    .foregroundColor(.white)
            }
            .padding(.top, 8) // Add a little space before tools
            
            // --- UNDO BUTTON ---
            Button(action: {
                if let lastLine = lines.popLast() {
                    undoneLines.append(lastLine)
                }
            }) {
                Image(systemName: "arrow.uturn.backward")
                    .font(.system(size: toolButtonSize))
                    .frame(width: 40, height: toolButtonHeight)
                    .foregroundColor(.white)
            }
            .disabled(lines.isEmpty)
            
            // --- REDO BUTTON ---
            Button(action: {
                if let lastUndoneLine = undoneLines.popLast() {
                    lines.append(lastUndoneLine)
                }
            }) {
                Image(systemName: "arrow.uturn.forward")
                    .font(.system(size: toolButtonSize))
                    .frame(width: 40, height: toolButtonHeight)
                    .foregroundColor(.white)
            }
            .disabled(undoneLines.isEmpty)
            
        } // End of Tools VStack
    }
    
    // --- Helper Functions ---
    
    func clampValues() {
        if brushSize > 100 { brushSize = 100 }
        if brushSize < 0 { brushSize = 0 }
        if brushOpacity > 100 { brushOpacity = 100 }
        if brushOpacity < 0 { brushOpacity = 0 }
    }
    
    func incrementSize() {
        if brushSize < 100 { brushSize += 1 }
    }
    func decrementSize() {
        if brushSize > 0 { brushSize -= 1 }
    }
    func incrementOpacity() {
        if brushOpacity < 100 { brushOpacity += 1 }
    }
    func decrementOpacity() {
        if brushOpacity > 0 { brushOpacity -= 1 }
    }
}

// --- THIS IS THE CUSTOM SLIDER THAT FIXES THE "LINKED" BUG ---
private struct CustomVerticalSlider: UIViewRepresentable {
    @Binding var value: Double
    var `in`: ClosedRange<Double>
    
    // Create the small thumb image one time
    private static let thumbImage: UIImage = {
        let image = Image(systemName: "circle.fill")
            .font(.system(size: 15)) // <-- I changed this from 12 to 15
            .foregroundColor(.white)
        
        let renderer = ImageRenderer(content: image)
        return renderer.uiImage ?? UIImage()
    }()
    
    // 1. Create the UIKit UISlider
    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        slider.minimumValue = Float(self.in.lowerBound)
        slider.maximumValue = Float(self.in.upperBound)
        slider.value = Float(self.value)
        slider.tintColor = UIColor.white.withAlphaComponent(0.5)
        
        // --- THIS IS THE FIX ---
        // We set the thumb image on *this specific slider*,
        // not on the global "appearance()"
        slider.setThumbImage(Self.thumbImage, for: .normal)
        
        slider.transform = CGAffineTransform(rotationAngle: -(.pi / 2)) // Rotate it
        
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }
    
    // 2. Update the slider when the @Binding changes
    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(self.value)
    }
    
    // 3. Create a Coordinator to send data *back* to SwiftUI
    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }
    
    class Coordinator: NSObject {
        var value: Binding<Double>
        
        init(value: Binding<Double>) {
            self.value = value
        }
        
        @objc func valueChanged(_ sender: UISlider) {
            self.value.wrappedValue = Double(sender.value)
        }
    }
}

// --- PREVIEW ---
struct LeftSidebarView_Previews: PreviewProvider {
    static var previews: some View {
        LeftSidebarView(
            brushSize: .constant(40),
            brushOpacity: .constant(87),
            lines: .constant([]),
            undoneLines: .constant([])
        )
        .background(Color.gray)
    }
}
