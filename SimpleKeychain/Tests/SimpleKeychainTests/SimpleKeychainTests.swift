import XCTest
@testable import SimpleKeychain

final class SimpleKeychainTests: XCTestCase {
    let sut: KeychainServicing = SimpleKeychain()
    let apiToken = "testtoken"

    // MARK: - Set & Get

    func test_setAndGetString_ShouldBeValid() async throws  {
        let key = "testString"
        try await sut.set(apiToken, for: key)
        let decodedString: String = try await sut.get(key: key)

        XCTAssertEqual(decodedString, apiToken)
    }

    func test_setAndGetBoolean_ShouldBeValid() async throws  {
        let key = "testBoolean"
        let value = true
        try await sut.set(value, for: key)
        let decodedBoolean: Bool = try await sut.get(key: key)

        XCTAssertTrue(decodedBoolean)
    }

    func test_setAndGetData_ShouldBeValid() async throws  {
        let key = "testData"
        let data = try JSONEncoder().encode(apiToken)
        try await sut.set(data, for: key)
        let decodedData: Data = try await sut.get(key: key)
        let decodedToken = try JSONDecoder().decode(String.self, from: decodedData)

        XCTAssertEqual(decodedToken, apiToken)
    }

    func test_setAndGetCodable_ShouldBeValid() async throws  {
        struct Test: Codable {
            let title: String
        }
        let key = "testCodable"
        let value = Test(title: "plop")
        try await sut.set(value, for: key)
        let decodedCodable: Test = try await sut.get(key: key)

        XCTAssertEqual(decodedCodable.title, "plop")
    }

    func test_deleteValue_ShouldBeValid() async throws  {
        let key = "testDeletion"
        try await sut.set(apiToken, for: key)
        let newToken: String = try await sut.get(key: key)
   
        XCTAssertEqual(newToken, apiToken)
           try await sut.delete(key)
        do {
            try await sut.get(key: key) as String
            XCTFail("Error needs to be thrown")
        } catch {
            XCTAssertEqual(error as! SimpleKeychainError, SimpleKeychainError.itemNotFound)

        }
    }

    func test_updateValueForKey_ShouldBeValid() async throws  {
        let key = "testUpdate"
        try await sut.set(apiToken, for: key)
        let newToken: String = try await sut.get(key: key)
        XCTAssertEqual(newToken, apiToken)
        let newValue = false
        try await sut.set(newValue, for: key)
        let decodedBoolean: Bool = try await sut.get(key: key)
        XCTAssertFalse(decodedBoolean)
    }

    func test_tryWrongTypeFetching_ShouldFail() async throws  {
        let key = "testUpdate"
        try await sut.set(apiToken, for: key)
         await xCTAssertThrowsError(try await sut.get(key: key) as Bool)
    }

    func xCTAssertThrowsError<T>(_ expression: @autoclosure () async throws -> T) async {
        do {
            _ = try await expression()
            XCTFail("No error was thrown.")
        } catch {
            //Pass
        }
    }
}
