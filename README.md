<p align="center">
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./Documentation/gitlabswift.png" width="350">
  <img alt="logo-library" src="./Documentation/gitlabswift.png" width="350">
</picture>
</p

## Async/Await Gitlab API v4 client for Swift

GitLabSwift is an async/await client to perform type-safe, multi-thread Swift call to the GitLab API services.  
It's very simple to use, below just few examples:

```swift
// Configure your APIs service connector
let api = GitLab(config: .init(baseURL: "http://...", {
    $0.token = "<YOUR_PERSONAL_TOKEN>"
})

// SOME EXAMPLES

// Get your own profile
let me: GLModel.User = try await gitlab.users.me()

// Get projects
let response = try await gitlab.projects.list(options: {
    $0.orderBy = .id
    $0.statistics = true
    $0.sort = .desc
})
            
// List some project's commits
let commits =try await gitlab.commits.list(project: anyProjectID, options: {
    $0.since = Date.oneWeekAgo()
    $0.until = Date.now
    $0.includeStats = true
})
```
