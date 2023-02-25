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

// MARK: - Users + URLs

extension APIs.Users {
    
    public enum URLs: String, GLEndpoint {
        case userFromId = "/users/{id}"
        case users = "/users"
        case user = "/user"
        case userStatus = "/user/status"
        
        public var value: String { rawValue }
    }
}

// MARK: - Users + APIs

extension APIs {
    
    /// Users API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/users.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/users.html#user-creation
    /// - https://docs.gitlab.com/ee/api/users.html#user-modification
    /// - https://docs.gitlab.com/ee/api/users.html#delete-authentication-identity-from-user
    /// - https://docs.gitlab.com/ee/api/users.html#user-deletion
    /// - https://docs.gitlab.com/ee/api/users.html#user-status
    /// - https://docs.gitlab.com/ee/api/users.html#get-the-status-of-a-user
    /// - https://docs.gitlab.com/ee/api/users.html#set-user-status
    /// - https://docs.gitlab.com/ee/api/users.html#get-user-preferences
    /// - https://docs.gitlab.com/ee/api/users.html#user-preference-modification
    /// - https://docs.gitlab.com/ee/api/users.html#user-follow
    /// - https://docs.gitlab.com/ee/api/users.html#followers-and-following
    /// - https://docs.gitlab.com/ee/api/users.html#user-counts
    /// - https://docs.gitlab.com/ee/api/users.html#list-user-projects
    /// - https://docs.gitlab.com/ee/api/users.html#list-associations-count-for-user
    /// - https://docs.gitlab.com/ee/api/users.html#list-ssh-keys
    /// - https://docs.gitlab.com/ee/api/users.html#list-ssh-keys-for-user
    /// - https://docs.gitlab.com/ee/api/users.html#single-ssh-key
    /// - https://docs.gitlab.com/ee/api/users.html#single-ssh-key-for-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#add-ssh-key
    /// - https://docs.gitlab.com/ee/api/users.html#add-ssh-key-for-user
    /// - https://docs.gitlab.com/ee/api/users.html#delete-ssh-key-for-current-user
    /// - https://docs.gitlab.com/ee/api/users.html#delete-ssh-key-for-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#list-all-gpg-keys
    /// - https://docs.gitlab.com/ee/api/users.html#get-a-specific-gpg-key
    /// - https://docs.gitlab.com/ee/api/users.html#add-a-gpg-key
    /// - https://docs.gitlab.com/ee/api/users.html#delete-a-gpg-key
    /// - https://docs.gitlab.com/ee/api/users.html#list-all-gpg-keys-for-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#get-a-specific-gpg-key-for-a-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#add-a-gpg-key-for-a-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#delete-a-gpg-key-for-a-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#list-emails
    /// - https://docs.gitlab.com/ee/api/users.html#list-emails-for-user
    /// - https://docs.gitlab.com/ee/api/users.html#single-email
    /// - https://docs.gitlab.com/ee/api/users.html#add-email
    /// - https://docs.gitlab.com/ee/api/users.html#add-email-for-user
    /// - https://docs.gitlab.com/ee/api/users.html#delete-email-for-current-user
    /// - https://docs.gitlab.com/ee/api/users.html#delete-email-for-given-user
    /// - https://docs.gitlab.com/ee/api/users.html#block-user
    /// - https://docs.gitlab.com/ee/api/users.html#unblock-user
    /// - https://docs.gitlab.com/ee/api/users.html#deactivate-user
    /// - https://docs.gitlab.com/ee/api/users.html#activate-user
    /// - https://docs.gitlab.com/ee/api/users.html#ban-user
    /// - https://docs.gitlab.com/ee/api/users.html#unban-user
    /// - https://docs.gitlab.com/ee/api/users.html#get-user-contribution-events
    /// - https://docs.gitlab.com/ee/api/users.html#get-all-impersonation-tokens-of-a-user
    /// - https://docs.gitlab.com/ee/api/users.html#approve-user
    /// - https://docs.gitlab.com/ee/api/users.html#reject-user
    /// - https://docs.gitlab.com/ee/api/users.html#get-an-impersonation-token-of-a-user
    /// - https://docs.gitlab.com/ee/api/users.html#create-an-impersonation-token
    /// - https://docs.gitlab.com/ee/api/users.html#revoke-an-impersonation-token
    /// - https://docs.gitlab.com/ee/api/users.html#create-a-personal-access-token
    /// - https://docs.gitlab.com/ee/api/users.html#get-user-activities
    /// - https://docs.gitlab.com/ee/api/users.html#user-memberships
    /// - https://docs.gitlab.com/ee/api/users.html#disable-two-factor-authentication
    public class Users: APIs {
        
        /// Search for user with passed configuration.
        ///
        /// - Parameter options: configuration callback.
        /// - Returns: found users.
        public func search(options: @escaping ((SearchOptions) -> Void)) async throws -> GLResponse<[GLModel.User]> {
            let options = SearchOptions(options)
            return try await gitlab.execute(.init(endpoint: URLs.users, options: options))
        }
        
        /// Search user by a given iid.
        ///
        /// - Parameter id: id of the user.
        /// - Returns: found user, if any.
        public func user(_ id: Int) async throws -> GLResponse<GLModel.User> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", id)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.userFromId, options: options))
        }
        
        /// Get the currently authenticated user.
        ///
        /// - Returns: this user.
        public func me() async throws -> GLResponse<GLModel.User> {
            return try await gitlab.execute(.init(endpoint: URLs.user))
        }
        
    }
    
}
