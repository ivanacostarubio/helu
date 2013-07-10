class Helu
  
  attr_reader :product_id

  def initialize(product_id)
    @product_id = product_id
    SKPaymentQueue.defaultQueue.addTransactionObserver(self)
  end

  def close_the_store
    SKPaymentQueue.defaultQueue.removeTransactionObserver(self)
  end

  def fail=(fail_block)
    @fail = fail_block
  end

  def winning=(winning_block)
    @winning = winning_block
  end


  def buy
    payment = SKPayment.paymentWithProductIdentifier(product_id)
    SKPaymentQueue.defaultQueue.addPayment(payment)
  end

#  private

  def finishTransaction(transaction, wasSuccessful:wasSuccessful)
    SKPaymentQueue.defaultQueue.finishTransaction(transaction)
    produt_id = transaction.payment.productIdentifier
    wasSuccessful ? @winning.call(transaction) : @fail.call(transaction)
  end

  def completeTransaction(transaction)
    finishTransaction(transaction,wasSuccessful:true)
  end

  def restoreTransaction(transaction)
    recordTransaction(transaction.originalTransaction)
    finishTransaction(transaction,wasSuccessful:true)
  end

  def failedTransaction(transaction)
    produt_id = transaction.payment.productIdentifier

    if (transaction.error.code != SKErrorPaymentCancelled)
      finishTransaction(transaction, wasSuccessful:false)
    elsif transaction.error.code == SKErrorPaymentCancelled
      @fail.call(transaction)
    else
      SKPaymentQueue.defaultQueue.finishTransaction(transaction)
    end
  end

  def paymentQueue(queue,updatedTransactions:transactions)
    transactions.each do |transaction|
      if transaction.payment.productIdentifier == @product_id
        case transaction.transactionState
          when SKPaymentTransactionStatePurchased
            completeTransaction(transaction)
          when SKPaymentTransactionStateFailed
            failedTransaction(transaction)
          when SKPaymentTransactionStateRestored
            restoreTransaction(transaction)
          else 
        end
      end
    end
  end

end
