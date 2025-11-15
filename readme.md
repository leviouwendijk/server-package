# Project initializer

Made for [Server library](https://github.com/leviouwendijk/Server.git)

Initializes through wizard (or args) a basic project without installing bloat.

# Note on defaults

This tool was devised for:
- no bloating of the binary (slowing down build times)
- not copying your reference project every time

Therefore, for now, note that it has an opinionated default partitioning tree:

```
.
└── myapi
    └── v2
        ├── Package.swift
        ├── Package.swift_previous_version.bak
        └── Sources
            └── Myapi
                ├── objects
                │   ├── model
                │   │   └── model.swift
                │   └── operation
                │       └── operation.swift
                ├── routes.swift
                ├── runtime.swift
                └── state.swift
```

Note that it shouldn't happen that you override your files (thanks to plate's `SafeFile`, which protects against unintended overrides and creates backups).

That is also why, although it uses SwiftPM and tries to extract the current toolchain for you, it provides a backup of the `Package.swift` in case you need it.

# Example

```
> $ server-package

Server Package Generator

Package name (lowercase): myapi
Version number (default 1): 2

Package Summary:
  Name: myapi
  Version: v2
  Path: myapi/v2/

Proceed? (y/n): y

Creating package structure...

✓ Directory structure created

Initializing Swift package...
Creating executable package: Myapi
Creating Package.swift
Creating .gitignore
Creating Sources
Creating Sources/Myapi/Myapi.swift
✓ Swift package initialized
✓ Removed default file
✓ Extracted swift-tools-version
✓ Generated Package.swift
✓ <your-cwd>/myapi/v2/Sources/Myapi/state.swift
✓ <your-cwd>/myapi/v2/Sources/Myapi/runtime.swift
✓ <your-cwd>/myapi/v2/Sources/Myapi/routes.swift
✓ <your-cwd>/myapi/v2/Sources/Myapi/objects/model/model.swift
✓ <your-cwd>/myapi/v2/Sources/Myapi/objects/operation/operation.swift

Package created successfully!
cd <your-cwd>/myapi/v2
```
