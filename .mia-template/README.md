# mia_template_service_name_placeholder 

## Summary

%CUSTOM_PLUGIN_SERVICE_DESCRIPTION%

This is an example of a simple [Vapor](https://docs.vapor.codes/4.0/) microservice showing requests handling, authentication, and how to perform network calls within a route handler.

#### Defined endpoints

```bash
+------+----------------------+
| GET  | /-/healthz           |
+------+----------------------+
| GET  | /-/ready             |
+------+----------------------+
| GET  | /-/check-up          |
+------+----------------------+
| GET  | /hello               |
+------+----------------------+
| POST | /hello/:pathParam    |
+------+----------------------+
| GET  | /hello/with-datetime |
+------+----------------------+
```

## Local Development

Install [Swift](https://swift.org/getting-started/) (5.4 or newer).

If you are on macOS, set a custom working directory in the Xcode scheme for your project as described in [Vapor's doc](https://docs.vapor.codes/4.0/xcode/#custom-working-directory).

### Lint

Install [SwiftLint](https://github.com/realm/SwiftLint).

```bash
swiftlint ./Sources
```
If you need to edit the lint rules here is the rule directory reference: https://realm.github.io/SwiftLint/rule-directory.html

### Test

```bash
swift test
```

### Build

```bash
swift build
```

### Update package version

```bash
swift run Run version [--number <your new version>] [--patch] [--minor] [--major] [-h|--help]

# Example:
# swift run Run version --number 2.1.0
# swift run Run version --patch
```
This command tags a new version of your package and update the `CHANGELOG.md` accordingly.

### Run

If you need to set custom env variables, create your local copy of the default values:
```bash
cp .env .env.dev
```
From now on, if you want to change any of the default values for the variables you can do it inside the `.env.dev` file without pushing it to the remote repository.

```bash
set -a && source .env.dev
swift run
```
After that you will have the service exposed on your machine. In order to verify that the service is working properly you could launch in another terminal shell:
```bash
curl "http://localhost:8080/hello?token=foo"
```
As a result the terminal should return you the following message:
```json
{"message":"Hello, world!","tokenSent":"foo"}
```

