//
//  File.swift
//  
//
//  Created by daniele on 20/12/22.
//

import Foundation

open class APIService {
    
    // MARK: - Private Properties
    
    /// Service.
    internal private(set) weak var gitlab: GitLab!
    
    // MARK: - Initialization
    
    /// Initialize with given gitlab service.
    ///
    /// - Parameter gitlab: gitlab.
    internal init(gitlab: GitLab) {
        self.gitlab = gitlab
    }
    
}
