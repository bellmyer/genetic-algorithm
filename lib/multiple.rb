# This is an example solution class. The score is just the result of multiplying
# all the numbers it was given upon initialization. The top score is arbitrary
# in this case.

class Multiple
  attr_reader :factors
  
  class << self
    def top_score
      1_000_000
    end
  end
  
  def initialize *params
    @factors = *params
  end
  
  def score
    factors.reduce(:*)
  end
  
  def to_s
    factors.map{|f| f.round(4)}.join(',')
  end
end