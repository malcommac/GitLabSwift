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

extension APIService.Labels {
    
    public class EditOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?

        /// The ID or title of a group’s label.
        @OutputParam(key: "label_id")
        public var label: String?
        
        /// The new name of the label (required if color is not provided).
        @OutputParam(key: "new_name")
        public var newName: String?
        
        /// The color of the label given in 6-digit hex notation with leading ‘#’ sign
        /// (for example, #FFAABB) or one of the CSS color names.
        /// (Required if `newName` is not provided).
        @OutputParam(key: "color")
        public var color: String?
        
        /// The description of the label
        @OutputParam(key: "description")
        public var description: String?

        /// The priority of the label. Must be greater or equal
        /// than zero or null to remove the priority.
        @OutputParam(key: "priority")
        public var priority: Int?

        public init(label: String,
                    project: InputParams.ProjectID,
                    _ configure: ((EditOptions) -> Void)?) {
            super.init()
            configure?(self)
            self.project = project
            self.label = label
        }
        
    }
    
    public class CreateOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?

        /// The name of the label.
        @OutputParam(key: "name")
        public var name: String?
        
        /// The color of the label given in 6-digit hex notation with leading ‘#’ sign
        /// (for example, #FFAABB) or one of the CSS color names.
        @OutputParam(key: "color")
        public var color: String?
        
        /// The description of the label
        @OutputParam(key: "description")
        public var description: String?

        /// The priority of the label. Must be greater or equal
        /// than zero or null to remove the priority.
        @OutputParam(key: "priority")
        public var priority: Int?

        public init(name: String,
                    color: String,
                    project: InputParams.ProjectID,
                    _ configure: ((CreateOptions) -> Void)?) {
            super.init()
            configure?(self)
            self.project = project
            self.color = color
            self.name = name
        }
        
    }
    
    public class ListOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?

        /// Whether or not to include issue and merge request counts.
        @OutputParam(key: "with_counts")
        public var withCounts: Bool?
        
        /// Include ancestor groups.
        @OutputParam(key: "include_ancestor_groups")
        public var ancestorGroups: Bool?
        
        /// Keyword to filter labels by.
        @OutputParam(key: "search")
        public var search: String?

        public init(project: InputParams.ProjectID,
                    _ configure: ((ListOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
