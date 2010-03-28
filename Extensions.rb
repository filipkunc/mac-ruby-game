# Extensions.rb
# MacRubyGame
#
# Created by Filip Kunc on 3/20/10.
# For license see LICENSE.TXT.

module Math
  def self.max(a, b)
    a > b ? a : b
  end

  def self.min(a, b)
    a < b ? a : b
  end
  
  def self.abs(a)
	a.abs
  end
  
  def self.absmax(a, b)
	a > 0 ?	max(a, b) : min(a, -b)
  end
  
  def self.absmin(a, b)
	a > 0 ? min(a, b) : max(a, -b)
  end
end


class Object
  def self.subclasses(direct = false)
    classes = []
    if direct
      ObjectSpace.each_object(Class) do |c|
        next unless c.superclass == self
        classes << c
      end
    else
      ObjectSpace.each_object(Class) do |c|
        next unless c.ancestors.include?(self) and (c != self)
        classes << c
      end
    end
    classes
  end
end
