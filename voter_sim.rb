require './voter_sim_citizen_class.rb'
require './voter_sim_voter_class.rb'
require './voter_sim_politician_class.rb'
require './voter_sim_methods_module.rb'
require './my_methods.rb'

include VoterSim
include MyMethods

###########################################################################
# Auto-create voters and candidates for Testing
# Voter.new("Mike Gregory", "Tea Party")
# Voter.new("Chris Tucker", "Liberal")
# Voter.new("Tim Ferris", "Conservative")
# Politician.new("Ron Paul", "Tea Party", "Independent")
# Politician.new("Bernie Sanders", "Socialist", "Democrat")
###########################################################################
# Real Presidential candidates
Politician.new("Bernie Sanders", "Socialist", "Democrat")
Politician.new("Hillary Clinton", "Liberal", "Democrat")
Politician.new("Donald Trump", "Conservative", "Republican")
Politician.new("Ted Cruz", "Tea Party", "Republican")
Politician.new("Gary Johnson", "Independent", "Independent" )
###########################################################################
# Odds Hash
odds = {
  parties: ['republican', 'democrat', 'independent'],
  votes: [0, 0, 0],
  liberal: [19, 99, 100],
  conservative: [80, 99, 100],
  tea_party: [60, 90, 100],
  socialist: [30, 90, 100],
  other: [40, 80, 100]
}
###########################################################################
# Game Flow

# Create Sim Loop
sim_on = true
while sim_on

  # Give user options, get user_choice, validate user_choice
  user_choice = false
  while user_choice == false
    user_choice = get_CLUD_choice
    user_choice = validate_CLUD_choice(user_choice)
  end

  # p user_choice

  case user_choice

    # Enter create process
  when 'r'
    string_input = 'registering as'
    user_choice = false
    while user_choice == false
      user_choice = get_politician_or_voter('r', string_input)
      user_choice = validate_voter_candidate_choice(user_choice)
    end
    # Enter create voter process
    if user_choice == 'v'
      # Get name
      first_name = get_name('first').capitalize
      last_name = get_name('last').capitalize
      name = combine_names(first_name, last_name)

      # Get ideology
      ideology = false
      while ideology == false
        ideology = get_ideology('y')
        ideology = validate_ideology_choice(ideology)
      end
      ideology = convert_ideology(ideology)

      # Create voter
      Voter.new(name, ideology)
      # p Citizen.all_citizens
      # gets
      display_voter_registration_confirmation(name, ideology)

      # Enter create candidate process
    elsif user_choice == 'c'
      # Get name
      first_name = get_name('first').capitalize
      last_name = get_name('last').capitalize
      p name = combine_names(first_name, last_name)

      # Get ideology
      ideology = false
      while ideology == false
        ideology = get_ideology('y')
        ideology = validate_ideology_choice(ideology)
      end
      ideology = convert_ideology(ideology)

      # Get party
      party = false
      while party == false
        party = get_party('y')
        party = validate_party_choice(party)
      end
      party = convert_party(party)

      # Create Politician
      Politician.new(name, ideology, party)
      # p Citizen.all_citizens
      # gets
      display_politician_registration_confirmation(name, ideology, party)
    else
      should_be_impossible
    end

    # Enter update process
  when 'c'
    string_input = 'updating'
    valid_answer = false
    while valid_answer == false
      first_name = get_name('first').capitalize
      last_name = get_name('last').capitalize
      name = combine_names(first_name, last_name)
      valid_answer, citizen_index = Citizen.is_citizen?(name)
      invalid_response_output if valid_answer == false
    end
    current_citizen = Citizen.all_citizens[citizen_index]
    user_choice = false
    while user_choice == false
      current_citizen.citizen_summary('update')
      user_choice = enter_to_continue(true)
      user_choice = validate_choice(user_choice, ['c', ''])
    end
    next if user_choice == 'c'
    user_choice = false
    while user_choice == false
      current_citizen.update_ideology_question
      user_choice = get_ideology('n')
      user_choice = validate_ideology_choice(user_choice)
    end
    user_choice = convert_ideology(user_choice)
    current_citizen.ideology = user_choice
    if current_citizen.is_politician?
      user_choice = false
      while user_choice == false
        current_citizen.update_party_question
        user_choice = get_party('n')
        user_choice = validate_party_choice(user_choice)
      end
      user_choice = convert_party(user_choice)
      current_citizen.party = user_choice
    elsif current_citizen.is_voter?
    else
      should_be_impossible
    end

    # Enter delete process
  when 'u'
    string_input = 'removing'
    valid_answer = false
    while valid_answer == false
      first_name = get_name('first').capitalize
      last_name = get_name('last').capitalize
      name = combine_names(first_name, last_name)
      valid_answer, citizen_index = Citizen.is_citizen?(name)
      invalid_response_output if valid_answer == false
    end
    current_citizen = Citizen.all_citizens[citizen_index]
    current_citizen_name = current_citizen.name
    pol = current_citizen.is_politician? ? true : false
    user_choice = false
    while user_choice == false
      current_citizen.citizen_summary('delete')
      user_choice = enter_to_continue(true)
      user_choice = validate_choice(user_choice, ['c', ''])
    end
    if user_choice == ''
      unregister_confirmation(name, pol)
      enter_to_continue
      Citizen.all_citizens.delete(current_citizen)
      Voter.all_voters.delete(current_citizen) if pol == false
      Politician.all_politicians.delete(current_citizen) if pol == true
      clear
    else
      clear
      puts "\nRegistration deletion cancelled!"
      enter_to_return
    end

  when 'l'
    list_type = false
    while list_type == false
      list_type = get_list_type
      list_type = validate_list_type(list_type)
    end
    case list_type
    when 'v'
      print_list('v')
    when 'c'
      print_list('c')
    when 'b'
      print_list('b')
    else
      should_be_impossible
    end
  when 'g'
    num_voters = false
    while num_voters == false
      num_voters = get_names_count
      num_voters = validate_names_count(num_voters)
    end
    names_array = get_names_list(num_voters)
    rands_array = get_rands(num_voters)
    array_sum = 0
    while array_sum != 100
      target_percentages = set_percentages
      array_sum = target_percentages.inject(0, :+)
      if array_sum != 100
        invalid_response_output
      end
    end
    target_percentages = convert_percentages(target_percentages)
    generate_voters(num_voters, target_percentages, names_array, rands_array)
    print_list('v')
  when 's'
    results_hash = run_simulation(Voter.all_voters, odds)
    candidate_count_hash = get_number_candidates_by_party(Politician.all_politicians)
    leftover_hash = get_votes_per_candidate(results_hash, candidate_count_hash, true)
    results_hash = get_votes_per_candidate(results_hash, candidate_count_hash)
    Politician.shuffle_politicians
    Politician.apply_all_votes(results_hash)
    Politician.apply_leftover_votes(leftover_hash)
    Politician.display_sim_results
    Politician.reset_votes
    odds[:votes] = [0, 0, 0]
  when 'x'
    clear
    exit
  else
    should_be_impossible
  end
end
###########################################################################
