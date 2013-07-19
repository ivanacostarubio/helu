#
# SKPaymentQueue
# + defaultQueue
#   - addTransactionObserver(observer)
#   - addPayment(product)
#   - finishTransaction(transaction)
# SKPayment
# + paymentWithProductIdentifier(id)
#

class Transaction
  def payment
    self
  end

  def productIdentifier
  end
end

class FakeQueue

  attr_accessor :added_observer, :payment_sent, :restoring

 def self.instance
    Dispatch.once { @instance ||= new }
    @instance
  end

  def addTransactionObserver(object)
    @added_observer = true
  end

  def addPayment(product)
    @payment_sent = true
  end

  def finishTransaction(transaction)
  end

  def restoreCompletedTransactions
    @restoring = true
  end
end


class SKPaymentQueue
  def self.defaultQueue
    FakeQueue.instance
  end
end



class SKPayment

  def self.paymentWithProductIdentifier(id)
  end
end


describe "public api" do

  before do
    @app = UIApplication.sharedApplication
  end

  it "adds the observer to self in initialization" do 
    FakeQueue.instance.added_observer.should == nil
    @carlos = Helu.new("wasa")
    FakeQueue.instance.added_observer.should == true
  end

  it "sends the request to apple" do
    @carlos = Helu.new("wasa")
    FakeQueue.instance.payment_sent.should == nil
    @carlos.buy
    FakeQueue.instance.payment_sent.should == true
  end

  it "can restore a transaction" do 
    @carlos = Helu.new("ibw")
    @carlos.restore = lambda { @@restore = true }
    FakeQueue.instance.restoring.should == nil
    @carlos.restore
    FakeQueue.instance.restoring.should == true
  end
  
  it "records the purchase on the locally" do 
    @carlos = Helu.new("ibw")
    @carlos.buy
    @carlos.winning = lambda { |t|  }
    @carlos.finishTransaction(Transaction.new, wasSuccessful:true)
    @carlos.bought?.should == true
  end

  it "knows if already purchase the product" do 
    Helu::LocalStorage.new.add("ibw")
    @carlos = Helu.new("ibw")
    @carlos.bought?.should == true
  end

end

describe "Helu::LocalStore" do 

  it "adds for the first time to the local store" do 
    Helu::LocalStorage.new.clean
    Helu::LocalStorage.new.all.should == []
    Helu::LocalStorage.new.add("ibw")
    Helu::LocalStorage.new.all.should == ["ibw"]
  end

  it "adds a new product to the local store" do
    Helu::LocalStorage.new.clean
    Helu::LocalStorage.new.add("ibw")
    Helu::LocalStorage.new.add("insight_10")
    Helu::LocalStorage.new.all.should == ["ibw", "insight_10"]
  end

end