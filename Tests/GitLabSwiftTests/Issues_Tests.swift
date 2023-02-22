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
            let response = try await gitlab.issues.list({
                //$0.authorUsername = "margutti"
                //$0.assigneeUsernames = ["margutti","durso"]
                $0.sort = .desc
                $0.confidential = false
                // $0.iids = [3080,3067]
            })
            response.writeRawResponse("issues_list")
            guard let issues = try response.model() else {
                XCTFail()
                return
            }
            
            print(issues.count)
        }
        XCTAssertTrue(result)
    }
    
    public func test_getIssue() async throws {
        let result = await catchErrors {
            let response = try await gitlab.issues.get(3080, inProject: .id(1097))
            response.writeRawResponse("single_issue")
            guard let issue = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(issue)
            print(issue)
        }
        XCTAssertTrue(result)
    }
    
}
