class Helu
  
  attr_reader :product_id
  attr_accessor :storage, :winning, :restore, :fail

  class <<self
    # see product_info_fetcher.rb for info
    def fetch_product_info(*products, &b)
      ProductInfoFetcher.fetch(*products, &b)
    end
  end

  def initialize(product_id)
    @product_id = product_id
    SKPaymentQueue.defaultQueue.addTransactionObserver(self)
    @storage = LocalStorage.new
  end

  def buy
    payment = SKPayment.paymentWithProductIdentifier(product_id)
    SKPaymentQueue.defaultQueue.addPayment(payment)
  end

  def restore
    SKPaymentQueue.defaultQueue.restoreCompletedTransactions
  end

  def close
    SKPaymentQueue.defaultQueue.removeTransactionObserver(self)
  end

  def bought?
    @storage.all.include?(product_id)
  end

  def finishTransaction(transaction, wasSuccessful:wasSuccessful)
    SKPaymentQueue.defaultQueue.finishTransaction(transaction)
    if wasSuccessful 
      @winning.call(transaction)
      storage.add(product_id)
    else
      @fail.call(transaction)
    end
  end

  def completeTransaction(transaction)
    finishTransaction(transaction,wasSuccessful:true)
  end

  def restoreTransaction(transaction)
    finishTransaction(transaction,wasSuccessful:true)
  end

  def failedTransaction(transaction)
    if transaction.error && (transaction.error.code != SKErrorPaymentCancelled)
      finishTransaction(transaction, wasSuccessful:false)
    elsif transaction.error && (transaction.error.code == SKErrorPaymentCancelled)
      @fail.call(transaction)
    else
      SKPaymentQueue.defaultQueue.finishTransaction(transaction)
    end
  end

  def paymentQueue(queue,updatedTransactions:transactions)
    transactions.each do |transaction|
      if transaction.payment.productIdentifier == product_id
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

  def paymentQueueRestoreCompletedTransactionsFinished(queue)
    ids = []
    queue.transactions.each do |transaction|
      product_id = transaction.payment.productIdentifier
      ids << product_id
    end
    @restore.call if ids.uniq.include? product_id
  end


  class LocalStorage

    def clean
      defaults.setObject(nil, forKey: key_for_defaults)
      defaults.synchronize
    end

    def add(product_id)
      if all
        defaults.setObject([all, product_id].flatten, forKey: key_for_defaults)
      else
        defaults.setObject([product_id], forKey: key_for_defaults)
      end

      defaults.synchronize
    end

    def all
      return [] if defaults.valueForKey(key_for_defaults) == nil
      defaults.valueForKey(key_for_defaults)
    end

    private 

    def key_for_defaults
      "helu_products"
    end

    def defaults
      NSUserDefaults.standardUserDefaults
    end

  end

end
