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

extension APIService.Users {
    
    public class SearchOptions: APIOptionsCollection {
        
        /// Search for users by name, username, or public email.
        @APIOption(key: "search")
        public var search: String?

        /// Lookup users by username.
        @APIOption(key: "username")
        public var searchByUsername: String?
        
        /// Lookup users by external UID and provider:
        @APIOption(key: "extern_uid")
        public var searchByExternUID: String?
        
        /// Filter users based on the `active` state.
        @APIOption(key: "active")
        public var onlyActive: String?

        /// You can search for external users only.
        @APIOption(key: "external")
        public var onlyExternal: String?
        
        /// Return only administrators. By default it returns all users.
        @APIOption(key: "admins")
        public var onlyAdmins: Bool?
        
        /// Filter users without projects.
        /// Default is `false`, which means that all users are returned, with and without projects.
        @APIOption(key: "without_projects")
        public var withoutProjects: Bool?
        
        /// Filter users by Two-factor authentication.
        /// By default it returns all users.
        @APIOption(key: "two_factor")
        public var twoFactor: DataTypes.Flag?

        /// Filter users by Two-factor authentication.
        /// By default it returns all users.
        @APIOption(key: "sort")
        public var sort: DataTypes.Sort?
        
        /// Return users ordered by type. Default is `id`.
        @APIOption(key: "order_by")
        public var orderBy: DataTypes.UsersOrder?

        /// Return only users created by the specified SAML provider ID.
        /// If not included, it returns all users.
        @APIOption(key: "saml_provider_id")
        public var samlProviderId: Int?
        
        public init(_ configure: ((SearchOptions) -> Void)?) {
            super.init()
            configure?(self)
        }
        
    }
    
}
