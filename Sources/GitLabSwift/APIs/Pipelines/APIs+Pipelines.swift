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
    
    /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html)
    public class Pipelines: APIService {
    
        /// List pipelines in a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#list-project-pipelines)
        ///
        /// - Parameters:
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - callback: configuration callback.
        public func list(project: DataTypes.ProjectID,
                  _ callback: ((APIOptions.PipelinesSearch) -> Void)? = nil) async throws -> GitLabResponse<[Model.Pipeline]> {
            let options = APIOptions.PipelinesSearch(project: project, callback)
            return try await gitlab.execute(.init(endpoint: Endpoints.Pipelines.list, options: options))
        }
        
        /// Get one pipeline from a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-a-single-pipeline)
        ///
        /// - Parameters:
        ///   - id: The ID of a pipeline
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: list of pipelines
        public func get(id: Int,
                 ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Pipeline]> {
            let options = APIOptionsCollection([
                APIOption(key: "pipeline_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Pipelines.get, options: options))
        }
        
        /// Get variables of a pipeline.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-variables-of-a-pipeline)
        ///
        /// - Parameters:
        ///   - id: The ID of a pipeline
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: list of variables
        public func variables(id: Int,
                       ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<[Model.Pipeline.Variable]> {
            let options = APIOptionsCollection([
                APIOption(key: "pipeline_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Pipelines.variables, options: options))
        }
        
        /// Get a pipeline’s test report.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-a-pipelines-test-report)
        ///
        /// - Parameters:
        ///   - id: The ID of a pipeline.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: report of the test.
        public func testReport(id: Int,
                        ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Pipeline.TestReport> {
            let options = APIOptionsCollection([
                APIOption(key: "pipeline_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Pipelines.test_report, options: options))
        }
        
        /// Get a pipeline’s test report summary.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-a-pipelines-test-report-summary)
        ///
        /// - Parameters:
        ///   - id: The ID of a pipeline
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: summary
        public func testReportSummary(id: Int,
                               ofProject project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Pipeline.TestSummary> {
            let options = APIOptionsCollection([
                APIOption(key: "pipeline_id", id),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Pipelines.test_report_summary, options: options))
        }
        
        /// Get the latest pipeline for a specific ref in a project.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#get-the-latest-pipeline)
        ///
        /// - Parameters:
        ///   - project: project.
        ///   - ref: The branch or tag to check for the latest pipeline.
        ///          Defaults to the default branch when not specified.
        /// - Returns: pipeline
        public func latest(project: DataTypes.ProjectID, ref: String? = nil) async throws -> GitLabResponse<Model.Pipeline> {
            let options = APIOptionsCollection([
                APIOption(key: "ref", ref),
                APIOption(key: "id", project)
            ])
            return try await gitlab.execute(.init(endpoint: Endpoints.Pipelines.latest, options: options))
        }
        
        /// Create a new pipeline.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#create-a-new-pipeline)
        ///
        /// - Parameters:
        ///   - ref: The branch or tag to run the pipeline on.
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        ///   - variables: variables available in the pipeline.
        /// - Returns: new created pipeline
        public func create(ref: String,
                    project: DataTypes.ProjectID,
                    variables: [[String: Any]]) async throws -> GitLabResponse<Model.Pipeline> {
            let options = APIOptionsCollection([
                APIOption(key: "ref", ref),
                APIOption(key: "id", project),
                APIOption(key: "variables", variables)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Pipelines.create, options: options))
        }
        
        /// Retry jobs in a pipeline.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#retry-jobs-in-a-pipeline)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: retried pipeline
        public func retry(pipeline: Int,
                   project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Pipeline> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "pipeline_id", pipeline)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Pipelines.retry, options: options))
        }
        
        /// Cancel a pipeline’s jobs.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#cancel-a-pipelines-jobs)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: cancelled pipeline
        public func cancel(pipeline: Int,
                    project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.Pipeline> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "pipeline_id", pipeline)
            ])
            return try await gitlab.execute(.init(.post, endpoint: Endpoints.Pipelines.cancel, options: options))
        }
        
        /// Deleting a pipeline expires all pipeline caches, and deletes all immediately related objects,
        /// such as builds, logs, artifacts, and triggers.
        /// This action cannot be undone.
        /// [API Documentation](https://docs.gitlab.com/ee/api/pipelines.html#delete-a-pipeline)
        ///
        /// - Parameters:
        ///   - pipeline: The ID of a pipeline
        ///   - project: The ID or URL-encoded path of the project owned by the authenticated user
        /// - Returns: no response
        public func delete(pipeline: Int,
                    project: DataTypes.ProjectID) async throws -> GitLabResponse<Model.NoResponse> {
            let options = APIOptionsCollection([
                APIOption(key: "id", project),
                APIOption(key: "pipeline_id", pipeline)
            ])
            return try await gitlab.execute(.init(.delete, endpoint: Endpoints.Pipelines.get, options: options))
        }
        
    }
    
}
