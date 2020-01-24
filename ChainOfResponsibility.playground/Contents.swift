
enum MedicalReportTypes: String {
    case Xray = "X-ray"
    case MRI = "MRI"
    case CTScan = "CTScan"
}

enum MedialReportViewer: Int {
    case executed
    case unexecuted
}

/// The MedicalReportHandler interface declares a method for building the chain of handlers.
/// It also declares a method for executing a request of various medical reports.
protocol MedicalReportHandler: class {

    @discardableResult
    func setNext(handler: MedicalReportHandler) -> MedicalReportHandler

    func handle(request: MedicalReportTypes) -> MedialReportViewer?
    var nextHandler: MedicalReportHandler? { get set }
}

extension MedicalReportHandler {

    func setNext(handler: MedicalReportHandler) -> MedicalReportHandler {
        self.nextHandler = handler

        /// Returning a handler from here will let us link handlers in a
        /// convenient way like this:
        return handler
    }

    func handle(request: MedicalReportTypes) -> MedialReportViewer? {
        return nextHandler?.handle(request: request)
    }
}

/// All Concrete(Different medical report) Handlers either handle a request or pass it to the next handler
/// in the chain if it cannot execute the request..
class XrayReportHandler: MedicalReportHandler {

    var nextHandler: MedicalReportHandler?

    func handle(request: MedicalReportTypes) -> MedialReportViewer? {
        if request == .Xray {
            print("Do needful to execute this request and display X-ray viewer")
            return .executed
        }
        else{
            return nextHandler?.handle(request: request)
        }
    }
}

class MRIReportHandler: MedicalReportHandler {

    var nextHandler: MedicalReportHandler?

    func handle(request: MedicalReportTypes) -> MedialReportViewer? {
        if request == .MRI {
            print("Do needful to execute this request and display MRI viewer")
            return .executed
        }
        else{
            return nextHandler?.handle(request: request)
        }
    }
}

class CTScanReportHandler: MedicalReportHandler {

    var nextHandler: MedicalReportHandler?

    func handle(request: MedicalReportTypes) -> MedialReportViewer? {
        if request == .CTScan {
            print("Do needful to execute this request and display CTScan viewer")
            return .executed
        }
        else{
            return nextHandler?.handle(request: request)
        }
    }
}


/// The client code is usually suited to work with a single MedicalReportHandler. Most of client code is not aware that the handler is part of a chain.
class MedicalSpecialtyApp {

    static func displayMedicalReport(reportType:MedicalReportTypes ,handler: MedicalReportHandler) {
        
        guard let result = handler.handle(request: reportType) else {
            print("Unable to find way to execute \(reportType)")
            return
        }
        
        print("\(reportType) \(result)")
    }

}

let xrayaHandler = XrayReportHandler()
let mriHandler = MRIReportHandler()
let ctScanHandler = CTScanReportHandler()
//There could be more handlers in chain depending upon new implementation/requirement for specific report type..
xrayaHandler.setNext(handler: mriHandler).setNext(handler: ctScanHandler)

/// The client should be able to send a request to any handler, not just
/// the first one in the chain.
MedicalSpecialtyApp.displayMedicalReport(reportType: .MRI, handler: xrayaHandler)


