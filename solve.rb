words = IO.read("./words.txt").split("\n")

class String

  def character_score
    {a: 286, b: 52, c: 119, d: 136, e: 445, f: 85, g: 66, h: 180, i: 269, j: 5, k: 19, l: 145, m: 89, n: 257, o: 272, p: 76, q: 4, r: 223, s: 232, t: 330, u: 97, v: 37, w: 59, x: 8, y: 59, z: 3}.fetch(self.to_sym) rescue 0
  end

  def score
    self.chars.reduce(0) {|collect, char|
      collect += char.character_score
    }
  end
end

puts "\nTOP 10"
words.select do |word|
  word if word.chars.uniq.count == 5
end.sort_by(&:score).reverse.take(10).each {|w| puts "#{w} (#{w.score})" }

puts "\nVOWELS"
words.select do |word|
  vowels = word.chars.uniq.select{|letter| /(a|e|i|o|u)/.match?(letter) }
  word if vowels.count >= 4
end.sort_by(&:score).reverse.each {|w| puts "#{w} (#{w.score})" }

puts "\nCOMMON LETTERS"
words.select do |word|
  interesting = word.chars.uniq.select{|letter| /(e|t|a|o|i|n|s|r|h|l|d|c)/.match?(letter) }
  word if
    interesting.count >= 5 &&
    word.match?(/(\w{2}r\w{2})/) &&
    word.match?(/(e)/) &&
    !word.match?(/(a|u|i)/)
end.sort_by(&:score).reverse.each {|w| puts "#{w} (#{w.score})" }

puts "\nGUESSES"
words.select do |word|
  word if
    # word.chars.uniq.count == 5 &&
    word.match?(/(\worge)/) &&
    # word.match?(/(r|a)/) &&
    !word.match?(/(m|n|b|p|a|u|i|t|s|f|c|h|d)/)
end.sort_by(&:score).reverse.each {|w| puts "#{w} (#{w.score})" }

