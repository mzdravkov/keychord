require 'green_shoes'

# home keys are
# a o e u h t n s

home_keys = %w[a o e u h t n s]

# home keys' combinations

combinations = [["a", "o"],
                ["a", "e"],
                ["a", "u"],
                ["a", "h"],
                ["a", "t"],
                ["a", "n"],
                ["a", "s"],
                ["o", "e"],
                ["o", "u"],
                ["o", "h"],
                ["o", "t"],
                ["o", "n"],
                ["o", "s"],
                ["e", "u"],
                ["e", "h"],
                ["e", "t"],
                ["e", "n"],
                ["e", "s"],
                ["u", "h"],
                ["u", "t"],
                ["u", "n"],
                ["u", "s"],
                ["h", "t"],
                ["h", "n"],
                ["h", "s"],
                ["t", "n"],
                ["t", "s"],
                ["n", "s"]]

# letters that are not on the home keys

complex_letters = ('a'..'z').to_a # we start with all letters and remove those on home keys
home_keys.each { |hk| complex_letters.delete hk }

# combinations mapped
pairs = []
complex_letters.each_with_index do |v, i|
  pairs << combinations[i] << v
end
keys = Hash[*pairs]
p keys

last_key = nil
last_time = nil
textstr = ""
Shoes.app do
 e = edit_line
 info = para "NO KEY is PRESSED."
 text = para textstr
 keypress do |k|
   if last_key and Time.now - last_time < 0.1 and (keys[[last_key, k]] or keys[[k, last_key]])
     k = (keys[[last_key, k]] or keys[[k, last_key]])
     info.replace "#{k} was PRESSED."
     text.replace (textstr = textstr[0...-1])
     print k
   else
     info.replace "#{k} was PRESSED."
     print k
   end
   if k == 'BackSpace'
     text.replace (textstr = textstr[0...-1])
   else
     text.replace (textstr += k)
   end
   last_key = k
   last_time = Time.now
 end
end
