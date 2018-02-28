require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')
also_reload('lib/**.*.rb')
require('./lib/answer')
require('./lib/question')
require('./lib/survey')
require('pry')
require('pg')

get('/') do
  @surveys = Survey.all()
  erb(:home)
end

post('/') do
  survey_name = params.fetch("survey_name")
  Survey.create({:name => survey_name})
  @surveys = Survey.all()
  erb(:home)
end

get('/surveys/:id') do
  id = params.fetch(:id).to_i
  @survey = Survey.find(id)
  @questions = Question.where(:survey_id => id)
  @answers = Answer.all
  erb(:survey)
end

get('/surveys/:id/edit') do
  id = params.fetch(:id).to_i
  @survey = Survey.find(id)
  @questions = Question.where(:survey_id => id)
  @answers = Answer.all
  erb(:survey_edit)
end

patch('/surveys/:id/edit') do
  survey_id = params.fetch(:id).to_i
  survey = params.fetch("survey")
  @survey = Survey.find(survey_id)
  @survey.update({:name => survey})
  @questions = Question.where(:survey_id => survey_id)
  @answers = Answer.all
  erb(:survey_edit)
end

patch('/questions/:id/edit') do
  question_id = params.fetch(:id).to_i
  question_name = params.fetch("question")
  question = Question.find(question_id)
  question.update({:question => question_name})
  survey_id = question.survey_id
  @survey = Survey.find(survey_id)
  @questions = Question.where(:survey_id => survey_id)
  @answers = Answer.all
  erb(:survey_edit)
end

post('/surveys/:id/add') do
  survey_id = params.fetch(:id).to_i
  @survey = Survey.find(survey_id)
  question_name = params.fetch("question_name")
  Question.create({:question => question_name, :survey_id => survey_id})
  @questions = Question.where(:survey_id => survey_id)
  @answers = Answer.all
  erb(:survey_edit)
end

post('/questions/:id/add') do
  question_id = params.fetch(:id).to_i
  @question = Question.find(question_id)
  answers_input = params.fetch("answers")
  Answer.receive(answers_input, question_id)
  survey_id = @question.survey_id
  @survey = Survey.find(survey_id)
  @questions = Question.where(:survey_id => survey_id)
  @answers = Answer.all
  erb(:survey_edit)
end

delete('/surveys/:id/delete') do
  survey_id = params.fetch(:id).to_i
  survey = Survey.find(survey_id)
  survey.delete()
  questions = Question.where(:survey_id => survey_id)
  questions.each do |q|
    q.delete()
  end
  @surveys = Survey.all()
  erb(:home)
end

delete('/questions/:id/delete') do
  question_id = params.fetch(:id).to_i
  question = Question.find(question_id)
  survey_id = question.survey_id
  question.delete()
  answers = Answer.where(:question_id => question_id)
  answers.each do |a|
    a.delete()
  end
  @survey = Survey.find(survey_id)
  @questions = Question.where(:survey_id => survey_id)
  @answers = Answer.all
  erb(:survey_edit)
end

delete('/questions/:id/answers/delete') do
  question_id = params.fetch(:id).to_i
  answers = Answer.where({:question_id => question_id})
  answers.each do |answer|
    answer.delete()
  end
  question = Question.find(question_id)
  survey_id = question.survey_id
  @survey = Survey.find(survey_id)
  @questions = Question.where(:survey_id => survey_id)
  @answers = Answer.all
  erb(:survey_edit)
end
