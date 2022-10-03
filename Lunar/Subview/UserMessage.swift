//
//  UserMessage.swift
//  Lunar
//
//  Created by Jacob Lucas on 1/21/22.
//

import SwiftUI

struct UserMessage: View {
    
    @State var userComment: UserCommentModel
    @State var profilePicture: UIImage = UIImage(systemName: "person.crop.circle.fill")!
    
    var body: some View {
        HStack(alignment: .bottom) {
            if userComment.isRecieved == false {
                Spacer()
            }
            Text(userComment.content)
                .padding(10)
                .background(Color.accentColor)
                .cornerRadius(8)
                .foregroundColor(.white)
            
            if userComment.isRecieved == true {
                Spacer()
            }
        }
        .padding(.top, 12)
        .frame(width: UIScreen.main.bounds.width - 30)
    }
}
