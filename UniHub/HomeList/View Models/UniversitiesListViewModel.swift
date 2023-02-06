//
//  UniversitiesListViewModel.swift
//  UniHub
//
//  Created by Chris McLearnon on 10/10/2020.
//

import Foundation
import Combine
import RxSwift

class UniversitiesListViewModel: ObservableObject, Identifiable {
    var universityList: [University]?
    private let client = APIClient.sharedInstance()
    
    let onChange: (([University]) -> Void)

    init(onChange: @escaping (([University]) -> Void)) {
        self.onChange = onChange
    }

    func fetchUniversities() {
        client.fetchUniversities(completionHandler: { [weak self] res in
            guard let self = self else { return }
            switch res {
            case let .success(universities):
                self.universityList = universities
                self.onChange(self.universityList ?? [])
            case let .failure(_):
                self.universityList = []
                self.onChange(self.universityList ?? [])
            }
        })
    }
    
    func getViewModelListCount() -> Int {
        guard let list = universityList else {
            return 0
        }
        return list.count
    }
}

class UniversitiesListViewModel2: ObservableObject, Identifiable {
    private(set) var universityList: PublishSubject<[University]> = PublishSubject<[University]>()
    private let client = APIClient.sharedInstance()

    func fetchUniversities(completion: @escaping () -> Void) {
        client.fetchUniversities(completionHandler: { [weak self] res in
            guard let self = self else { return }
            switch res {
            case let .success(universities):
                self.universityList.onNext(universities)
                completion()
            case .failure(_):
                self.universityList.onNext([])
                completion()
            }
        })
    }
}
