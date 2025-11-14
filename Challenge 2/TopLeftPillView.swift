//
//  TopLeftPillView.swift
//  Challenge 2
//
//  Created by Sana Ravan on 12/11/25.
//

import SwiftUI

struct TopLeftPillView: View {
    // 1. ADD THIS ACTION
    // This will be a "closure" (a function) passed in from ContentView
    var saveAction: () -> Void
    
    var body: some View {
        // We use an HStack to hold the Back button and the tools pill
        HStack {
            
            // 1. This is the standalone Back Button
            Button(action: {
                print("Back to Gallery tapped")
            }) {
                Image(systemName: "chevron.backward")
                    .font(.system(size: 20, weight: .bold))
                    .frame(width: 44, height: 44) // Standard 44x44 tap target
                    .foregroundColor(.white)
                    .background(.ultraThinMaterial.opacity(0.8))
                    .cornerRadius(22) // Makes it a circle
                    .overlay(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(Color.white.opacity(0.2), lineWidth: 1)
                    )
            }
            
            // 2. This is the main "Actions" pill
            HStack(spacing: 0) {
                
                // --- THIS IS YOUR FINAL ORDER ---
                
                // Transform Button (Arrow)
                Button(action: { print("Transform tapped") }) {
                    Image(systemName: "arrow.up.forward")
                        .font(.system(size: 20))
                        .frame(width: 50, height: 44)
                        .foregroundColor(.white)
                }
                
                // Select Button (Lasso)
                Button(action: { print("Select tapped") }) {
                    Image(systemName: "lasso")
                        .font(.system(size: 20))
                        .frame(width: 50, height: 44)
                        .foregroundColor(.white)
                }

                // Adjustments Button (Your choice)
                Button(action: { print("Adjustments tapped") }) {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 20))
                        .frame(width: 50, height: 44)
                        .foregroundColor(.white)
                }
                
                // Visual Divider
                Divider()
                    .background(Color.white.opacity(0.3))
                    .frame(height: 22)
                
                // Share Button
                Button(action: {
                    // 2. CALL THE ACTION
                    print("Save tapped")
                    saveAction()
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.system(size: 20))
                        .frame(width: 50, height: 44)
                        .foregroundColor(.white)
                }
                
                // Settings/More Button (Your choice)
                Button(action: { print("Settings tapped") }) {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 20))
                        .frame(width: 50, height: 44)
                        .foregroundColor(.white)
                }
                
            } // End of tools pill HStack
            .padding(.horizontal, 6)
            .background(.ultraThinMaterial.opacity(0.8))
            .cornerRadius(22)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            
        } // End of main HStack
    }
}

struct TopLeftPillView_Previews: PreviewProvider {
    static var previews: some View {
        // 3. Update the preview to pass in an empty action
        TopLeftPillView(saveAction: {})
            .background(Color.gray)
    }
}
