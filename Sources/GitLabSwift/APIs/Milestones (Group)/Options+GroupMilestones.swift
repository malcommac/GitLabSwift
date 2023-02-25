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

extension APIs.GroupMilestones {
    
    public class ListOptions: OutputParamsCollection {
        
        /// The ID of the project’s milestone.
        @OutputParam(key: "id")
        public var group: Int?
        
        /// Return only the milestones having the given iid.
        @OutputParam(key: "iids")
        public var iids: [Int]?
        
        /// Return only `active` or `closed` milestones.
        @OutputParam(key: "state")
        public var state: InputParams.MilestoneState?
        
        /// Return only the milestones having the given title.
        @OutputParam(key: "title")
        public var title: String?
        
        /// Return only milestones with a title or description matching the provided string
        @OutputParam(key: "search")
        public var search: String?
        
        /// Include milestones from parent group and its ancestors. 
        @OutputParam(key: "include_parent_milestones")
        public var includeParentMilestones: Bool?
        
        public init(group: Int, _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.group = group
            configure?(self)
        }
        
    }
    
}
