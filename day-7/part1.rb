$card_values = {
    "A":14,
    "K":13,
    "Q":12,
    "J":11,
    "T":10,
    "9":9,
    "8":8,
    "7":7,
    "6":6,
    "5":5,
    "4":4,
    "3":3,
    "2":2
}

class Hand
    attr_reader :cards
    attr_reader :type
    attr_reader :type_value
    attr_reader :bet

    def initialize(cards, bet)
        @cards = cards
        @bet = Integer(bet)
        set_type
    end

    def <=>(other)
        if @type_value == other.type_value
            (0..5).each do |index|
                if @cards[index] != other.cards[index]
                    return $card_values[@cards[index].to_sym] <=> $card_values[other.cards[index].to_sym]
                end
            end
            p "Something went wrong"
        else
            @type_value <=> other.type_value
        end
    end


    private

    def set_type
        card_types = Hash.new
        @cards.chars.map { |card| card_types[card] = (card_types[card] || 0) + 1 }
        if card_types.values.include?(5)
            @type = 'five of a kind'
            @type_value = 6
        elsif card_types.values.include?(4)
            @type = 'four of a kind'
            @type_value = 5
        elsif card_types.values.include?(3) 
            if card_types.values.include?(2)
                @type = 'full house'
                @type_value = 4
            else
                @type = 'three of a kind'
                @type_value = 3
            end
        elsif card_types.values.count(2) == 2
            @type = 'two pair'
            @type_value = 2
        elsif card_types.values.count(2) == 1
            @type = 'one pair'
            @type_value = 1
        else
            @type = 'high card'
            @type_value = 0
        end
    end
end



hands = []
File.readlines('./input.txt', chomp: true).each do |line|
    tokens = line.split(' ')
    hands << Hand.new(tokens[0], tokens[1])
    #p hands
end

sorted_hands = hands.sort

total_value = 0
sorted_hands.each_with_index do |hand, index|
    #p "#{hand.cards} #{hand.type_value}"
    total_value += (hand.bet * (index + 1))
end
p "total value: #{total_value}"
