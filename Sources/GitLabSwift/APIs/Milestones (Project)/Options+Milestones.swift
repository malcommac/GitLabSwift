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
        @OutputParam(key: "milestone_id", location: .parameterInQueryURL)
        public var milestone: String?
        
        /// The state event of the milestone (`close` or `activate`).
        @OutputParam(key: "state_event")
        public var stateEvent: InputParams.MilestoneEditState?
     
        public init(milestone: String,
                    project: InputParams.Project,
                    _ configure: ((EditOptions) -> Void)?) {
            super.init(project: project, nil)
            self.milestone = milestone
            configure?(self)
        }
        
    }
        
    public class CreateOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// The title of a milestone.
        @OutputParam(key: "title")
        public var title: String?
        
        /// The description of the milestone.
        @OutputParam(key: "description")
        public var description: String?
        
        /// The due date of the milestone (YYYYMMDD).
        @OutputParam(key: "start_date")
        public var startDate: InputParams.DateOnly?
        
        /// The start date of the milestone (YYYYMMDD)
        @OutputParam(key: "due_date")
        public var dueDate: InputParams.DateOnly?
     
        public init(project: InputParams.Project,
                    title: String? = nil,
                    _ configure: ((CreateOptions) -> Void)?) {
            super.init()
            self.title = title
            self.project = project
            configure?(self)
        }
        
    }
    
    public class ListOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project.
        @OutputParam(key: "id")
        public var project: InputParams.Project?
        
        /// Return only the milestones having the given iid.
        @OutputParam(key: "iids")
        public var iids: [Int]?
        
        /// Return only active or closed milestones.
        @OutputParam(key: "state")
        public var state: InputParams.MilestoneState?
        
        /// Return only the milestones having the given title.
        @OutputParam(key: "title")
        public var title: String?
        
        /// Return only milestones with a title or description matching the provided string.
        @OutputParam(key: "search")
        public var search: String?
        
        /// Include group milestones from parent group and its ancestors.
        @OutputParam(key: "include_parent_milestones")
        public var includeParent: Bool?
        
        public init(project: InputParams.Project,
                    _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
}
