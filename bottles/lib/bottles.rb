module BottleNumberFactory
  refine Fixnum do
    def to_bottle_number
      BottleNumber.for(self)
    end
  end
end

using BottleNumberFactory

class Bottles
  def song
    verses(99, 0)
  end

  def verses(upper, lower)
    upper.downto(lower).map { |i| verse(i) }.join("\n")
  end

  def verse(number)
    bottle_number = number.to_bottle_number

    "#{bottle_number} of beer on the wall, ".capitalize +
    "#{bottle_number} of beer.\n" +
    "#{bottle_number.action}, " +
    "#{bottle_number.successor} of beer on the wall.\n"
  end

end

class BottleNumber

  # 5b, candidates register themselves
  def self.register(candidate)
    registry.unshift(candidate)
  end

  def self.registry
    @@registry ||= []
  end

  register(self)


  # 5a, registry requires inheritance
  # def self.inherited(subclass)
  #   @@registry ||= [self]
  #   @@registry.unshift(subclass)
  # end


  def self.for(number)

    ######
    # 5. Open, disperses choosing logic, requires registry
    ######

    @@registry.detect { |klass|
       klass.handles?(number) }.new(number)


    ######
    # 4. Closed, any class name, disperses choosing logic
    ######
    # [BottleNumber1, BottleNumber0, BottleNumber].detect { |klass|
    #    klass.handles?(number) }.new(number)

    ######
    # 3. Closed, can use any class name,
    #  approach openness via YML, or database
    ######
    # Hash.new(BottleNumber).merge(
    #   {0 => BottleNumber0, 1 => BottleNumber1})[number].new(number)

    ######
    # 2. Open, harder to understand, must follow convention
    ######
    # begin
    #   Object.const_get("BottleNumber#{number}")
    # rescue
    #   BottleNumber
    # end.new(number)

    ######
    # 1. Closed, easy to understand
    ######
    # case number
    # when 0
    #   BottleNumber0
    # when 1
    #   BottleNumber1
    # else
    #   BottleNumber
    # end.new(number)
  end

  def self.handles?(number)
    true
  end

  attr_reader :number

  def initialize(number)
    @number = number
  end

  def to_s
    "#{amount} #{container}"
  end

  def container
    "bottles"
  end

  def pronoun
    "one"
  end

  def amount
    number.to_s
  end

  def action
    "Take #{pronoun} down and pass it around"
  end

  def successor
    (number - 1).to_bottle_number
  end
end

class BottleNumber0 < BottleNumber
  register(self)

  def self.handles?(number)
    number == 0
  end

  def amount
    "no more"
  end

  def action
    "Go to the store and buy some more"
  end

  def successor
    99.to_bottle_number
  end
end

class BottleNumber1 < BottleNumber
  register(self)

  def self.handles?(number)
    number == 1
  end

  def container
    "bottle"
  end

  def pronoun
    "it"
  end
end
