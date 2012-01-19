module Rorth
  def self.pop
    stack.pop || raise(StackUnderflow)
  end

  def self.push(expression)
    stack expression
  end

  def self.swap
    stack[-2,2] = stack[-2,2].reverse
  end

  def stack(value = nil)
    @stack ||= []
    if value.nil? then @stack else @stack << value end
  end
end