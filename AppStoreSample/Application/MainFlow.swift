//
//  MainFlow.swift
//  AppStoreSample
//
//  Created by Hyoungsu Ham on 2021/08/02.
//

import RxSwift
import RxFlow
import UIKit

final class MainFlow: Flow {
    enum Tab: Int {
        case search = 0
        case setting = 1
    }
    
    private let searchFlow: SearchFlow
    private let settingFlow: SettingFlow
    
    var root: Presentable {
        return rootViewController
    }
    
    let rootViewController: UITabBarController = .init()
    
    init() {
        self.searchFlow = .init(stepper: .init())
        self.settingFlow = .init(stepper: .init())
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AppStep else {
            return .none
        }
        
        switch step {
        case .main:
            return coordinateToMainTapBar()
        default:
            return .none
        }
    }
    
    private func coordinateToMainTapBar() -> FlowContributors {
        Flows.use(
            searchFlow, settingFlow,
            when: .created
        ) { [unowned self] (search: UINavigationController,
                            setting: UINavigationController) in
            
            let searchImage: UIImage? = UIImage(systemName: "magnifyingglass")
            let settingImage: UIImage? = UIImage(systemName: "gearshape.fill")
            
            let homeItem: UITabBarItem = .init(title: "Search", image: searchImage, selectedImage: nil)
            let settingItem: UITabBarItem = .init(title: "Setting", image: settingImage, selectedImage: nil)
            
            search.tabBarItem = homeItem
            setting.tabBarItem = settingItem
            
            self.rootViewController.setViewControllers([search, setting], animated: true)
        }
        
        return .multiple(flowContributors: [
            .contribute(withNextPresentable: searchFlow, withNextStepper: searchFlow.stepper),
            .contribute(withNextPresentable: settingFlow, withNextStepper: settingFlow.stepper)
        ])
    }
}