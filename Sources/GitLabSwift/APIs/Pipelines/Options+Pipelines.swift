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
    
    public class SearchOptions: OutputParamsCollection {
        
        /// The ID or URL-encoded path of the project owned by the authenticated user
        @OutputParam(key: "id")
        public var project: InputParams.ProjectID?
        
        /// The scope of pipelines.
        @OutputParam(key: "scope")
        public var scope: InputParams.MilestoneScope?
        
        // The status of pipelines
        @OutputParam(key: "status")
        public var status: InputParams.PipelineStatus?
        
        /// How the pipeline was triggered.
        @OutputParam(key: "source")
        public var source: InputParams.PipelineSource?
        
        /// The ref of pipelines.
        @OutputParam(key: "ref")
        public var ref: String?
        
        /// The SHA of pipelines
        @OutputParam(key: "sha")
        public var sha: String?
        
        @OutputParam(key: "yaml_errors")
        public var yamlErrors: Bool?
        
        /// The username of the user who triggered pipelines.
        @OutputParam(key: "username")
        public var username: String?
        
        /// Return pipelines updated after the specified date.
        @OutputParam(key: "updated_after")
        public var updatedAfter: Date?
        
        /// Return pipelines updated before the specified date.
        @OutputParam(key: "updated_before")
        public var updatedBefore: Date?
        
        /// Order pipelines by.
        @OutputParam(key: "order_by")
        public var order: InputParams.PipelineOrder?
        
        /// Sort pipelines.
        @OutputParam(key: "sort_by")
        public var sort: InputParams.Sort?

        public init(project: InputParams.ProjectID,
                    _ configure: ((SearchOptions) -> Void)?) {
            super.init()
            self.project = project
            configure?(self)
        }
        
    }
    
}
