import XCTest
@testable import FormGenerator

// MARK: Firebase email and password validation method:

// for email: / ^[^@]+@[^@]+\.[a-zA-Z]{2,}$ / -> 2 backslash coz of the dot
/// which means:
/// This pattern matches any string that starts with one or more characters that are not "@" followed by "@" and one or more characters that are not "@", followed by a dot and at least two characters from a-z or A-Z.

// for password:
/// By default the password's length must be at least 6 character

final class ValidationTests: XCTestCase {
    private var sut: Validation!
    
    override func setUpWithError() throws {
        super.setUp()
        sut = Validation()
    }
    override func tearDownWithError() throws{
        sut = nil
        super.tearDown()
    }
    
    func test_invalidEmailMissingAtSign_returnsErrorMessage(){
        let checkerEmail = "bad.com"
        let expectation = XCTestExpectation(description: "Email should not pass!")
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
    func test_invalidEmailFronAtSign_returnsErrorMessage(){
        let checkerEmail = "@bad@test.com"
        let expectation = XCTestExpectation(description: "Email should not pass!")
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
    func test_invalidEmailWithoutDot_returnErrorMessage(){
        
    }
    
    
    
}
