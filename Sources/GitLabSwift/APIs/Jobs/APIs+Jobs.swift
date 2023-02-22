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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html).
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
        public func list(project: DataTypes.ProjectID,
                         scopes: [DataTypes.JobScope]) async throws -> GitLabResponse<[Model.Job]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "scope", scopes)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Jobs.list, options: options))
        }
        
        
        /// Get a list of jobs for a pipeline.
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-jobs)
        ///
        /// - Parameters:
        ///   - pipeline: ID of a pipeline.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        ///   - scopes: Scope of jobs to show.
        ///   - includeRetried: Include retried jobs in the response.
        /// - Returns: jobs.
        public func list(pipeline: Int,
                         ofProject project: DataTypes.ProjectID,
                         scopes: [DataTypes.JobScope],
                         includeRetried: Bool? = nil) async throws -> GitLabResponse<[Model.Job]> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "pipeline_id", pipeline),
                APIOption(key: "scope", scopes),
                APIOption(key: "include_retried", includeRetried)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Jobs.pipeline, options: options))
        }
        
        /// Get a single job of a project.
        ///  API Documentation](https://docs.gitlab.com/ee/api/jobs.html#get-a-single-job)
        ///
        /// - Parameters:
        ///   - id: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: job
        public func get(id: Int,
                        ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Job> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "job_id", id)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Jobs.single, options: options))
        }
        
        /// Cancel a single job of a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#cancel-a-job)
        ///
        /// - Parameters:
        ///   - id: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: cancelled job
        public func cancel(id: Int,
                           ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Job> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "job_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Jobs.cancel, options: options))
        }
        
        /// Retry a single job of a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#retry-a-job)
        ///
        /// - Parameters:
        ///   - id: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: retried job
        public func retry(id: Int,
                          ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Job> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "job_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Jobs.retry, options: options))
        }
        
        /// Erase a single job of a project (remove job artifacts and a job log).
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#erase-a-job)
        ///
        /// - Parameters:
        ///   - id: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: erased job
        public func erase(id: Int,
                          ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Job> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "job_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Jobs.erase, options: options))
        }
        
        /// For a job in manual status, trigger an action to start the job.
        /// [API Documentation](https://docs.gitlab.com/ee/api/jobs.html#run-a-job)
        ///
        /// - Parameters:
        ///   - id: ID of a job.
        ///   - project: ID or URL-encoded path of the project owned by the authenticated user.
        /// - Returns: runned job
        public func run(id: Int,
                        ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Job> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "job_id", id)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Jobs.play, options: options))
        }
        
        // TODO: Missing APIs Calls
        // - https://docs.gitlab.com/ee/api/jobs.html#list-pipeline-bridges
        // - https://docs.gitlab.com/ee/api/jobs.html#get-job-tokens-job
        // - https://docs.gitlab.com/ee/api/jobs.html#get-a-log-file
        
    }
    
}
