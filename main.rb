require 'green_shoes'

# in dvorak
home_keys = %w[a o e u h t n s]
# in qwerty
qwerty_home_keys = %w[a s d f j k l ;]

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

keys = {}

# letters that are not on the home keys
keys['dvorak'] = {
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
  ['a', 'h'] => 'z'
}

keys['qwerty'] = {
  'a' => 'a',
  's' => 'o',
  'd' => 'e',
  'f' => 'u',
  'j' => 'h',
  'k' => 't',
  'l' => 'n',
  ';' => 's',
  ['f', 'd'] => 'i',
  ['f', 'j'] => 'r',
  ['f', 'k'] => 'd',
  ['f', 's'] => 'l',
  ['f', 'l'] => 'c',
  ['d', 'j'] => 'm',
  ['d', 's'] => 'w',
  ['d', 'k'] => 'f',
  ['d', 'l'] => 'g',
  ['s', 'j'] => 'y',
  ['s', 'k'] => 'p',
  ['s', 'l'] => 'b',
  ['f', ';'] => 'v',
  ['f', 'a'] => 'k',
  ['d', ';'] => 'j',
  ['d', 'a'] => 'x',
  ['s', ';'] => 'q',
  ['a', 'j'] => 'z'
}



layout = 'dvorak'
complex_letters = keys[layout].sort_by { |k, v| v }

last_key = nil
last_time = nil
textstr = ""
Shoes.app do
  e = edit_line
  layout_info = para layout
  info_complex_keys = para ""
  button 'Change layout' do
    info_complex_keys.replace "Complex keys: \n result - input\n"
    if layout == 'dvorak'
      layout_info.replace (layout = 'qwerty')
      complex_letters = keys['qwerty'].sort_by { |k, v| v }
      qwerty_home_keys.each do |k|
        info_complex_keys.text = info_complex_keys.text + "     #{keys['qwerty'][k]} - #{k}\n"
      end
      complex_letters.each do |k, v|
        if k.is_a? Array
          info_complex_keys.text = info_complex_keys.text + "     #{v} - #{k[0]} + #{k[1]}\n"
        end
      end
    else
      layout_info.replace (layout = 'dvorak')
      complex_letters = keys['dvorak'].sort_by { |k, v| v }
      complex_letters.each do |k, v|
        info_complex_keys.text = info_complex_keys.text + "     #{v} - #{k[0]} + #{k[1]}\n"
      end
    end
  end
  info = para "NO KEY is PRESSED."
  text = para textstr
  info_complex_keys = para "Complex keys: \n result - input\n"

  complex_letters.each do |k, v|
    info_complex_keys.text = info_complex_keys.text + "     #{v} - #{k[0]} + #{k[1]}\n"
  end
  keypress do |k|
    if layout == 'qwerty' and qwerty_key_index = qwerty_home_keys.index(k)
      k = home_keys[qwerty_key_index]
    end
    if last_key and Time.now - last_time < 0.05 and (keys['dvorak'][[last_key, k]] or keys['dvorak'][[k, last_key]])
      k = (keys['dvorak'][[last_key, k]] or keys['dvorak'][[k, last_key]])
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
