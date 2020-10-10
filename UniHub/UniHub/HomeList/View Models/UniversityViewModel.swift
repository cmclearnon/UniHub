//
//  UniversityViewModel.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine

class UniversityViewModel: ObservableObject, Identifiable {
    @Published var universityList: [UniListResponse]? {
        didSet {
            didChange.send(universityList ?? [])
        }
    }
    private let client = APIClient.sharedInstance()
    private var disposables = Set<AnyCancellable>()
    
    let didChange = PassthroughSubject<[UniListResponse], Never>()
    
    init() {
        self.fetchUniversityList()
    }
    
    func fetchUniversityList() {
        client.listAllUniversities()
            .mapError({ (error) -> APIError in
                return .network(description: "Error fetching data from API: \(error.localizedDescription)")
            })
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] value in
                    guard let self = self else { return }
                    switch value {
                    case .failure:
                        self.universityList = []
                    case .finished:
                        break
                    }
                }, receiveValue: { [weak self] universities in
                    guard let self = self else { return }
                    self.universityList = universities
                    print(self.universityList?[0])
                }
            ).store(in: &disposables)
    }
}
