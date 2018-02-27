#!/usr/bin/ruby

class Answer < ActiveRecord::Base
  belongs_to(:question)
end
