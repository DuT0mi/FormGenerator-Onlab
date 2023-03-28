import XCTest

final class FormGeneratorUITests: XCTestCase {
    private var sutApp: XCUIApplication!
    
    override func setUp(){
        super.setUp()
        continueAfterFailure = false
        
        sutApp = XCUIApplication()
        sutApp.launch()
    }
    override func tearDown() {
        
    }
}
