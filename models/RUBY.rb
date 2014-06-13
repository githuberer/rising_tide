#!/usr/bin/env ruby

class String
  def to_range
    if self =~ /^.\.{2}.$/
      ran = self.split('..')
      @a = (ran[0]..ran[1])
    elsif self =~ /^.\.{3}.$/
      ran = self.split('...')
      @a = (ran[0]..ran[1])
    end
    @a
  end
end


class Array
  def flatten_ran
  end
end


