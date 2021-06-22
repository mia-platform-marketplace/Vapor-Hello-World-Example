# Vapor Hello World Example

## Summary

Welcome to Vapor Hello World application.

This is an example of a simple [Vapor](https://docs.vapor.codes/4.0/) microservice showing requests handling, requests validation, authentication, and how to perform network calls within a route handler.

#### Defined endpoints

```bash
+------+--------------------+
| GET  | /-/healthz         |
+------+--------------------+
| GET  | /-/ready           |
+------+--------------------+
| GET  | /-/check-up        |
+------+--------------------+
| GET  | /hello             |
+------+--------------------+
| POST | /hello/:pathParam  |
+------+--------------------+
| GET  | /hello/with-riders |
+------+--------------------+
```

## Local Development

Install [Swift](https://swift.org/getting-started/).

If you are on macOS, set a custom working directory in the Xcode scheme for your project as described in [Vapor's doc](https://docs.vapor.codes/4.0/xcode/#custom-working-directory).

### Lint

Install [SwiftLint](https://github.com/realm/SwiftLint).

```bash
swiftlint ./Sources
```
If you need to edit the lint rules here is the rule directory reference: https://realm.github.io/SwiftLint/rule-directory.html

### Test

```bash
swift test --enable-test-discovery
```

### Build

```bash
swift build
```

### Run

If you need to set custom env variables, create your local copy of the default values:
```bash
cp .env .env.dev
```
From now on, if you want to change anyone of the default values for the variables you can do it inside the `.env.dev` file without pushing it to the remote repository.

```bash
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

