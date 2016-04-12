class Citizen
  @@all_citizens = []
  def initialize(name)
    @name = name
    @@all_citizens << self
  end

  def is_politician?
    self.class.ancestors.include?(Politician) ? true : false
  end

  def is_voter?
    self.class.ancestors.include?(Voter) ? true : false
  end

  def self.is_citizen?(name)
    @@all_citizens.each do |citizen|
      if citizen.name == name
        return true, @@all_citizens.index(citizen)
      end
    end
    return false, nil
  end

  def self.all_citizens
    @@all_citizens
  end
end
