# only one method is needed for the demonstration purposes
class BillsController < ApplicationController
  def show
    # TODO: real data - uncomment when finished
    # url = 'http://safe-plains-5453.herokuapp.com/bill.json'
    # data = open(url)
    # @bill = JSON.load(data)

    # example data to avoid pounding the server during the tests
    @bill = example_data
  end
end
