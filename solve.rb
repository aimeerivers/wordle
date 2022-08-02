class String
  def character_score
    { a: 286, b: 52, c: 119, d: 136, e: 445, f: 85, g: 66, h: 180, i: 269, j: 5, k: 19, l: 145, m: 89, n: 257, o: 272, p: 76, q: 4, r: 223, s: 232, t: 330, u: 97, v: 37, w: 59, x: 8, y: 59, z: 3 }.fetch(self.to_sym) rescue 0
  end

  def score
    self.chars.uniq.reduce(0) { |collect, char|
      collect += char.character_score
    }
  end
end

class Solve
  attr_accessor :known_letters, :known_wrong, :included_letters, :eliminated_letters

  def initialize
    @tries = 0
    @words = IO.read("./words.txt").split("\n")
    @common_words = IO.read("./common_words.txt").split("\n")
    @known_letters = ["", "", "", "", ""]
    @known_wrong = [[], [], [], [], []]
    @included_letters = []
    @eliminated_letters = []

    instructions

    try(high_vowels.take(10).shuffle)

    while !solved? && @tries < 3
      try(filter_guesses(common_letters).take(10))
    end

    while !solved? && @tries < 5
      try(filter_guesses(@common_words).take(10))
    end

    if !solved?
      final_guesses = filter_guesses(@common_words)
      if final_guesses.size == 1
        puts "\nLast guess! Pretty sure it is:"
      else
        puts "\nYour final guess must be one of these:"
      end
      try(final_guesses)
    end

    if solved?
      puts "\nThe word was: #{@known_letters.join.upcase}"
    end
  end

  def instructions
    puts "\nTry each suggestion in Wordle, and type in the result."
    puts "For a green letter, type a 'g', for a yellow letter, a 'y'"
    puts "For all other letters, type an 'x'"
    puts "Example result: xxgyx\n"
  end

  def solved?
    !@known_letters.include?("")
  end

  def try(guesses)
    @tries += 1
    puts "\nGuess #{@tries}:  #{guesses.join(", ").upcase}"
    print "Guess:    "
    guess = gets.chomp.downcase
    print "Result:   "
    result = gets.chomp

    guess_chars = guess.chars

    result.chars.each_with_index do |feedback, idx|
      @known_letters[idx] = guess_chars[idx] if feedback == "g"
      if feedback == "x"
        @known_wrong[idx] << guess_chars[idx]
        @eliminated_letters << guess_chars[idx] unless @known_letters.include?(guess_chars[idx])
      end
      if feedback == "y"
        @included_letters << guess_chars[idx]
        @known_wrong[idx] << guess_chars[idx]
      end
    end

    @eliminated_letters.uniq!
    @included_letters.uniq!

    # puts @known_letters.inspect
    # puts @known_wrong.inspect
    # puts @included_letters.inspect
    # puts @eliminated_letters.inspect
  end

  def high_vowels
    @words.select do |word|
      vowels = word.chars.uniq.select { |letter|
        Regexp.union("aeiou".chars).match?(letter)
      }
      word if vowels.count >= 4
    end.sort_by(&:score).reverse
  end

  def minimal_letters
    @words.select do |word|
      unique_letters = word.chars.uniq
      word if unique_letters.count <= 2
    end.sort_by(&:score).reverse
  end

  def common_letters
    @common_words.select do |word|
      interesting = word.chars.uniq.select { |letter|
        Regexp.union("etaoinsrhldc".chars).match?(letter)
      }
      word if interesting.count >= 3
    end.sort_by(&:score).reverse
  end

  def filter_guesses(guesses)
    known_regex = /#{@known_letters.map { |l| l == "" ? /\w/ : l }.join}/
    eliminated_regex = Regexp.union(@eliminated_letters)
    guesses.select do |word|
      word if word.match?(known_regex) &&
              @included_letters.all? { |l| word.include?(l) } &&
              !word.match?(eliminated_regex) &&
              !@known_wrong[0].include?(word[0]) &&
              !@known_wrong[1].include?(word[1]) &&
              !@known_wrong[2].include?(word[2]) &&
              !@known_wrong[3].include?(word[3]) &&
              !@known_wrong[4].include?(word[4])
    end.sort_by(&:score).reverse
  end

  def low_character_count_words
    @words.select do |word|
      word if word.chars.uniq.count < 3
    end
  end

  def no_vowel_words
    @words.select do |word|
      word unless Regexp.union("aeiou".chars).match?(word)
    end
  end
end

Solve.new
