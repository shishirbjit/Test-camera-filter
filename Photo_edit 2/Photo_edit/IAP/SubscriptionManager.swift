
import UIKit
import StoreKit

/// Purchase subscription prompts keys
enum SubscriptionPrompt:String {
    case Collection
    case Saved
}



/// Receipt upload response keys
struct ReceiptUploadStatus {
    static let key = "receiptUploadStatus"
    static let originalTransactionIdentifier = "originalTransactionIdentifier"
    static let originalTransactionDate = "originalTransactionDate"
    static let isUploaded = "isUploaded"
}





    
class SubscriptionManager: NSObject {
    
    static let shared = SubscriptionManager()
    
    private override init() {
        super.init()
    }
    
    /// get receipt from bundle
    ///
    ///  - Returns: base 64 encoded receipt
    func getReceipt() -> String? {
        guard let receiptURL = Bundle.main.appStoreReceiptURL, FileManager.default.fileExists(atPath: receiptURL.path) else  {
            return nil
        }
        // get data from receipt
        var receiptData:NSData?
        do {
            receiptData = try NSData(contentsOf: receiptURL, options: NSData.ReadingOptions.alwaysMapped)
        } catch {
            print("ERROR: " + error.localizedDescription)
        }
        
        // make json object
        guard let base64encodedReceipt = receiptData?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithCarriageReturn) else {
            return nil
        }
        return base64encodedReceipt
    }
    
    
    
    /// Save subscription receipt to Cloud
    ///
    /// - Parameters:
    ///     - transactionIdentifier: latest transaction id.
    ///     - transactionDateString: transection date.
    ///     - completion: completion handler
    func saveReciptToCloud(transactionIdentifier: String, transactionDateString:String, completion: CloudDataManagerCallback?) {
        
        
        // track receipt upload status and store locally
        let uploadResponse = [ReceiptUploadStatus.originalTransactionIdentifier: transactionIdentifier, ReceiptUploadStatus.originalTransactionDate: transactionDateString, ReceiptUploadStatus.isUploaded: false] as [String: Any]
        // update response
        self.receiptUploadResponse = uploadResponse
        
        // get receipt from bundle
        guard let base64encodedReceipt = getReceipt() else {
           // LogManager.shared.addLog(logString: LogMessageConstants.storeKit + "Not getting proper recipts")
            return
        }
        
        // upload to cloud
        syncReceipt(base64encodedReceipt, transactionId: transactionIdentifier, transactionDate: transactionDateString, completion: completion)
    }
    
    /// sync subscription receipt with Cloud
    /// - Parameters :
    ///     - transaction: original transaction identifier
    ///     - receipt: latest receipt base64 encoded string
    ///     - transactionDate: original transaction date
    ///     - completion: completion handler
    func syncReceipt(_ receipt: String, transactionId: String, transactionDate: String, completion: CloudDataManagerCallback?) {
        // upload subscription receipt to cloud
        Logger.shared.log("---- Receipt ---- \(receipt)")
//        CloudDataManager.shared.uploadSubscriptionReceipt(receipt, originalTransactionId: transactionId, originalTransactionDate: transactionDate ) { (response) in
//            // check status of response
//            if let status = response[APIParameters.success] as? Bool, status {
//                // update receipt upload status
//                self.receiptUploadResponse = nil
//            }
//            completion?(response)
//        }
    }
    
}

extension SubscriptionManager {
    // receipt upload response to track the upload status
    var receiptUploadResponse:[String: Any]? {
        get {
            return UserDefaults.standard.value(forKey: ReceiptUploadStatus.key) as? [String: Any]
        }
        set (newValue){
            if newValue != nil{
                UserDefaults.standard.set(receiptUploadResponse, forKey: ReceiptUploadStatus.key)
                UserDefaults.standard.synchronize()
            } else {
                UserDefaults.standard.removeObject(forKey: ReceiptUploadStatus.key)
                UserDefaults.standard.synchronize()
            }
        }
    }
}
