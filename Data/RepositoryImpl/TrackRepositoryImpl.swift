//
//  TrackRepositoryImpl.swift
//  Data
//
//  Created by Hyoungsu Ham on 2021/08/03.
//

import Domain
import RxSwift

public class TrackRepositoryImpl: TrackRepository {
    private let remoteSource: TrackDataSource
    
    init(remoteSource: TrackDataSource) {
        self.remoteSource = remoteSource
    }
    
    public func getTracks(_ query: String) -> Observable<[Track]> {
        remoteSource.getTracks(query)
    }
}