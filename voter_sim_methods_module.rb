module VoterSim

  def get_CLUD_choice
    clear
    puts "\nWould you like to ...\n\n"
    puts "\t(R)egister to vote or run for office?" # Create
    puts "\t(C)hange your registration information?" # Update
    puts "\t(U)nregister to vote or run for office?" # Delete
    puts "\tSee a (L)ist of voters or politicians?" # List
    puts "\t(G)enerate multiple voters?" # Generate
    puts "\tRun (S)imulation?" # Run
    puts "\tE(X)it the Voter Simulator?\n\n" # Exit
    prompt
    gets_clean
  end

  def validate_CLUD_choice(user_choice)
    acceptable_CLUD_answers = ['r', 'c', 'u', 'l', 'x', 'g', 's']
    validate_choice(user_choice, acceptable_CLUD_answers)
  end

  def validate_voter_candidate_choice(user_choice)
    acceptable_voter_candidate_answers = ['v', 'c']
    validate_choice(user_choice, acceptable_voter_candidate_answers)
  end

  def get_politician_or_voter(user_choice, string_input)
    clear
    puts "\nWill you be #{string_input} a (V)oter or a (C)andidate for office?"
    puts "(Registering as a candidate also registers you to vote)" if user_choice == 'r'
    puts
    prompt
    gets_clean
  end

  def get_name(first_or_last)
    clear
    puts "\nWhat is your #{first_or_last} name?\n\n"
    prompt
    gets_clean
  end

  def combine_names(first, last)
    "#{first} #{last}"
  end

  def get_ideology(clear_screen = 'n')
    clear if clear_screen == 'y'
    puts "\nWhich label best represents your ideology?\n\n"
    puts "\t(L)iberal\n\t(C)onservative\n\t(T)ea Party"
    puts "\t(S)ocialist\n\t(O)ther/Refuse to answer\n\n"
    prompt
    gets_clean
  end

  def validate_ideology_choice(user_choice)
    acceptable_ideology_answers = ['l', 'c', 't', 's', 'o']
    validate_choice(user_choice, acceptable_ideology_answers)
  end

  def convert_ideology(user_choice)
    choices = {
      l: "Liberal",
      c: "Conservative",
      t: "Tea Party",
      s: "Socialist",
      o: "Other/Independent"
    }
    choices.select { |k, v| k.to_s == user_choice }.flatten[1]
  end

  def display_voter_registration_confirmation(name, ideology)
    clear
    puts "\n\n#{name} has been registered to vote!"
    puts "Polls will classify you as a #{ideology} voter."
    enter_to_return
  end

  def get_party(clear_screen = 'n')
    clear if clear_screen == 'y'
    puts "\nWith which party would you like to register?\n\n"
    puts "\t(D)emocratic Party\n\t(R)epublican Party\n\t(I)ndependent\n\n"
    prompt
    gets_clean
  end

  def validate_party_choice(user_choice)
    acceptable_party_answers = ['d', 'r', 'i']
    validate_choice(user_choice, acceptable_party_answers)
  end

  def convert_party(user_choice)
    choices = {
      d: "Democrat",
      r: "Republican",
      i: "Independent"
    }
    choices.select { |k, v| k.to_s == user_choice }.flatten[1]
  end

  def display_politician_registration_confirmation(name, ideology, party)
    clear
    puts "\n\n#{name} has been registered to run for office!"
    puts "Polls will classify you as a #{ideology} politician."
    puts "You'll be running as a #{party}!"
    enter_to_return
  end

  def get_list_type
    clear
    puts "\nWhat would you like to see a list of?\n\n"
    puts "\t(C)andidates\n\t(V)oters\n\t(B)oth\n\n"
    prompt
    gets_clean
  end

  def validate_list_type(user_choice)
    acceptable_list_answers = ['c', 'v', 'b']
    validate_choice(user_choice, acceptable_list_answers)
  end

  def print_list(voters_or_politicians)
    clear
    if voters_or_politicians == 'c' || voters_or_politicians == 'b'
      puts "\nThese are all the registered candidates: \n\n"
      Politician.all_politicians.each do |politician|
        print "\t#{politician.name}: #{politician.class}, #{politician.party}, "
        puts "#{politician.ideology}"
      end
    end
    if voters_or_politicians == 'v' || voters_or_politicians == 'b'
      puts "\nThese are all the registered voters: \n\n"
      Voter.all_voters.each do |voter|
        puts "\t#{voter.name}: #{voter.class}, #{voter.ideology}"
      end
    end
    enter_to_return
  end

  def unregister_confirmation(name, pol)
    clear
    puts "\n#{name} has been deleted from the database"
    puts "\n#{name} is no longer registered to vote!"
    puts "#{name} is no longer registered to run for office!" if pol == true
  end

  def get_names_count
    clear
    puts "\nHow many voters would you like to generate?\n\n"
    prompt
    gets_clean.to_i
  end

  def validate_names_count(num_of_voters)
    if num_of_voters.class == Float || num_of_voters.class == Fixnum
      if num_of_voters > 0 && num_of_voters <= 5000
        return num_of_voters
      else
        invalid_response_output
        return false
      end
    else
      invalid_response_output
      return false
    end
  end

  def get_names_list(num_of_voters)
    myArr = File.read('names_list.txt').lines.map { |name| name.chomp }.shuffle
    delete_number = myArr.length - num_of_voters
    delete_number.times do
      myArr.delete_at(0)
    end
    myArr
  end

  def get_rands(num_of_voters)
    myArr = []
    num_of_voters.times do
      myArr << rand
    end
    myArr
  end

  def set_percentages
    clear
    puts "\nWhat percentage of voters believe in each ideology?"
    puts "Give percentages in the following order, separated by COMMAS!"
    puts "\nLiberal, Conservative, Tea Party, Socialist, Other\n\n"
    prompt
    myArr = gets_clean.split(',')
    myArr.map! { |ideology| ideology.strip.to_i }
    myArr
  end

  def convert_percentages(array_of_percentages)
    x = 1
    while x < array_of_percentages.length do
      array_of_percentages[x] += array_of_percentages[x-1]
      x += 1
    end
    array_of_percentages
  end

  def generate_voters(num_of_voters, array_of_percentages, names_array,
    rands_array)
    ideologies_array = ['Liberal', 'Conservative', 'Tea Party',
      'Socialist', 'Other']
    ideology = ''
    x = 0
    while x < num_of_voters
      stopper = false
      array_of_percentages.each do |y|
        if (rands_array[x] * 100) <= y.to_f && stopper == false
          ideology = ideologies_array[array_of_percentages.index(y)]
          stopper = true
        end
      end
      Voter.new(names_array[x], ideology)
      x += 1
    end
  end

  def run_simulation(voters_array, odds_hash)
    rands_array = get_rands(voters_array.length)
    x = 0
    while x < voters_array.length do
      current_voter = voters_array[x]
      current_voter_ideology = current_voter.ideology.strip.downcase.gsub(' ', '_').to_sym
      current_odds = odds_hash[current_voter_ideology]
      y = 0
      while y < current_odds.length
        if (rands_array[x] * 100) < current_odds[y]
          odds_hash[:votes][y] += 1
          y += 100
        end
        y += 1
      end
      x += 1
    end
    results_hash = {}
    z = 0
    while z < odds_hash[:votes].length
      results_hash[(odds_hash[:parties][z]).to_sym] = odds_hash[:votes][z]
      z += 1
    end
    results_hash
  end

  def get_number_candidates_by_party(all_politicians_array)
    candidates_hash = {
      republican: 0,
      democrat: 0,
      independent: 0
    }
    all_politicians_array.each do |x|
      candidates_hash[x.party.downcase.to_sym] += 1
    end
    candidates_hash
  end

  def get_votes_per_candidate(results_hash, num_candidates_hash, remainder = false)
    votes_per_cand = {
      republican: 0,
      democrat: 0,
      independent: 0
    }
    results_hash.keys.each do |x|
      if remainder == false
        votes_per_cand[x] = results_hash[x] / num_candidates_hash[x]
      elsif remainder == true
        votes_per_cand[x] = results_hash[x] % num_candidates_hash[x]
      end
    end
    return votes_per_cand
  end

end
