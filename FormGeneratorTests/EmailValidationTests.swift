import XCTest
@testable import FormGenerator

// MARK: Firebase email and password validation method:

// for email: / ^[^@]+@[^@]+\.[a-zA-Z]{2,}$ / -> 2 backslash coz of the dot
/// which means:
/// This pattern matches any string that starts with one or more characters that are not "@" followed by "@" and one or more characters that are not "@", followed by a dot and at least two characters from a-z or A-Z.

// for password:
/// By default the password's length must be at least 6 character (can be also whitespace)

final class EmailValidationTests: XCTestCase {
    private var sut: EmailValidation!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = EmailValidation()
    }
    override func tearDownWithError() throws{
        sut = nil
        super.tearDown()
    }
    
    func test_invalidEmailMissingAtSign_returnsErrorMessageWhenFail(){
        let checkerEmail = "bad.com"
        let expectation = XCTestExpectation(description: "Should be failure!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                        XCTFail("Email validation should not pass, it's has error!")
                case .failure( _ ):
                    expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
    func test_invalidEmailFronAtSign_returnsErrorMessageWhenFail(){
        let checkerEmail = "@bad@test.com"
        let expectation = XCTestExpectation(description: "Should be failure!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                    XCTFail("Email validation should not pass, it's has error!")
                case .failure( _ ):
                    expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
    func test_invalidEmailWithoutDot_returnsErrorMessageWhenFail(){
        let checkerEmail = "bad@testcom"
        let expecation = XCTestExpectation(description: "Should be failure!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                    XCTFail("Email validation should not pass, it's has error!")
                case.failure( _ ):
                    expecation.fulfill()
            }
        }
        wait(for: [expecation], timeout: ValidationContent.expectationTimeInterval)
    }
    func test_invalidEmailWithNotEnoughLetterAtTheEnd_returnsErrorMessageWhenFail(){
        let checkerEmail = "bad@test.c"
        let expectation = XCTestExpectation(description: "Should be failure!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                    XCTFail("Email validation should not pass, it's has error!")
                case .failure( _ ):
                    expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
    func test_goodEmailWithTwoLetterAfterTheDot_returnsErrorMessageWhenFail(){
        let checkerEmail = "good@test.co"
        let expectation = XCTestExpectation(description: "Should be success!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
    func test_goodEmailWithThreeLetterAfterTheDot_returnsErrorMessageWhenFail(){
        let checkerEmail = "good@test.com"
        let expectation = XCTestExpectation(description: "Should be success!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
    func test_goodEmailWithMoreLetterAfterTheDot_returnsErrorMessageWhenFail(){
        let checkerEmail = "good@test.coooom"
        let expectation = XCTestExpectation(description: "Should be success!")
        sut.validateEmail(email: checkerEmail) { result in
            switch result {
                case .success():
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
}
