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

extension APIService.GroupLabels {
    
    public class ListOptions: OutputParamsCollection {
        
        /// Whether or not to include issue and merge request counts.
        @OutputParam(key: "with_counts")
        public var withCounts: Bool?
        
        /// Include ancestor groups.
        @OutputParam(key: "include_ancestor_groups")
        public var includeAncestorGroups: Bool?
        
        /// Include descendant groups.
        @OutputParam(key: "include_descendant_groups")
        public var includeDescendantGroups: Bool?
        
        /// Toggle to include only group labels or also project labels.
        @OutputParam(key: "only_group_labels")
        public var onlyGroupLabels: Bool?
        
        /// Keyword to filter labels by.
        @OutputParam(key: "search")
        public var search: String?
        
        // MARK: - Initialization
        
        public init( _ configure: ((ListOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    

}
