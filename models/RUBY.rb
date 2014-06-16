#!/usr/bin/env ruby

class String
  def to_rge
    if self =~ /^.+\.{2}.+$/
      ran = self.split('..')
      @a = (ran[0]..ran[1])
    elsif self =~ /^.+\.{3}.+$/
      ran = self.split('...')
      @a = (ran[0]..ran[1])
    else
      self
    end
  end
end

class Range
  def to_ary
    an = []
    self.each { |e| an << e }
    an
  end
end

class Array
  def etd_rge
    self.map do |e|
      if e.kind_of?(Range)
        e.to_ary 
      else
        e
      end
    end
    self.flatten
  end
  def etd_rge!
    self.map! do |e|
      if e.kind_of?(Range)
        e.to_ary 
      else
        e
      end
    end
    self.flatten!
  end
end


