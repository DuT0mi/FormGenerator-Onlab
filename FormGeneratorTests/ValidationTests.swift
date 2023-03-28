import XCTest
@testable import FormGenerator


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
        wait(for: [expectation], timeout: 5.0)
    }
    
}
