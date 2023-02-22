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

extension APIService {
    
    public class Users: APIService {
        
        /// Search for user with passed configuration.
        ///
        /// - Parameter configure: configuration callback.
        /// - Returns: found users.
        public func search(_ callback: @escaping ((APIOptions.SearchUsers) -> Void)) async throws -> GitLabResponse<[Model.User]> {
            let options = APIOptions.SearchUsers(callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.users, options: options))
        }
        
        /// Search user by a given iid.
        ///
        /// - Parameter id: id of the user.
        /// - Returns: found user, if any.
        public func user(id: Int) async throws -> GitLabResponse<Model.User> {
            let options = APIOptionsCollection([
                APIOption(key: "id", id)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.userFromId, options: options))
        }
        
        /// Get the currently authenticated user.
        ///
        /// - Returns: this user.
        public func me() async throws -> GitLabResponse<Model.User> {
            return try await gitlab.execute(.init(endpoint: Endpoints.user))
        }
        
    }
    
}
