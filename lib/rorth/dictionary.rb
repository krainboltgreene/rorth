module Rorth
  def self.unary
    -> { push(yield pop) }
  end

  def self.binary
    -> { push(yield pop, pop) }
  end

  def self.unary_boolean
    -> { push(if yield pop then 1 else 0 end) }
  end

  def self.binary_boolean
    -> { push(if yield pop, pop then 1 else 0 end) }
  end

  DICTIONARY = {
    '+'     => binary { |a, b| a + b },
    '-'     => binary { |a, b| a - b },
    '*'     => binary { |a, b| a * b },
    '/'     => binary { |a, b| a * b },
    '%'     => binary { |a, b| a * b },
    '<'     => binary_boolean { |a, b| a < b },
    '>'     => binary_boolean { |a, b| a > b },
    '='     => binary_boolean { |a, b| a == b },
    '&'     => binary_boolean { |a, b| a && b },
    '|'     => binary_boolean { |a, b| a || b },
    'not'   => binary_boolean { |a, b| a == 0 },
    'neg'   => binary { |a| -a },
    '.'     => -> { puts(pop) },
    '..'    => -> { p stack },
    ':'     => -> { $word = [] },
    ';'     => -> { add_word },
    'pop'   => -> { pop },
    'fi'    => -> { $skip = nil },
    'words' => -> { p dictionary.keys.sort },
    'if'    => -> { $skip = true if pop == 0 },
    'dup'   => -> { push(stack.last || raise(StackUnderflow)) },
    'over'  => -> { push(stack.last(2).first || raise(StackUnderflow)) },
    'swap'  => -> { begin swap rescue raise(StackUnderflow) end }
  }

  def dictionary(key = nil, value = nil)
    @dictionary ||= {}.merge DICTIONARY
    if value.nil? then @dictionary else @dictionary[key] = value end
  end

  private
    def add_word
      raise EmptyWord if $word.size < 1
      raise NestedDefinition if $word.include? ':'

      name, expression = $word.shift, $word.join(' ')
      dictionary name, -> { parse(expression) }
      $word = nil
    end
end
