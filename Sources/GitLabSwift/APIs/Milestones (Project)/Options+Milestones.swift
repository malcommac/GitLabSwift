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

extension APIService.ProjectMilestones {
    
    public class EditOptions: CreateOptions {
        
        /// The ID of the project’s milestone.
        @APIOption(key: "milestone_id", location: .parameterInQueryURL)
        public var milestone: String?
        
        /// The state event of the milestone (`close` or `activate`).
        @APIOption(key: "state_event")
        public var stateEvent: DataTypes.MilestoneEditState?
     
        public init(milestone: String,
                    project: DataTypes.ProjectID,
                    _ configure: ((EditOptions) -> Void)?) {
            super.init(project: project, nil)
            self.milestone = milestone
            configure?(self)
        }
        
    }
        
    public class CreateOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The title of a milestone.
        @APIOption(key: "title")
        public var title: String?
        
        /// The description of the milestone.
        @APIOption(key: "description")
        public var description: String?
        
        /// The due date of the milestone (YYYYMMDD).
        @APIOption(key: "start_date")
        public var startDate: DataTypes.DateOnly?
        
        /// The start date of the milestone (YYYYMMDD)
        @APIOption(key: "due_date")
        public var dueDate: DataTypes.DateOnly?
     
        public init(project: DataTypes.ProjectID,
                    title: String? = nil,
                    _ configure: ((CreateOptions) -> Void)?) {
            super.init()
            self.title = title
            self.project = project
            configure?(self)
        }
        
    }
    
    public class ListOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// Return only the milestones having the given iid.
        @APIOption(key: "iids")
        public var iids: [Int]?
        
        /// Return only active or closed milestones.
        @APIOption(key: "state")
        public var state: DataTypes.MilestoneState?
        
        /// Return only the milestones having the given title.
        @APIOption(key: "title")
        public var title: String?
        
        /// Return only milestones with a title or description matching the provided string.
        @APIOption(key: "search")
        public var search: String?
        
        /// Include group milestones from parent group and its ancestors.
        @APIOption(key: "include_parent_milestones")
        public var includeParent: Bool?
        
        public init(project: DataTypes.ProjectID,
                    _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
}
