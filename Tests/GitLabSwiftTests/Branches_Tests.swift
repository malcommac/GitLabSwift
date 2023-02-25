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

final class GitLabSwift_BranchesTests: XCTestCase {
    
    private var anyProjectID: InputParams.Project!
    
    override func setUp() async throws {
      //  let project = try await gitlab.projects.all().model()?.randomElement()
      //  XCTAssertNotNil(project)
      //  self.anyProjectID = .id(project!.id)
        self.anyProjectID = .id(1097)
    }
    
    public func test_branchesOfProject() async throws {
        let result = await catchErrors {
            let response = try await gitlab.branches.list(project: anyProjectID)
            guard let branches = try response.model() else {
                XCTFail()
                return
            }
            
            print("There are \(response.totalItems ?? 0) branches in \(response.totalPages) pages for project id: \(anyProjectID.description)")
            print("Printing first page:")
            for branch in branches {
                print("  - \(branch.name.trunc(30)) (Commit: \(branch.commit.short_id) by \(branch.commit.committer_name ?? "-")")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_branchInProject() async throws {
        let result = await catchErrors {
            let anyBranch = try await gitlab.branches.list(project: anyProjectID).model()?.randomElement()
            XCTAssertNotNil(anyBranch)
            print("Getting info about branch: '\(anyBranch!.name)' of project id: \(anyProjectID.description)...")
            let response = try await gitlab.branches.get(anyBranch!.name, project: anyProjectID)
            guard let branch = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(branch)
            print(branch)
        }
        XCTAssertTrue(result)
    }
    
    
    public func test_protectedBranches() async throws {
        let result = await catchErrors {
            let response = try await gitlab.protectedBranches.list(project: anyProjectID)
            XCTAssertNotNil(response)
            guard let protectedBranches = try response.model() else {
                XCTFail()
                return
            }
            
            XCTAssertNotNil(protectedBranches)
            print("Listing \(protectedBranches.count) protected branches (\(response.totalItems ?? 0) total)")
            for branch in protectedBranches {
                print("  - \(branch.name) (\(branch.push_access_levels.map({ "\($0.access_level_description)" }).joined(separator: ",")))")
            }
        }
        XCTAssertTrue(result)
    }
    
    public func test_getProtectedBranch() async throws {
        let result = await catchErrors {
            guard let anyBranch = try await gitlab.protectedBranches.list(project: self.anyProjectID).model()?.randomElement() else {
                XCTFail()
                return
            }
            
            print("Getting details for protected branch named \(anyBranch.name) in project \(anyProjectID.description)")
            let response = try await gitlab.protectedBranches.get(anyBranch.name, project: anyProjectID)
            response.writeRawResponse("detail_protected")
            guard let protectedBranch = try response.model() else {
                XCTFail()
                return
            }
            
            print(protectedBranch)
        }
        XCTAssertTrue(result)
    }
    
    public func test_protectBranch() async throws {
        let result = await catchErrors {
            let branchName: String? = "new/1-supporto-export-metro"
            guard let branchName else {
                return
            }
            
            let response = try await gitlab.protectedBranches.protect(branchName, project: .id(1183), options: {
                $0.mergeAccessLevel = .maintainer
                $0.allowForcePush = true
                $0.codeOwnerApprovalRequired = false
            })
            
            response.writeRawResponse("protect_action")
            guard let protectedBranch = try response.model() else {
                XCTFail()
                return
            }
            
            print(protectedBranch)
        }
        XCTAssertTrue(result)
    }
    
    public func test_unprotectBranch() async throws {
        let result = await catchErrors {
            let branchName: String? = "new/1-supporto-export-metro"
            guard let branchName else {
                return
            }
            
            let response = try await gitlab.protectedBranches.unprotect(branchName, project: .id(1183))
            response.writeRawResponse("unprotect_action")
        }
        XCTAssertTrue(result)
    }
    
    public func test_createAndDeleteBranch() async throws {
        let result = await catchErrors {
            let branchName = "feature/testbranch"
            let sourceBranch = "main"
            let respCreate = try await gitlab.branches.create(name: branchName,
                                                              fromRef: sourceBranch,
                                                              project: .id(2008))
            respCreate.writeRawResponse("create_branch")
           
            // delete branch
            let respDel = try await gitlab.branches.delete(name: branchName, project: .id(2008))
            respDel.writeRawResponse("delete_branch")
        }
        XCTAssertTrue(result)
    }
    
    public func test_deleteMergedBranches() async throws {
        let result = await catchErrors {
            let response = try await gitlab.branches.deleteMergedBranches(project: .id(2008))
            response.writeRawResponse("delete_merged_branches")
        }
        XCTAssertTrue(result)
    }
    
    
}
