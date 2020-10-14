//
//  UniversityViewModel.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

protocol UniversityViewModelEventsDelegate: class {
    func updateLoadingIndicator()
    func updateUIContent()
}

class UniversityViewModel: ObservableObject, Identifiable {
    @Published var universityList: [University]? {
        didSet {
            didChange.send(universityList ?? [])
        }
    }
    private let client = APIClient.sharedInstance()
    private var subscriber: AnyCancellable?
    
    weak var delegate: UniversityViewModelEventsDelegate?
    
    let didChange = PassthroughSubject<[University], Never>()
    
    init(delegate: UniversityViewModelEventsDelegate) {
        self.delegate = delegate
        self.fetchUniversityList()
    }
    
    func fetchUniversityList() {
        delegate?.updateUIContent()
        delegate?.updateLoadingIndicator()
        subscriber?.cancel()
        subscriber = client.listAllUniversities(with: client.getAllUniversitiesURL())
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .failure(_):
                        self.universityList = []
                        self.delegate?.updateUIContent()
                        self.delegate?.updateLoadingIndicator()
                    case .finished:
                        break
                    }
                }, receiveValue: { universities in
                    self.universityList = universities
                    self.delegate?.updateUIContent()
                    self.delegate?.updateLoadingIndicator()
                }
            )
    }
    
    func getViewModelListCount() -> Int {
        guard let list = universityList else {
            return 0
        }
        return list.count
    }
}
