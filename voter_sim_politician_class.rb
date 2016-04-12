class Politician < Voter
  attr_accessor :name, :ideology, :party, :votes

  @@all_politicians = []
  def initialize(name, ideology, party)
    super(name, ideology)
    @party = party
    @votes = 0
    @@all_politicians << self
  end

  def self.all_politicians
    @@all_politicians
  end

  def citizen_summary(update_or_delete)
    super(update_or_delete)
    puts "#{@name} belongs to the #{@party} Party."
  end

  def update_party_question()
    clear
    puts "\n#{@name} is currently registered as a #{@party}."
    puts "\nWhat would you like to change his party to?\n\n"
  end

  def apply_votes(results_hash)
    @votes += results_hash[@party.downcase.to_sym]
  end

  def remove_votes
    @votes = 0
  end

  def self.display_sim_results
    clear
    puts "\nHere are the results of the simulation: \n"
    highest_votes = 0
    winners = []
    vote_counts = []
    names = []
    @@all_politicians.each do |x|
      puts "\t#{x.name} received #{x.votes} votes."
      highest_votes = x.votes if x.votes > highest_votes
    end
    @@all_politicians.each do |x|
      if x.votes == highest_votes
        winners << x.name
      end
    end
    if winners.length > 1
      print "\nIt's a tie!"
    else
      puts "\n#{winners[0]} wins!\n"
    end
    enter_to_return
  end

  def self.reset_votes
    @@all_politicians.each { |x| x.remove_votes }
  end

  def self.shuffle_politicians
    @@all_politicians.shuffle!
  end

  def self.apply_all_votes(results_hash)
    @@all_politicians.each do |x|
      x.apply_votes(results_hash)
    end
  end

  def self.apply_leftover_votes(leftover_hash)
    leftover_hash.each do |x, y|
      while y > 0 do
        @@all_politicians.each do |z|
          if z.party.downcase == x.to_s
            z.votes += 1
            y -= 1
            break if y <= 0
          end
        end
      end
    end
  end

end
