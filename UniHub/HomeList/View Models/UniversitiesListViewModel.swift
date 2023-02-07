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
