class HelloWorld
  attr_reader :target, :letters
  
  LETTER_POOL = (
    ('a'..'z').to_a +
    ('A'..'Z').to_a +
    '!?.,-_ '.split('')
  )
  
  TARGET = "Hello, World!"
  
  class << self
    def top_score
      return @top_score if defined?(@top_score)
      @top_score = TARGET.size
    end
  end
  
  def initialize *letters
    @letters = letters
    @target = TARGET.split('')
  end
  
  def score
    total = 0
    
    target.each_with_index do |target_letter, i|
      total += 1 if target_letter == letters[i]
    end
    
    total
  end
    
  def to_s
    letters.join('')
  end
end