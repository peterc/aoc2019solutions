def deal(arr)
  arr.reverse
end

def cut(arr, amt)
  return arr if amt == 0
  arr[amt..-1] + arr[0..amt-1]
end

def deal_with_increment(arr, amt)
  pos = 0
  arr2 = []
  card_count = arr.length

  while card = arr.shift do
    arr2[pos] = card
    pos += amt
    pos %= card_count
  end
  
  arr2
end

cards = (0..10006).to_a

instructions = ARGF.read.split("\n").map(&:chomp)

instructions.each do |ins|
  cards = deal(cards) if ins == 'deal into new stack'

  if amt = ins[/^deal with increment (\d+)/, 1]
    cards = deal_with_increment(cards, amt.to_i)
  end

  if amt = ins[/^cut (\-?\d+)/, 1]
    cards = cut(cards, amt.to_i)
  end
end

p cards

p cards.index(2019)
