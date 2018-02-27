#!/usr/bin/ruby

class Survey < ActiveRecord::Base
  has_many(:questions)
end
