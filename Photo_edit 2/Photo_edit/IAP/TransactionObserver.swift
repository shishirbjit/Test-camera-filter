//
//  TransactionObserver.swift


import Foundation
import StoreKit

struct AppConstants {
    
    // Last transaction ID
    static let lastTransactionID = "lastTransactionID"
    
    // Last processed transaction key
    static let isNotAllowToEnterTransaction = "isNotAllowToEnterTransaction"
}
/// Interface to handle transactions that happen outside of the app
protocol OutsideAppTransactionHandlerInterface {
    /// Handling Transaction and Pushing to the Cloud
    /// - Parameters:
    ///     - transaction: SKTransaction
    func saveReceipt(transaction: Transaction)
}


final class TransactionObserver {
    
    // Last transaction ID
    private let lastTransactionDateKey = "lastTransactionDate"

    /// A task for managing transaction updates, initialized or set to `nil` when inactive.
    var updates: Task<Void, Never>? = nil
    
    /// Handles transactions processed outside the app.
    var transactionHandler: OutsideAppTransactionHandlerInterface

    init(transactionHandler:OutsideAppTransactionHandlerInterface) {
        self.transactionHandler = transactionHandler
        self.updates = newTransactionListenerTask()
        Logger.shared.log(" TransactionObserver init")
    }


    deinit {
        // Cancel the update handling task when you deinitialize the class.
        updates?.cancel()
        Logger.shared.log(" TransactionObserver deinit")
    }
    
    func checkForAllTransactions() {
        Logger.shared.log(" TransactionObserver checkForAllTransactions")
        Task(priority: .background) {
            for await verificationResult in Transaction.all {
                await self.handleAll(transaction: verificationResult)
            }
        }
    }

    /// Creates a new task that listens for transaction updates and processes them.
    ///
    /// - Returns: A background task that continuously awaits transaction updates, handling each update as it arrives.
    private func newTransactionListenerTask() -> Task<Void, Never> {
        Task(priority: .background) {
            for await verificationResult in Transaction.updates {
                await self.handleUpdate(updatedTransaction: verificationResult)
            }
        }
    }
    
    private func handleAll(transaction verificationResult: VerificationResult<Transaction>) async {
        Logger.shared.log(" TransactionObserver handleAllTranactions")
        switch verificationResult {
        case .unverified(let signedType, let verificationError):
            // Log information about the unverified transaction with details about the signature type and error.
            Logger.shared.log("Unverrified, error: \(verificationError) signedType: \(signedType)")
        case .verified(let transaction):
            let transactionIdentifier = String(transaction.originalID)
            let transactionDateString = String(transaction.originalPurchaseDate.timeIntervalSince1970WithMilliseconds)
            if let revocationDate = transaction.revocationDate {
                Logger.shared.log("\(revocationDate) access will be remove.")
                // Logic to revoke access goes here.
            } else {
                // Get last transaction
                let lastProcessedID = UserDefaults.standard.string(forKey: AppConstants.lastTransactionID)
                let lastProcessedDateString = UserDefaults.standard.string(forKey: lastTransactionDateKey)
                if let processedDateString = lastProcessedDateString, 
                    let processedDateDouble = Int64(processedDateString),
                   processedDateDouble > transaction.originalPurchaseDate.timeIntervalSince1970WithMilliseconds {
                    Logger.shared.log(" already processed \(transactionIdentifier)")
                    return
                }
                
                let isNotAllow = UserDefaults.standard.bool(forKey: AppConstants.isNotAllowToEnterTransaction)
                if isNotAllow && (lastProcessedID == transactionIdentifier) {
                    return
                }
                
                await pushReceipt(transaction: transaction, transactionIdentifier: transactionIdentifier, transactionDateString: transactionDateString)
            }
        }
    }

    /// Handles an updated transaction by logging details and managing access based on the verification outcome.
    ///
    /// - Parameter verificationResult: The result of a transaction verification process. It can be either verified or unverified.
    ///   If unverified, logs detailed information about the signature type and error. If verified, manages transaction details
    ///   such as revocation, expiration, and upgrade status, and provides access if the transaction is valid.
    private func handleUpdate(updatedTransaction verificationResult: VerificationResult<Transaction>) async {
        Logger.shared.log(" TransactionObserver handleUpdate")
        switch verificationResult {
        case .unverified(let signedType, let verificationError):
            // Log information about the unverified transaction with details about the signature type and error.
            Logger.shared.log("Unverrified, error: \(verificationError) signedType: \(signedType)")
        case .verified(let transaction):
            let transactionIdentifier = String(transaction.originalID)
            let transactionDateString = String(transaction.originalPurchaseDate.timeIntervalSince1970WithMilliseconds)
            if let revocationDate = transaction.revocationDate {
                Logger.shared.log("\(revocationDate) access will be remove.")
                // Logic to revoke access goes here.
            } else {
                // Get last transaction
                let lastProcessedID = UserDefaults.standard.string(forKey: AppConstants.lastTransactionID)
                let isNotAllow = UserDefaults.standard.bool(forKey: AppConstants.isNotAllowToEnterTransaction)
                if isNotAllow && (lastProcessedID == transactionIdentifier) {
                    return
                }
                await pushReceipt(transaction: transaction, transactionIdentifier: transactionIdentifier, transactionDateString: transactionDateString)
            }
        }
    }
    
    private func pushReceipt(transaction:Transaction, transactionIdentifier:String, transactionDateString:String) async {
        transactionHandler.saveReceipt(transaction: transaction)
        // Saveing current transaction Id
        UserDefaults.standard.set(transactionIdentifier, forKey: AppConstants.lastTransactionID)
        UserDefaults.standard.set(transactionDateString, forKey: lastTransactionDateKey)
        await transaction.finish()
    }
    
}

extension Date {
    
    /// Timestamp in milliseconds
    var timeIntervalSince1970WithMilliseconds : Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
}
