require 'green_shoes'

home_keys = %w[a o e u h t n s]

# optimized combinations
#[["u", "e"],
# ["u", "o"],
# ["u", "a"],
# ["u", "h"],
# ["u", "t"],
# ["u", "n"],
# ["u", "s"],
# ["e", "o"],
# ["e", "a"],
# ["e", "h"],
# ["e", "t"],
# ["e", "n"],
# ["e", "s"],
# ["o", "a"],
# ["o", "h"],
# ["o", "t"],
# ["o", "n"],
# ["o", "s"],
# ["a", "h"],
# ["a", "t"],
# ["a", "n"],
# ["a", "s"],
# ["h", "t"],
# ["h", "n"],
# ["h", "s"],
# ["t", "n"],
# ["t", "s"],
# ["n", "s"]]

# letters that are not on the home keys
keys = {
  ['u', 'e'] => 'i',
  ['u', 'h'] => 'r',
  ['u', 't'] => 'd',
  ['u', 'o'] => 'l',
  ['u', 'n'] => 'c',
  ['e', 'h'] => 'm',
  ['e', 'o'] => 'w',
  ['e', 't'] => 'f',
  ['e', 'n'] => 'g',
  ['o', 'h'] => 'y',
  ['o', 't'] => 'p',
  ['o', 'n'] => 'b',
  ['u', 's'] => 'v',
  ['u', 'a'] => 'k',
  ['e', 's'] => 'j',
  ['e', 'a'] => 'x',
  ['o', 's'] => 'q',
  ['a', 'h'] => 'z',

}


complex_letters = keys.sort_by { |k, v| v }

last_key = nil
last_time = nil
textstr = ""
Shoes.app do
 e = edit_line
 info = para "NO KEY is PRESSED."
 text = para textstr
 info_complex_keys = para "Complex keys: \n"
 complex_letters.each do |k, v|
   info_complex_keys.text = info_complex_keys.text + "#{v} -> #{k[0]} + #{k[1]}\n"
 end
 keypress do |k|
   if last_key and Time.now - last_time < 0.1 and (keys[[last_key, k]] or keys[[k, last_key]])
     k = (keys[[last_key, k]] or keys[[k, last_key]])
     text.replace (textstr = textstr[0...-1])
   end
   info.replace "#{k} was PRESSED."
   new_text = if k == 'BackSpace'
     textstr = textstr[0...-1]
   else
     textstr += k
   end
   text.replace new_text
   last_key = k
   last_time = Time.now
 end
end
