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

extension APIService.Pipelines {
    
    public class SearchOptions: APIOptionsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @APIOption(key: "id")
        public var project: DataTypes.ProjectID?
        
        /// The scope of pipelines.
        @APIOption(key: "scope")
        public var scope: DataTypes.MilestoneScope?
        
        // The status of pipelines
        @APIOption(key: "status")
        public var status: DataTypes.PipelineStatus?
        
        /// How the pipeline was triggered.
        @APIOption(key: "source")
        public var source: DataTypes.PipelineSource?
        
        /// The ref of pipelines.
        @APIOption(key: "ref")
        public var ref: String?
        
        /// The SHA of pipelines
        @APIOption(key: "sha")
        public var sha: String?
        
        @APIOption(key: "yaml_errors")
        public var yamlErrors: Bool?
        
        /// The username of the user who triggered pipelines.
        @APIOption(key: "username")
        public var username: String?
        
        /// Return pipelines updated after the specified date.
        @APIOption(key: "updated_after")
        public var updatedAfter: Date?
        
        /// Return pipelines updated before the specified date.
        @APIOption(key: "updated_before")
        public var updatedBefore: Date?
        
        /// Order pipelines by.
        @APIOption(key: "order_by")
        public var order: DataTypes.PipelineOrder?
        
        /// Sort pipelines.
        @APIOption(key: "sort_by")
        public var sort: DataTypes.Sort?

        public init(project: DataTypes.ProjectID,
                    _ configure: ((SearchOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
