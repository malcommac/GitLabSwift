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

extension APIService.GroupMilestones {
    
    public class ListOptions: APIOptionsCollection {
        
        /// The ID of the project’s milestone.
        @APIOption(key: "id")
        public var group: Int?
        
        /// Return only the milestones having the given iid.
        @APIOption(key: "iids")
        public var iids: [Int]?
        
        /// Return only `active` or `closed` milestones.
        @APIOption(key: "state")
        public var state: DataTypes.MilestoneState?
        
        /// Return only the milestones having the given title.
        @APIOption(key: "title")
        public var title: String?
        
        /// Return only milestones with a title or description matching the provided string
        @APIOption(key: "search")
        public var search: String?
        
        /// Include milestones from parent group and its ancestors. 
        @APIOption(key: "include_parent_milestones")
        public var includeParentMilestones: Bool?
        
        public init(group: Int, _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.group = group
            configure?(self)
        }
        
    }
    
}
