module Rorth
  def parse(expression)
    puts "=> #{expression}"
    begin
      expression.split.each { |statement| determine_action_for statement }
    rescue
      puts "Error: #{$!}"
    end
  end

  private

    def determine_action_for(statement)
      case
      when !$skip.nil? && statement != 'fi'
      when !$word.nil? && statement != ';'
        $word << statement
      when dictionary.has_key?(statement)
        dictionary[statement].call
      else Rorth.push statement.to_i
      end
    end
end
