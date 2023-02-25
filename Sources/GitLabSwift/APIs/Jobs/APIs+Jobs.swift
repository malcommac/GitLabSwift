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

// MARK: - Jobs + URLs

extension APIService.Jobs {
    
    fileprivate enum URLs: String, GLEndpoint {
        case list = "/projects/{id}/jobs"
        case pipeline = "/projects/{id}/pipelines/{pipeline_id}/jobs"
        case single = "/projects/{id}/jobs/{job_id}"
        case cancel = "/projects/{id}/jobs/{job_id}/cancel"
        case retry = "/projects/{id}/jobs/{job_id}/retry"
        case erase = "/projects/{id}/jobs/{job_id}/erase"
        case play = "/projects/{id}/jobs/{job_id}/play"

        public var value: String { rawValue }
    }
    
}

// MARK: - Jobs + APIs

extension APIService {
    
    /// Jobs API
    ///
    /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html)
    ///
    /// MISSING APIs:
    /// - https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-bridges
    /// - https://docs.gitlab.com/ee/api/jobs.html#get-job-tokens-job
    /// - https://docs.gitlab.com/ee/api/jobs.html#get-a-log-file
    public class Jobs: APIService {
        
        /// Get a list of jobs in a project.
        /// Jobs are sorted in descending order of their IDs.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#list-project-jobs)
        ///
        /// - Parameters:
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        ///   - scopes: Scope(s) of jobs to show.
        /// - Returns: jobs list
        public func list(project: InputParams.ProjectID,
                         scopes: [InputParams.JobScope]) async throws -> GLResponse<[Model.Job]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "scope", scopes)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.list, options: options))
        }
        
        
        /// Get a list of jobs for a pipeline.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-jobs)
        ///
        /// - Parameters:
        ///   - pipeline: ID of a pipeline.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        ///   - scopes: Scope of jobs to show.
        ///   - includeRetried: Include retried jobs in the response.
        /// - Returns: jobs.
        public func list(pipeline: Int,
                         project: InputParams.ProjectID,
                         scopes: [InputParams.JobScope],
                         includeRetried: Bool? = nil) async throws -> GLResponse<[Model.Job]> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "pipeline_id", pipeline),
                OutputParam(key: "scope", scopes),
                OutputParam(key: "include_retried", includeRetried)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.pipeline, options: options))
        }
        
        /// Get a single job of a project.
        ///  API Documentation](https://docs.gitlab.com/ee/api/jobs.html#get-a-single-job)
        ///
        /// - Parameters:
        ///   - job: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: job
        public func get(job: Int,
                        project: InputParams.ProjectID) async throws -> GLResponse<Model.Job> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "job_id", job)
            ])
            return try await gitlab.execute(.init(endpoint: URLs.single, options: options))
        }
        
        /// Cancel a single job of a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#cancel-a-job)
        ///
        /// - Parameters:
        ///   - job: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: cancelled job
        public func cancel(job: Int,
                           project: InputParams.ProjectID) async throws -> GLResponse<Model.Job> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "job_id", job)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.cancel, options: options))
        }
        
        /// Retry a single job of a project.
        ///
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#retry-a-job)
        ///
        /// - Parameters:
        ///   - job: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: retried job
        public func retry(job: Int,
                          project: InputParams.ProjectID) async throws -> GLResponse<Model.Job> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "job_id", job)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.retry, options: options))
        }
        
        /// Erase a single job of a project (remove job artifacts and a job log).
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#erase-a-job)
        ///
        /// - Parameters:
        ///   - job: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: erased job
        public func erase(job: Int,
                          project: InputParams.ProjectID) async throws -> GLResponse<Model.Job> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "job_id", job)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.erase, options: options))
        }
        
        /// For a job in manual status, trigger an action to start the job.
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#run-a-job)
        ///
        /// - Parameters:
        ///   - job: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: runned job
        public func run(job: Int,
                        project: InputParams.ProjectID) async throws -> GLResponse<Model.Job> {
            let options = OutputParamsCollection([
                OutputParam(key: "id", project),
                OutputParam(key: "job_id", job)
            ])
            return try await gitlab.execute(.init(.post, endpoint: URLs.play, options: options))
        }
        
    }
    
}
