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

final class GitLabSwift_MilestonesTests: XCTestCase {
    
    public func test_milestones() async throws {
        let result = await catchErrors {
            let response = try await gitlab.milestones.list(id: .id(1097), {
                $0.includeParent = true
                $0.state = .activate
            })
            response.writeRawResponse("allmr")
            guard let activeMilestones = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(activeMilestones)
            print("Listing \(activeMilestones.count) of \(response.totalItems ?? 0) milestone active:")
            for milestone in activeMilestones {
                print("  - \(milestone.id) - '\(milestone.title ?? "-")'")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_milestoneDetails() async throws {
        let result = await catchErrors {
            let response = try await gitlab.milestones.detail(id: 585, project: .id(1097))
            response.writeRawResponse("single_mr")
            guard let milestone = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(milestone)
            print(milestone)
        }
        XCTAssertTrue(result)
    }
    
    public func test_milestoneLinkedIssues() async throws {
        let result = await catchErrors {
            let response = try await gitlab.milestones.issues(id: 585, project: .id(1097))
            response.writeRawResponse("issues_milestone")
            guard let issues = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(issues)
            print("Listing \(issues.count) of \(response.totalItems ?? 0) issues linked with milestone:")
            for issue in issues {
                print("  - \(issue.id) - '\(issue.title ?? "-")'")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_milestoneLinkedMergeRequests() async throws {
        let result = await catchErrors {
            let response = try await gitlab.milestones.mergeRequests(id: 585, project: .id(1097))
            response.writeRawResponse("issues_milestone")
            guard let mrList = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(mrList)
            print("Listing \(mrList.count) of \(response.totalItems ?? 0) MRs linked with milestone:")
            for mr in mrList {
                print("  - \(mr.id) - '\(mr.title ?? "-")'")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_createMilestone() async throws {
        let result = await catchErrors {
            let response = try await gitlab.milestones.create(title: "My Milestone", project: .id(2008), {
                $0.description = "A new fantastic milestone"
                $0.startDate = .init(date: Date(timeIntervalSinceNow: -60*60*24*7))
                $0.dueDate = .init(date: Date(timeIntervalSinceNow: 60*60*24*2))
            })
            response.writeRawResponse("create_milestone")
            guard let milestone = try response.model() else {
                XCTFail()
                return
            }
            
            print("Created new milestone IID: \(milestone.iid) named: \"\(milestone.title ?? "")\"")
            print(milestone)
        }
        XCTAssertTrue(result)
    }
    
    public func test_editMilestone() async throws {
        let result = await catchErrors {
            guard let anyMilestone = try await gitlab.milestones.list(id: .id(2008)).model()?.first else {
                return
            }
            
            let response = try await gitlab.milestones.edit(id: String(anyMilestone.id), project: .id(2008), {
                $0.description = "Modified description"
                $0.title = "Modified title"
            })
            
            response.writeRawResponse("modified_milestone")
            guard let milestone = try response.model() else {
                XCTFail()
                return
            }

            print(milestone)
        }
        XCTAssertTrue(result)
    }
    
}