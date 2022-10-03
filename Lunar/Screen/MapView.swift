//
//  MapView.swift
//  Lunar
//
//  Created by Jacob Lucas on 3/16/22.
//

import SwiftUI
import MapKit

struct MapView: View {
    
 var name: String
 var title: String
 var content: String
    @Binding var pfp: UIImage
    
    @State var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40.7128, longitude: -74.0060), latitudinalMeters: 10, longitudinalMeters: 10)
    @State var tracking: MapUserTrackingMode = .follow
    @StateObject var annotations = RetrievePosts()
    @StateObject var manager = LocationManager()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                Map(coordinateRegion: $manager.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: $tracking, annotationItems: annotations.postAnnotation) { location in
                    MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: location.lat, longitude: location.long)) {
                        PostAnnotation(pfp: $pfp)
                    }
                }
                .ignoresSafeArea()
            }
            VStack {
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .frame(width: 45, height: 45)
                                .foregroundColor(.clear)
                                .background(.regularMaterial)
                                .clipShape(Circle())
                            
                            Image(systemName: "arrow.left")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 16, height: 16)
                                .foregroundColor(Color(.label))
                        }
                    }
                    .padding(.top)
                    Spacer()
                }
                .frame(width: UIScreen.main.bounds.width - 30)
                Spacer()
                MinimizedPostView(name: name, title: title, content: content, pfp: $pfp)
            }
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
        }
    }
}

struct MinimizedPostView: View {
 var name: String
 var title: String
 var content: String
    @Binding var pfp: UIImage
    var body: some View {
        ZStack {
            Rectangle()
                .frame(height: 120)
                .foregroundColor(.clear)
                .background(.thinMaterial)
            HStack(alignment: .top, spacing: 12) {
                Image(uiImage: pfp)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 5) {
                    Text(name)
                        .font(.system(size: 17, weight: .medium))
                    Text(title)
                        .font(.system(size: 20, weight: .medium))
                    Text(content)
                        .font(.system(size: 16))
                        .lineLimit(1)
                }
                Spacer()
            }
            .padding()
        }
    }
}
