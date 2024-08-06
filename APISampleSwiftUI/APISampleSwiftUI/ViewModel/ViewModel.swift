//
//  ViewModel.swift
//  APISampleSwiftUI
//
//  Created by Dona Maria Peter on 04/06/24.
//

import Foundation
import SwiftUI

class CourseViewModel: ObservableObject {
    @Published var courses: [Course] = []
    @Published var images: [String: UIImage] = [:]

    func fetchCourses() {
        APIService.fetchData(from: "https://iosacademy.io/api/v1/courses/index.php") { [weak self] (result: Result<[Course], Error>) in
            switch result {
            case .success(let courses):
                DispatchQueue.main.async {
                    self?.courses = courses
                    self?.fetchImages(for: courses)
                }
            case .failure(let error):
                print("Failed to fetch courses: \(error)")
            }
        }
    }

    private func fetchImages(for courses: [Course]) {
        for course in courses {
            APIService.fetchImage(from: course.image) { [weak self] result in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.images[course.image] = image
                    }
                case .failure(let error):
                    print("Failed to fetch image: \(error)")
                }
            }
        }
    }

    func image(for urlString: String) -> UIImage? {
        return images[urlString]
    }
}
