common_words = ["one", "two", "three"]

uncommon_words = ["four", "five", "six"]

IO.write("common_words.txt", common_words.uniq.sort.join("\n"))

IO.write("words.txt", (common_words + uncommon_words).uniq.sort.join("\n"))
