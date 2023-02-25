//
//  GitLabSwift
//  Async/Await client for GitLab API v4, for Swift
//
//  Created & Maintained by Daniele Margutti
//  Email: hello@danielemargutti.com
//  Web: http://www.danielemargutti.com
//
//  Copyright ©2023 Daniele Margutti.
//  Licensed under MIT License.
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
