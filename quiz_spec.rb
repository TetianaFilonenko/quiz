require './quiz'

describe Quiz do
  let(:quiz) { Quiz.new }

  before do
    @results = quiz.run
  end

  it "should retrieve a Hash" do
    expect(@results).to be_a(Hash)
  end

  it "should retrieve results for all dates and use the dates as keys in the Hash" do
    expect(@results.keys).to eq ["January 2, 2016",
                                 "January 3, 2016",
                                 "January 4, 2016",
                                 "January 5, 2016",
                                 "January 6, 2016",
                                 "January 7, 2016",
                                 "January 8, 2016",
                                 "January 9, 2016"]
  end

  it "should also have hashes for the values" do
    @results.values.each do |result|
      expect(result).to be_a(Hash)
    end
  end

  it "should use the columns names as keys in the result hash" do
    expect(@results.values[0].keys).to eq [:tests, :passes, :failures, :pending, :coverage]
  end

  it "should get results for January 6, 2016" do
    expect(@results["January 6, 2016"]).to be_a(Hash)
    
    jan6_results = @results["January 6, 2016"]
    expect(jan6_results[:tests]).to eq    "450"
    expect(jan6_results[:passes]).to eq   "423"
    expect(jan6_results[:failures]).to eq "20"
    expect(jan6_results[:pending]).to eq  "7"
    expect(jan6_results[:coverage]).to eq "76%"
  end
end