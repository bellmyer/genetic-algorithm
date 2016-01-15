class Password
  attr_reader :target_letters, :guess_letters
  
  LETTER_POOL = 'abcdefghijlkmnopqrstuvwxyz0123456789'.split('')
  TARGET = "secret4u"
  
  class << self
    def top_score
      TARGET.size
    end
  end
  
  def initialize *guess_letters
    @guess_letters = guess_letters
    @target_letters = TARGET.split('')
  end
  
  def score
    total = 0
    
    target_letters.each_with_index do |target_letter, i|
      total += 1 if target_letter == guess_letters[i]
    end
    
    total
  end
    
  def to_s
    guess_letters.join('')
  end
end