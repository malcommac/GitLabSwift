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

import XCTest
@testable import GitLabSwift
import RealHTTP

final class GitLabSwift_UsersTests: XCTestCase {

    public func test_me() async throws {
        let result = await catchErrors {
            let response = try await gitlab.users.me()
            guard let userProfile = try response.decode() else {
                XCTFail()
                return
            }
            
            print("Welcome \(userProfile.name)")
            XCTAssertNotNil(userProfile.email)
            XCTAssertNotNil(userProfile.id)
            XCTAssertNotNil(userProfile.username)
        }
        XCTAssertTrue(result)
    }
    
    public func test_userById() async throws {
        let result = await catchErrors {
            let meUser = try await gitlab.users.me().decode()
            let response = try await gitlab.users.user(meUser!.id)
            guard let foundUser = try response.decode() else {
                XCTFail()
                return
            }
            
            print("User with ID \(meUser!.id) is: \(foundUser.username)")
            XCTAssertNotNil(foundUser.username)
            XCTAssertNotNil(foundUser.id)
        }
        XCTAssertTrue(result)
    }
    
    public func test_searchUser() async throws {
        let searchTerm = "mario"
        
        let result = await catchErrors {
            let response = try await gitlab.users.search(options: {
                $0.orderBy = .id
                $0.search = searchTerm
            })
            
            guard let foundUsers = try response.decode() else {
                XCTFail()
                return
            }
            
            print("Found \(foundUsers.count) users with name contains '\(searchTerm)': \(foundUsers.map({ "\($0.id)" }).joined(separator: ","))")
            XCTAssertNotNil(foundUsers)
        }
        XCTAssertTrue(result)
    }


}
