//
//  LoadingView.swift
//  Sprofil
//
//  Created by Ben Shi on 3/22/22.
//

import SwiftUI

struct LoadingView: View {
    @State private var shouldAnimate = false
    var body: some View {
            HStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width:20, height:20)
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: shouldAnimate)
                Circle()
                    .fill(Color.blue)
                    .frame(width:20, height:20)
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3), value: shouldAnimate)
                Circle()
                    .fill(Color.blue)
                    .frame(width:20, height:20)
                    .scaleEffect(shouldAnimate ? 1.0 : 0.5)
                    .animation(Animation.easeInOut(duration: 0.5).repeatForever(), value: shouldAnimate)
            }
            .onAppear {
                self.shouldAnimate = true
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
