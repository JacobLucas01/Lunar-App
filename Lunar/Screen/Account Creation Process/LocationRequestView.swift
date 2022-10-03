//
//  LocationRequestView.swift
//  Lunar
//
//  Created by Jacob Lucas on 2/20/22.
//

import SwiftUI

struct LocationRequestView: View {
    
    let locationManager = LocationManager()
    
    var body: some View {
        ZStack {
            VStack {
                Text("ENABLE LOCATION SERVICES")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                Spacer()

            }
            .padding(.top, 55)
            VStack {
                Spacer()
                Text("Your data is safe with us. Learn more about what we do with your location info here.")
                    .font(.system(size: 14))
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical)
        .frame(width: UIScreen.main.bounds.width - 50)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
         //       locationManager.checkIfLocationServicesIsEnable()
            }
        }
    }
}

struct LocationRequestView_Previews: PreviewProvider {
    static var previews: some View {
        LocationRequestView()
    }
}
