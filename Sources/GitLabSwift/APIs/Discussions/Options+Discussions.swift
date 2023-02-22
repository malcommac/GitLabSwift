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

extension APIOptions {
    
    public class NewMergeRequestThread: APIOptionsCollection {
        
        // MARK: - Required

        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id") public var projectID: DataTypes.ProjectID?
        
        /// The IID of a merge request.
        @APIOption(key: "merge_request_iid") public var mergeRequest: Int?
        
        /// The content of the thread.
        @APIOption(key: "body") public var body: String?
        
        // MARK: - Optional
        
        /// SHA referencing commit to start this thread on.
        @APIOption(key: "commit_id") public var commitID: Int?
        
        /// The IID of a merge request.
        @APIOption(key: "created_at") public var createdAt: Date?
        
        /// Position when creating a diff note.
        @APIOption(key: "position") public var position: String?
        
    }
    
}
