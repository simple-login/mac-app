# SimpleKeychain

`SimpleKeychain` is a Swift package providing a convenient interface for interacting with the iOS Keychain. It is designed to simplify common tasks such as storing and retrieving sensitive data securely.

## Features

- **Generic Storage**: Store and retrieve generic items securely in the Keychain.
- **Type-Safe Retrieval**: Retrieve stored items with type safety using Swift generics.
- **Item Class Types**: Support for different item class types, such as generic or internet password.
- **Duplicate Item Handling**: Automatically handles duplicate items during storage.

## Installation

### Swift Package Manager

To integrate `SimpleKeychain` into your Xcode project using Swift Package Manager, add the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/SimpleKeychain.git", from: "0.1.0")
]
```

## Usage

### Initialization

```swift
// Initialize SimpleKeychain with optional service and access group parameters
let keychain = SimpleKeychain(service: "com.yourapp.keychain", accessGroup: "your.access.group")
```

### Storing and Retrieving Data

```swift
// Store an item
try keychain.set("YourItem", for: "YourKey")

// Retrieve an item
let retrievedItem: String = try keychain.get(key: "YourKey")
```

### Deleting and Clearing

```swift
// Delete a specific item
try keychain.delete("YourKey")

// Clear all items of a specific class type
try keychain.clear(ofType: .generic)
```

### Error Handling

All operations that interact with the Keychain may throw errors of type `SimpleKeychainError`. Ensure to handle these errors appropriately in your code.

```swift
do {
    // Perform Keychain operation
} catch let error as SimpleKeychainError {
    // Handle the error
    print("Keychain operation failed: \(error.localizedDescription)")
} catch {
    // Handle other errors
    print("An unexpected error occurred: \(error.localizedDescription)")
}
```

## Work based on the following contributions

[Bruno Lorenzo](https://blorenzop.medium.com/keychain-services-in-swift-ecb9d6d5c6cd)

[KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess)

[KeychainSwift](https://github.com/evgenyneu/keychain-swift/)

[Swift Discovery](https://onmyway133.com/posts/how-to-use-keychain-in-swift/)


### License
`SimpleKeychain` is released under the MIT License. See LICENSE for details.