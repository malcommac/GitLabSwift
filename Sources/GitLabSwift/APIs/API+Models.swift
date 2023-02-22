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

public enum Model { }

public extension Model {
    
    struct NoResponse: Codable { }
        
    struct Repository: Decodable {
        
        public struct Tree: Decodable {
            public let id: String
            public let name: String
            public let type: String
            public let path: String
            public let mode: String
        }
        
    }
    
    struct FileBlame: Decodable {
        public let commit: Commit
        public let lines: [String]
    }
    
    struct Avatar: Decodable {
        public let avatar_url: String
    }
    
    struct Tag: Decodable {
        public let name: String
        public let target: String?
        public let message: String?
        public let protected: Bool
        public let commit: Commit
        public let release: Release?
        
        public struct Release: Decodable {
            public let tag_name: String
            public let description: String?
        }
    }

    struct File: Decodable {
        public let file_name: String
        public let file_path: String
        public let size: Int
        public let encoding: String
        public let content: String
        public let content_sha256: String?
        public let ref: String
        public let blob_id: String
        public let commit_id: String
        public let last_commit_id: String
        public let execute_filemode: Bool?
    }
    
    struct Job: Decodable {
        public let commit: Commit?
        public let coverage: String?
        public let allows_failure: Bool?
        public let created_at: Date?
        public let started_at: Date?
        public let finished_at: Date?
        public let erased_at: Date?
        public let duration: Double?
        public let queued_duration: Double?
        public let artifact_file: JobArtifact?
        public let artifacts: [JobArtifact]
        public let artifacts_expire_at: Date?
        public let tag_list: [String]?
        public let id: Int
        public let name: String?
        public let pipeline: Pipeline?
        public let ref: String?
        public let stage: String?
        public let status: String?
        public let failure_reason: String?
        public let tag: Bool?
        public let web_url: URL?
        public let user: User?
    }
    
    struct JobArtifact: Decodable {
        public let file_type: String?
        public let size: UInt
        public let filename: String
        public let file_format: String?
    }
    
    struct UserAgentDetail: Decodable {
        public let user_agent: String
        public let ip_address: String
        public let akismet_submitted: Bool?
    }
    
    struct UploadedFile: Codable {
        public let alt: String?
        public let url: String
        public let full_path: String
        public let markdown: String?
    }
    
    struct ErrorResponse: Codable {
        public let message: String
    }
    
    struct User: Codable {
        
        public enum State: String, Codable {
            case active
            case blocked
        }
        
        public let id: Int
        public let name: String
        public let username: String
        public let email: String?
        public let state: State?
        
        public var description: String {
            "ID \(id) - \(username) (\(name))"
        }
        
    }
    
    struct Project: Decodable {
        public let id: Int
        public let description: String
        public let name: String
        public let created_at: Date?
        public let default_branch: String?
        public let web_url: URL?
        public let avatar_url: URL?
        public let star_count: Int
        public let forks_count: Int
        public let last_activity_at: Date?
        public let archived: Bool
        public let owner: User?
    }

    struct Branch: Decodable {
        public let name: String
        public let merged: Bool
        public let protected: Bool
        public let developers_can_push: Bool
        public let developers_can_merge: Bool
        public let commit: Commit
    }
    
    struct ProtectedBranch: Decodable, CustomStringConvertible {
        public let name: String
        public let push_access_levels: [AccessLevel]
        public let merge_access_levels: [AccessLevel]

        public struct AccessLevel: Decodable, CustomStringConvertible {
            public let access_level: Int
            public let access_level_description: String
            
            public var description: String {
                access_level_description
            }
        }
        
        public var description: String {
            let pushLevels = push_access_levels.map({ $0.description }).joined(separator: ",")
            let mergeLevels = push_access_levels.map({ $0.description }).joined(separator: ",")

            return "Protected Branch '\(name)'\n  Push Levels: \(pushLevels)\n  Merge Levels: \(mergeLevels)"
        }
        
    }
    
    struct Changelog: Decodable {
        public let notes: String
    }
    
    struct CommonAncestor: Decodable {
        public let id: String
        public let short_id: String
        public let title: String
        public let created_at: Data
        public let parent_ids: [String]
        public let message: String?
        public let author_name: String
        public let author_email: String
        public let committer_name: Date
        public let committer_email: String
        public let committed_date: Date
    }
    
    struct Contributor: Decodable {
        public let name: String
        public let email: String
        public let commits: Int
        public let additions: Int
        public let deletions: Int
    }
    
    struct ShaCompareResult: Decodable {
        public let commit: Commit
        public let commits: [Commit]
        public let diffs: [Diff]
    }
    
    struct Diff: Decodable {
        public let old_path: String
        public let new_path: String
        public let a_mode: String
        public let b_mode: String
        public let new_file: Bool
        public let renamed_file: Bool
        public let deleted_file: Bool
        public let diff: String
    }

    struct Commit: Decodable {
        public let id: String
        public let short_id: String
        public let title: String
        public let created_at: Date
        public let parent_ids: [String]?
        public let message: String?
        public let author_name: String?
        public let author_email: String?
        public let committer_name: String?
        public let committer_email: String?
        public let committed_date: Date?
        public let status: String?
        public let last_pipeline: Pipeline?
        
        public struct GPGSignature: Decodable {
            public let signature_type: String
            public let verification_status: String
            public let gpg_key_id: Int?
            public let gpg_key_primary_keyid: String?
            public let commit_source: String?
            public let gpg_key_user_name: String?
            public let gpg_key_user_email: String?
            public let gpg_key_subkey_id: String?
        }

        public struct Diff: Decodable {
            public let old_path: String?
            public let new_path: String?
            public let a_mode: String?
            public let b_mode: String?
            public let new_file: Bool?
            public let renamed_file: Bool?
            public let deleted_file: Bool?
            public let diff: String?
        }
        
        public struct Comment: Decodable {
            public let note: String?
            public let author: Model.User?
        }
        
        public struct Ref: Decodable {
            public let type: String?
            public let name: String?
        }
        
        public struct Status: Decodable {
            public let status: String
            public let id: Int
            public let sha: String
            public let ref: String
            public let name: String
            public let target_url: URL?
            public let description: String?
            public let created_at: Date?
            public let started_at: Date?
            public let finished_at: Date?
            public let allow_failure: Bool?
            public let coverage: Int?
            public let author: Model.User?
        }
    }

    struct Group: Decodable {
        public let id: Int
        public let name: String?
        public let avatar_url: URL?
        public let web_url: URL?
        public let full_name: String?
        public let full_path: String?
    }
    
    struct Pipeline: Decodable {
        public let id: Int?
        public let sha: String?
        public let ref: String?
        public let status: String?
        public let project_id: Int?
        
        public struct Variable: Decodable {
            public let key: String
            public let value: String
            public let variable_type: String
        }
        
        public struct TestReport: Decodable {
            public let total_time: Int
            public let total_count: Int
            public let success_count: Int
            public let failed_count: Int
            public let skipped_count: Int
            public let error_count: Int
            public let test_suites: [TestSuite]
        }
        
        public struct TestSuite: Decodable {
            public let name: String
            public let total_time: Int
            public let total_count: Int
            public let success_count: Int
            public let failed_count: Int
            public let skipped_count: Int
            public let error_count: Int
            public let test_cases: [TestCase]
        }
        
        public struct TestCase: Decodable {
            public let status: String
            public let name: String
            public let classname: String?
            public let execution_time: Int?
            public let system_output: String?
            public let stack_trace: String?
        }
        
        public struct TestSummary: Decodable {
            public let time: Int
            public let count: Int
            public let success: Int
            public let failed: Int
            public let skipped: Int
            public let error: Int
            public let suite_error: String?
        }
    }

    struct Discussion: Decodable {
        public let id: String
        public let individual_note: Bool
        public let notes: [Note]
        
        public struct Note: Decodable {
            public let id: Int
            public let type: String?
            public let body: String?
            public let author: User?
            public let created_at: Date
            public let updated_at: Date?
            public let system: Bool
            public let noteable_id: Int?
            public let noteable_type: String?
            public let resolvable: Bool
            public let noteable_iid: Int?
        }
    }
    
    struct MergeRequest: Decodable {
        public let id: Int
        public let iid: Int
        public let project_id: Int
        public let title: String?
        public let description: String?
        public let state: String
        public let created_at: Date?
        public let updated_at: Date?
        public let target_branch: String?
        public let source_branch: String?
        public let upvotes: Int
        public let downvotes: Int
        public let author: Model.User?
        public let assignee: Model.User?
        public let source_project_id: Int?
        public let target_project_id: Int?
        public let labels: [String]?
        public let work_in_progress: Bool?
        public let milestone: Model.Milestone?
        public let merge_when_pipeline_succeds: Bool?
        public let merge_status: String?
        public let sha: String?
        public let merge_commit_sha: String?
        public let user_notes_count: Int
        public let discussion_locked: Bool?
        public let should_remove_source_branch: Bool?
        public let force_remove_source_branch: Bool
        public let web_url: URL
        public let time_stats: TimeStats?
    }
    
    struct Milestone: Decodable {
        public let id: Int
        public let iid: Int
        public let project_id: Int
        public let title: String?
        public let description: String?
        public let state: String?
        public let created_at: Date?
        public let updated_at: Date?
        public let due_date: Date?
        public let start_date: Date?
    }

    struct TimeStats: Decodable {
        public let time_estimate: Int?
        public let total_time_spent: Int?
        public let human_time_estimate: Int?
        public let human_total_time_spent: Int?
    }
    
    struct Note: Decodable {
        public let id: Int
        public let type: String
        public let body: String
        public let author: Model.User?
        public let createdAt: Date?
        public let updatedAt: Date?
        public let system: Bool
        public let noteable_id: Int?
        public let noteable_type: String?
        public let resolvable: Bool?
        public let confidential: Bool?
        public let noteable_iid: Int?
    }
    
    struct EpicIssueAssociation: Decodable {
        public let id: Int
        public let epic: Epic
        public let issue: Issue
    }
    
    struct Epic: Decodable {
        public let id: Int
        public let iid: Int
        public let title: String
        public let description: String
        public let author: User?
        public let start_date: Date?
        public let end_date: Date?
    }
    
    struct Issue: Decodable {
        public let id: Int
        public let iid: Int
        public let project_id: Int
        public let title: String?
        public let description: String?
        public let state: String?
        public let created_at: Date?
        public let updated_at: Date?
        public let closed_at: Date?
        public let closed_by: Model.User?
        public let labels: [String]?
        public let milestone: Model.Milestone?
        public let assignees: [Model.User]?
        public let author: Model.User?
        public let assignee: Model.User?
        public let user_notes_count: Int?
        public let upvotes: Int?
        public let downvotes: Int?
        public let due_date: Date?
        public let confidential: Bool?
        public let discussion_locked: Bool?
        public let web_url: URL
        public let time_stats: Model.TimeStats?
    }

    struct Label: Decodable {
        public let id: Int
        public let name: String
        public let color: String?
        public let description: String?
        public let open_issues_count: Int?
        public let open_merge_requests_count: Int?
        public let priority: Int?
        public let subscribed: Bool?
    }
    
}
