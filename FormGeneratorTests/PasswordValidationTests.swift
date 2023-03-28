import XCTest

// for password: ^.{6,}$ - at least 6 char
/// By default the password's length must be at least 6 character (can be also whitespace)


@testable import FormGenerator

final class PasswordValidationTests: XCTestCase {
    private var sut: PasswordValidation!
    
    override func setUpWithError() throws {
        sut = PasswordValidation()
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }
    
    
    func test_invalidPasswordLessThenSixCharacters_returnsErrorMessageWhenFail(){
        let checkerPassword = "badpw"
        let expectation = XCTestExpectation(description: "Should be failure!")
        sut.validatePassword(password: checkerPassword) { result in
            switch result {
                case .success():
                    XCTFail("Password validation should not pass, it's has error!")
                case .failure( _ ):
                    expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
        
    }
    func test_validPasswordAtLeastSixCharacters_returnsErrorMessageWhenFail(){
        let checkerPassword = "goodpassword "
        let expectation = XCTestExpectation(description: "Should be success!")
        sut.validatePassword(password: checkerPassword) { result in
            switch result {
                case .success():
                    expectation.fulfill()
                case .failure( _ ):
                    XCTFail("Password validation should pass!")
            }
        }
        wait(for: [expectation], timeout: ValidationContent.expectationTimeInterval)
    }
}
