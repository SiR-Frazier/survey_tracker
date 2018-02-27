#!/usr/bin/ruby

class Question < ActiveRecord::Base
  has_many(:questions)
  belongs_to(:survey)
end
