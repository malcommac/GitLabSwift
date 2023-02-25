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

final class GitLabSwift_IssuesTests: XCTestCase {
    
    public func test_list() async throws {
        let result = await catchErrors {
            let response = try await gitlab.issues.list(options: {
                //$0.authorUsername = "margutti"
                //$0.assigneeUsernames = ["margutti","durso"]
                $0.sort = .desc
                $0.confidential = false
                // $0.iids = [3080,3067]
            })
            guard let issues = try response.decode() else {
                XCTFail()
                return
            }
            
            print(issues.count)
        }
        XCTAssertTrue(result)
    }
    
    public func test_getIssue() async throws {
        let result = await catchErrors {
            let response = try await gitlab.issues.get(issue: 3080, project: .id(1097))
            guard let issue = try response.decode() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(issue)
            print(issue)
        }
        XCTAssertTrue(result)
    }
    
}
