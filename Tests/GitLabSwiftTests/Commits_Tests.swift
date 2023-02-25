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
import XCTest
@testable import GitLabSwift
import RealHTTP

final class GitLabSwift_CommitsTests: XCTestCase {
    
    private var anyProjectID: InputParams.Project!
    
    override func setUp() async throws {
        let project = try await gitlab.projects.list().model()?.randomElement()
        XCTAssertNotNil(project)
        self.anyProjectID = .id(project!.id)
        self.anyProjectID = .id(1097)
    }
    
    public func test_projectCommits() async throws {
        let result = await catchErrors {
            let response = try await gitlab.commits.list(project: anyProjectID, options: {
                $0.since = Date().addingTimeInterval(-60*60*24*5)
                $0.until = Date()
                $0.includeStats = true
            })
            response.writeRawResponse("commits")
            guard let commits = try response.model() else {
                XCTFail()
                return
            }
            
            print("Found \(response.totalItems ?? 0) commits")
            for commit in commits {
                print("  - \(commit.short_id) by \(commit.author_name ?? "") on \(commit.created_at.description)")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_singleCommit() async throws {
        let result = await catchErrors {
            let anyCommit = try await gitlab.commits.list(project: anyProjectID).model()?.randomElement()
            let response = try await gitlab.commits.get(sha: anyCommit!.short_id, project: anyProjectID)
            response.writeRawResponse("commit")
            guard let commitInfo = try response.model() else {
                XCTFail()
                return
            }
            
            print(commitInfo)
        }
        XCTAssertTrue(result)
    }
    
    public func test_commitDiff() async throws {
        let result = await catchErrors {
            let anyCommit = try await gitlab.commits.list(project: anyProjectID).model()?.randomElement()
            let response = try await gitlab.commits.diff(sha: anyCommit!.short_id, project: anyProjectID)
            response.writeRawResponse("diff")
            guard let commitDiffs = try response.model() else {
                XCTFail()
                return
            }
            
            print(commitDiffs)
        }
        XCTAssertTrue(result)
    }
    
    public func test_commitComments() async throws {
        let result = await catchErrors {
            let anyCommit = try await gitlab.commits.list(project: anyProjectID).model()?.randomElement()
            let response = try await gitlab.commits.comments(sha: /*anyCommit!.short_id*/ "98ce87a2", project: anyProjectID)
            guard let comments = try response.model() else {
                XCTFail()
                return
            }
            
            print("Commit \(anyCommit!.short_id) has \(response.totalItems ?? 0) notes")
            print(comments)
        }
        XCTAssertTrue(result)
    }

    public func test_postComment() async throws {
        let result = await catchErrors {
            let response = try await gitlab.commits.postComment(sha: "98ce87a2", project: anyProjectID, options: {
                $0.note = "note"
                $0.path = "Frameworks/IndomioControls/Sources/IndomioControls/Classes/Indomio/UI Controllers/Visit/Views/Controller/Styles/VisitDaysController+Style.swift"
                $0.line = 47
                $0.line_type = .new
            })
            response.writeRawResponse("post_comment")
            guard let postedComment = try response.model() else {
                XCTFail()
                return
            }
            
            print(postedComment)
        }
        XCTAssertTrue(result)
    }
    
    public func test_discussions() async throws {
        let result = await catchErrors {
            let response = try await gitlab.commits.discussions(sha: "b5c08ac015c53a76ef747652c2eb04d12c11ac07", project: anyProjectID)
            guard let discussions = try response.model() else {
                XCTFail()
                return
            }
            
            print("Found \(response.totalItems ?? 0) discussions")
            print(discussions)
        }
        XCTAssertTrue(result)
    }
    
    public func test_statuses() async throws {
        let result = await catchErrors {
            let response = try await gitlab.commits.statuses(sha: "b5c08ac015c53a76ef747652c2eb04d12c11ac07", project: anyProjectID)
            response.writeRawResponse("statuses")
            guard let statuses = try response.model() else {
                XCTFail()
                return
            }
            
            print("Found \(response.totalItems ?? 0) statuses")
            print(statuses)
        }
        XCTAssertTrue(result)
    }
    
    public func test_mergeRequestsLinkedWithCommit() async throws {
        let result = await catchErrors {
            let response = try await gitlab.commits.mergeRequests(sha: "b5c08ac015c53a76ef747652c2eb04d12c11ac07", project: anyProjectID)
            response.writeRawResponse("mrs")
            guard let mrs = try response.model() else {
                XCTFail()
                return
            }
            
            print("Found \(response.totalItems ?? 0) MRs")
            print(mrs)
        }
        XCTAssertTrue(result)
    }
    
    public func test_commitGPGSignature() async throws {
        let result = await catchErrors {
            let response = try await gitlab.commits.gpgSignature(sha: "b5c08ac015c53a76ef747652c2eb04d12c11ac07", project: anyProjectID)
            response.writeRawResponse("gpg")
            guard let signature = try response.model() else {
                XCTFail()
                return
            }
            
            print(signature)
        }
        XCTAssertTrue(result)
    }
    
}
