##############################################################################
# Basic methods

module MyMethods

  def clear
    system("clear")
  end

  def gets_clean
    gets.chomp.strip.downcase
  end

  def prompt
    print ">> "
  end

  def section_off
    puts "-" * 90 + "\n\n"
  end

  def validate_choice(user_choice, acceptable_answers)
    if acceptable_answers.include?(user_choice)
      user_choice
    else
      invalid_response_output
    end
  end

  def invalid_response_output
    puts "\n\nThat's not a valid response! Try again."
    sleep 1
    false
  end


  def should_be_impossible
    puts "\nT H I S  S H O U L D  N E V E R  P R I N T ! ! !"
    gets
  end

  def enter_to_return
    puts "\nPress ENTER to return to the welcome screen."
    gets_clean
  end

  def enter_to_continue(cancel_option = false)
    puts "\nPress ENTER to continue."
    puts "\nPress 'C' to cancel." if cancel_option == true
    gets_clean
  end

end
