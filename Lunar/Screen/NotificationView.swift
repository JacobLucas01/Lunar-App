//
//  NotificationView.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/9/22.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                HStack {
                    Spacer()
                }
                Text("Notifications")
                    .font(.system(size: 20))
                    .fontWeight(.medium)
                    .foregroundColor(Color(.label))
            }
            .padding(.vertical)
            .frame(width: UIScreen.main.bounds.width - 30)
            Spacer()
        }
    }
}

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
