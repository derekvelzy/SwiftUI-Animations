//
//  ContentView.swift
//  Animations
//
//  Created by Derek Velzy on 11/8/21.
//

import SwiftUI

struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}

extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(
            active: CornerRotateModifier(amount: -90, anchor: .topLeading),
            identity: CornerRotateModifier(amount: 0, anchor: .topLeading)
        )
    }
}

struct ContentView: View {
    @State private var animationAmount = 1.0
    @State private var animationAmount2 = 1.0
    @State private var animationAmount3 = 0.0
    @State private var dragAmount = CGSize.zero
    @State private var tog = false
    let letters = Array("Hello SwiftUI!")
    @State private var isShowingRed = false
    @State private var isShowingYellow = false
    
    var body: some View {
        VStack {
            Button("Tap me") {
    //            animationAmount += 1
            }
                .padding(30)
                .background(.red)
                .foregroundColor(.white)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(.red)
                        .scaleEffect(animationAmount)
                        .opacity(2 - animationAmount)
                        .animation(
                            .easeInOut(duration: 1)
                                .repeatForever(autoreverses: true),
                            value: animationAmount
                        )
                )
                .onAppear {
                    animationAmount = 2
                }
            
            Spacer()
            
            VStack {
                Stepper("Scale amount", value: $animationAmount2.animation(), in: 1...10, step: 0.25)
                
                Button("Tap this") {
                    animationAmount2 += 0.25
                }
                .padding(20)
                .background(.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .scaleEffect(animationAmount2)
            }
            
            Spacer()
            
            Button("Tap me") {
                withAnimation(.interpolatingSpring(stiffness: 50, damping: 3)) {
                    animationAmount3 += 360
                }
            }
            .padding(50)
            .background(.green)
            .foregroundColor(.white)
            .clipShape(Circle())
            .rotation3DEffect(.degrees(animationAmount3), axis: (x: 0, y: 0, z: 1))
            
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(0..<letters.count) {
                    i in
                    Text(String(letters[i]))
                        .padding(5)
                        .font(.title)
                        .background(tog ? .yellow : .orange)
                        .offset(dragAmount)
                        .animation(
                            .default
                                .delay(Double(i) / 20),
                            value: dragAmount
                        )
                }
            }
            .gesture(
              DragGesture()
                .onChanged {
                    dragAmount = $0.translation
                }
                .onEnded {
                    _ in
                    dragAmount = .zero
                    tog.toggle()
                }
            )
            
            Spacer()
            
            VStack {
                Button("Tap Tap Tap") {
                    withAnimation {
                        isShowingRed.toggle()
                    }
                }
                
                if isShowingRed {
                    Rectangle()
                        .fill(.red)
                        .frame(width: 120, height: 80)
                        .transition(.asymmetric(insertion: .scale, removal: .opacity))
                }
            }
            
            ZStack {
                Rectangle()
                    .fill(.purple)
                    .frame(width: 100, height: 100)
                
                if isShowingYellow {
                    Rectangle()
                        .fill(.yellow)
                        .frame(width: 100, height: 100)
                        .transition(.pivot) // USING CUSTOM TRANSITION
                }
            }
            .onTapGesture {
                withAnimation {
                    isShowingYellow.toggle()
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


// ================================ VID 2/8 ======================================
// Implicit animations: just add it as a modifier to an element

// Customize animations:
// instead of default, try .easeOut or .interpolatingSpring

// add (duration: n) to an animation -> .default(duration: 2) or .easeOut(duration: 1)

// add .delay(n) as a modifier to the type of animation:
    // .animation(
    //     .easeInOut(duration: 2)
    //         .delay(1),
    //     value: animationAmount
    // )

// repeat the animation by adding
// .repeatCount(n, autoreverses: true) OR
// .repeatForever(autoreverses: true):
    // .animation(
    //     .easeInOut(duration: 2)
    //         .repeatCount(3, autoreverses: true),
    //     value: animationAmount
    // )

// use an .overlay modifier to draw views over the previous views at the same size


// ================================ VID 3/8 ======================================
// animated binding changes:
// animation modifier can be applied to ANY SwiftUI data binding:

// $animationAmount2.animation(...)


// ================================ VID 4/8 ======================================
// explicit animations:
// animated changes from any change we'd like


// ================================ VID 5/8 ======================================
// animations modifiers do not animated any added modifiers after the animation one
