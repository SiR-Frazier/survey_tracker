#!/usr/bin/ruby

class Answer < ActiveRecord::Base
  belongs_to(:question)

  def self.receive(input, q_id)
    answers = input.split(", ")
    answers.each do |answer|
      Answer.create({:answer => answer, :question_id => q_id})
    end
  end
end
