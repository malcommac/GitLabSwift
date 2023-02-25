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

final class GitLabSwift_DiscussionsTests: XCTestCase {
    
    public func test_list() async throws {
        let result = await catchErrors {
            let response = try await gitlab.discussions.list(
                issue: 3010,
                project: .id(1097)
            )
            guard let discussions = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(discussions)
            print(discussions)
        }
        XCTAssertTrue(result)
    }
    
    public func test_detail() async throws {
        let result = await catchErrors {
            let response = try await gitlab.discussions.get(
                discussion: "2d2b6632ccb10913fdf6e220eca765712511e9c1",
                issue: 3010,
                project: .id(1097)
            )
            guard let discussion = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(discussion)
            print(discussion)
        }
        XCTAssertTrue(result)
    }
    
    public func test_createThread() async throws {
        let result = await catchErrors {
            let response = try await gitlab.discussions.create(issue: 3010, body: "New thread message", project: .id(1097))
            guard let discussion = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(discussion)
            print(discussion)
        }
        XCTAssertTrue(result)
    }
    
    public func test_listSnippetDiscussions() async throws {
        let result = await catchErrors {
            let response = try await gitlab.discussions.list(snippet: 372, project: .id(2008))
            guard let discussion = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(discussion)
            print(discussion)
        }
        XCTAssertTrue(result)
    }
    
    public func test_getSnippetDiscussionItem() async throws {
        let result = await catchErrors {
            let response = try await gitlab.discussions.get(discussion: "584630", issue: 372, project: .id(2008))
            guard let discussion = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(discussion)
            print(discussion)
        }
        XCTAssertTrue(result)
    }
    
}
