//
//  AirdropView.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/20/22.
//

import SwiftUI

struct AirdropView: View {
    
    @State private var isSharePresented: Bool = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 14) {
                Text("HELP OTHERS REACH OUT")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                Text("Share Lunar with somebody close to you by pressing the share button, and clicking on airdrop.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                    .frame(width: UIScreen.main.bounds.width - 65)
            }
            VStack {
                Spacer()
                Button {
                    let impactMed = UIImpactFeedbackGenerator(style: .medium)
                    impactMed.impactOccurred()
                    self.isSharePresented = true
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: .greatestFiniteMagnitude)
                            .stroke(Color.accentColor, lineWidth: 1)
                            .frame(width: 120, height: 44)
                        Text("Share")
                            .font(.system(size: 18))
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.vertical, 30)
            }
        }
        .frame(width: UIScreen.main.bounds.width - 50)
        .sheet(isPresented: $isSharePresented, onDismiss: {
            print("Dismiss")
        }, content: {
            ActivityViewController(activityItems: [URL(string: "https://www.apple.com")!])
        })
    }
}

struct AirdropView_Previews: PreviewProvider {
    static var previews: some View {
        AirdropView()
    }
}
