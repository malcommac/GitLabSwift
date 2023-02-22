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
    
    public class ListGroupsLabels: APIOptionsCollection {
        
        /// Whether or not to include issue and merge request counts.
        @APIOption(key: "with_counts") public var withCounts: Bool?
        
        /// Include ancestor groups.
        @APIOption(key: "include_ancestor_groups") public var includeAncestorGroups: Bool?
        
        /// Include descendant groups.
        @APIOption(key: "include_descendant_groups") public var includeDescendantGroups: Bool?
        
        /// Toggle to include only group labels or also project labels.
        @APIOption(key: "only_group_labels") public var onlyGroupLabels: Bool?
        
        /// Keyword to filter labels by.
        @APIOption(key: "search") public var search: String?
        
        // MARK: - Initialization
        
        public init( _ configure: ((ListGroupsLabels) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    

}
