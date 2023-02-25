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

extension APIs.ProtectedBranches {
    
    /// Options used to setup a protection for a branch.
    public class ProtectBranchOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The name of the branch or wildcard
        @OutputParam(key: "name")
        public var name: String?
        
        /// Allow all users with push access to force push.
        @OutputParam(key: "allow_force_push")
        public var allowForcePush: Bool?
        
        /// Array of access levels allowed to merge, with each described
        /// by a hash of the form:
        /// `{user_id: integer}, {group_id: integer}`, or `{access_level: integer}`.
        @OutputParam(key: "allowed_to_merge")
        public var allowedToMerge: Hash?
        
        /// Array of access levels allowed to push, with each described
        /// by a hash of the form:
        /// `{user_id: integer}, {group_id: integer}`, or `{access_level: integer}`.
        @OutputParam(key: "allowed_to_push")
        public var allowedToPush: Hash?

        /// Array of access levels allowed to unprotect, with each described
        /// by a hash of the form:
        /// `{user_id: integer}, {group_id: integer}`, or `{access_level: integer}`.
        @OutputParam(key: "allowed_to_unprotect")
        public var allowedToUnprotect: Hash?
        
        /// Prevent pushes to this branch if it matches an item in the CODEOWNERS file.
        @OutputParam(key: "code_owner_approval_required")
        public var codeOwnerApprovalRequired: Bool?
        
        /// Access levels allowed to merge.
        @OutputParam(key: "merge_access_level")
        public var mergeAccessLevel: InputParams.AccessLevelAssign?

        /// Access levels allowed to push.
        @OutputParam(key: "push_access_level")
        public var pushAccessLevel: InputParams.AccessLevelAssign?
        
        /// Access levels allowed to unprotect.
        @OutputParam(key: "unprotect_access_level")
        public var unprotectAccessLevel: InputParams.AccessLevelAssign?
    
        // MARK: - Initialization
        
        public init(name: String,
                    project: InputParams.Project,
                    _ configure: ((ProtectBranchOptions) -> Void)?) {
            super.init()
            self.name = name
            self.project = project
            configure?(self)
        }
        
    }
    
    public class UpdateBranchOptions: OutputParamsCollection {
     
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The name of the branch or wildcard
        @OutputParam(key: "name")
        public var name: String?
        
        /// Allow all users with push access to force push.
        @OutputParam(key: "allow_force_push")
        public var allowForcePush: Bool?
        
        /// Array of access levels allowed to push, with each described
        /// by a hash of the form:
        /// `{user_id: integer}, {group_id: integer}`, or `{access_level: integer}`.
        @OutputParam(key: "allowed_to_push")
        public var allowedToPush: Hash?
        
        /// Array of access levels allowed to merge, with each described
        /// by a hash of the form:
        /// `{user_id: integer}, {group_id: integer}`, or `{access_level: integer}`.
        @OutputParam(key: "allowed_to_merge")
        public var allowedToMerge: Hash?
        
        /// Array of access levels allowed to unprotect, with each described
        /// by a hash of the form:
        /// `{user_id: integer}, {group_id: integer}`, or `{access_level: integer}`.
        @OutputParam(key: "allowed_to_unprotect")
        public var allowedToUnprotect: Hash?
        
        /// Prevent pushes to this branch if it matches an item in the CODEOWNERS file.
        @OutputParam(key: "code_owner_approval_required")
        public var codeOwnerApprovalRequired: Bool?
        
        public init(name: String,
                    project: InputParams.Project,
                    _ configure: ((UpdateBranchOptions) -> Void)?) {
            super.init()
            self.name = name
            self.project = project
            configure?(self)
        }
        
    }
    
}
