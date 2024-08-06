//
//  ContentView.swift
//  APISampleSwiftUI
//
//  Created by Dona Maria Peter on 03/06/24.
//

import SwiftUI

struct URLImage: View {
    let image: UIImage?

    var body: some View {
        if let uiImage = image {
            Image(uiImage: uiImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 120, height: 70)
                .background(Color.gray)
        } else {
            Image(systemName: "video")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 130, height: 70)
                .background(Color.gray)
        }
    }
}

struct ContentView: View {
    //SwiftUI creates a new instance of the model object only once during the lifetime of the container that declares the state object.
    //Declare state objects as private to prevent setting them from a memberwise initializer, which can conflict with the storage management
    @StateObject private var viewModel = CourseViewModel()

    var body: some View {
        NavigationView {
            List(viewModel.courses, id: \.self) { course in
                HStack {
                    URLImage(image: viewModel.image(for: course.image))
                    Text(course.name).bold()
                }
                .padding(3)
            }
            .navigationTitle("Courses")
            .onAppear {
                viewModel.fetchCourses()
            }
        }
    }
}

#Preview {
    ContentView()
}
