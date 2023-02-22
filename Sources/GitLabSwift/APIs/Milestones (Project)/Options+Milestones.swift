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
    
    public class EditMilestone: CreateMilestone {
        
        /// The ID of the project’s milestone.
        @APIOption(key: "milestone_id", location: .parameterInQueryURL)
        public var milestoneId: String?
        
        /// The state event of the milestone (`close` or `activate`).
        @APIOption(key: "state_event")
        public var stateEvent: DataTypes.MilestoneEditState?
     
        public init(milestoneId: String, projectID: DataTypes.ProjectID, _ configure: ((EditMilestone) -> Void)?) {
            super.init(projectID: projectID, nil)
            self.milestoneId = milestoneId
            configure?(self)
        }
        
    }
        
    public class CreateMilestone: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var projectID: DataTypes.ProjectID?
        
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
     
        public init(projectID: DataTypes.ProjectID, title: String? = nil, _ configure: ((CreateMilestone) -> Void)?) {
            super.init()
            self.title = title
            self.projectID = projectID
            configure?(self)
        }
        
    }
    
    public class ListMilestones: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project.
        @APIOption(key: "id")
        public var projectID: DataTypes.ProjectID?
        
        /// Return only the milestones having the given iid.
        @APIOption(key: "iids") public var iids: [Int]?
        
        /// Return only active or closed milestones.
        @APIOption(key: "state") public var state: DataTypes.MilestoneState?
        
        /// Return only the milestones having the given title.
        @APIOption(key: "title") public var title: String?
        
        /// Return only milestones with a title or description matching the provided string.
        @APIOption(key: "search") public var search: String?
        
        /// Include group milestones from parent group and its ancestors.
        @APIOption(key: "include_parent_milestones") public var includeParent: Bool?
        
        public init(_ configure: ((ListMilestones) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
}
