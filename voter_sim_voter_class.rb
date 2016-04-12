class Voter < Citizen
  attr_accessor :name, :ideology

  @@all_voters = []
  def initialize(name, ideology)
    super(name)
    @ideology = ideology
    @@all_voters << self if self.class == Voter
  end

  def self.all_voters
    @@all_voters
  end

  def citizen_summary(update_or_delete)
    clear
    puts "\nYou've chosen to #{update_or_delete} #{@name}."
    puts "\n#{@name} is a #{@ideology} #{self.class}."
  end

  def update_ideology_question()
    clear
    puts "\n#{@name} is currently registered as a #{@ideology}."
    puts "\nWhat would you like to change his ideology to?\n\n"
  end

end
