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
    
    public class EditLabel: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @APIOption(key: "id") public var projectID: DataTypes.ProjectID?

        /// The ID or title of a group’s label.
        @APIOption(key: "label_id") public var labelId: String?
        
        /// The new name of the label (required if color is not provided).
        @APIOption(key: "new_name") public var newName: String?
        
        /// The color of the label given in 6-digit hex notation with leading ‘#’ sign
        /// (for example, #FFAABB) or one of the CSS color names.
        /// (Required if `newName` is not provided).
        @APIOption(key: "color") public var color: String?
        
        /// The description of the label
        @APIOption(key: "description") public var description: String?

        /// The priority of the label. Must be greater or equal
        /// than zero or null to remove the priority.
        @APIOption(key: "priority") public var priority: Int?

        public init(id: String, project: DataTypes.ProjectID,
                    _ configure: ((EditLabel) -> Void)?) {
            super.init()
            configure?(self)
            self.projectID = project
            self.labelId = id
        }
        
    }
    
    public class CreateLabel: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @APIOption(key: "id") public var projectID: DataTypes.ProjectID?

        /// The name of the label.
        @APIOption(key: "name") public var name: String?
        
        /// The color of the label given in 6-digit hex notation with leading ‘#’ sign
        /// (for example, #FFAABB) or one of the CSS color names.
        @APIOption(key: "color") public var color: String?
        
        /// The description of the label
        @APIOption(key: "description") public var description: String?

        /// The priority of the label. Must be greater or equal
        /// than zero or null to remove the priority.
        @APIOption(key: "priority") public var priority: Int?

        public init(name: String, color: String,
                    project: DataTypes.ProjectID,
                    _ configure: ((CreateLabel) -> Void)?) {
            super.init()
            configure?(self)
            self.projectID = project
            self.color = color
            self.name = name
        }
        
    }
    
    public class ListLabels: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @APIOption(key: "id") public var projectID: DataTypes.ProjectID?

        /// Whether or not to include issue and merge request counts.
        @APIOption(key: "with_counts") public var withCounts: Bool?
        
        /// Include ancestor groups.
        @APIOption(key: "include_ancestor_groups") public var ancestorGroups: Bool?
        
        /// Keyword to filter labels by.
        @APIOption(key: "search") public var search: String?

        public init(_ configure: ((ListLabels) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
