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
    
    public class ProtectBranch: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var projectID: DataTypes.ProjectID?
        
        /// The name of the branch or wildcard
        @APIOption(key: "name")
        public var name: String?
        
        /// The name of the branch or wildcard.
        @APIOption(key: "name")
        public var sha: String?
        
        /// Access levels allowed to push.
        @APIOption(key: "push_access_level")
        public var pushAccessLevel: DataTypes.AccessLevelAssign?
        
        /// Access levels allowed to merge.
        @APIOption(key: "merge_access_level")
        public var mergeAccessLevel: DataTypes.AccessLevelAssign?

        /// Access levels allowed to unprotect.
        @APIOption(key: "unprotect_access_level")
        public var unprotectAccessLevel: DataTypes.AccessLevelAssign?

        /// Allow all users with push access to force push.
        @APIOption(key: "allow_force_push")
        public var allowForcePush: Bool?
        
        /// Prevent pushes to this branch if it matches an item in the CODEOWNERS file.
        @APIOption(key: "code_owner_approval_required")
        public var codeOwnerApprovalRequired: Bool?
        
        /// Array of push access levels, with each described by a hash.
        @APIOption(key: "allowed_to_push")
        public var allowedToPush: ArrayOfHashes?
        
        public init(name: String, project: DataTypes.ProjectID, _ configure: ((ProtectBranch) -> Void)?) {
            super.init()
            self.name = name
            self.projectID = project
            configure?(self)
        }
        
    }
    
}
