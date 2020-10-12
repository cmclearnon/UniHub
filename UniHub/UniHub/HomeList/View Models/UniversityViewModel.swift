//
//  UniversityViewModel.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

class UniversityViewModel: ObservableObject, Identifiable {
    @Published var universityList: [University]? {
        didSet {
            didChange.send(universityList ?? [])
        }
    }
    private let client = APIClient.sharedInstance()
    private var subscriber: AnyCancellable?
    
    let didChange = PassthroughSubject<[University], Never>()
    
    init() {
        self.fetchUniversityList()
    }
    
    func fetchUniversityList() {
        subscriber?.cancel()
        subscriber = client.listAllUniversities(with: client.getAllUniversitiesURL())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(let error):
                        self.universityList = []
                    case .finished:
                        break
                    }
                }, receiveValue: { universities in
                    self.universityList = universities
                }
            )
    }
}
