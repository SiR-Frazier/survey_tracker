require('sinatra')
require('sinatra/reloader')
require('sinatra/activerecord')also_reload('lib/**.*.rb')
require('lib/survey-project')
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
  erb(:survey)
end

get('/surveys/:id/edit') do
  id = params.fetch(:id).to_i
  @survey = Survey.find(id)
  @questions = Question.where(:survey_id => id)
  erb(:survey_edit)
end

post('/surveys/:id/edit') do
  survey_id = params.fetch(:id).to_i
  question_name = params.fetch("question_name")
  answers = params.fetch("answers")
  Question.create({:question => question_name, :survey_id => survey_id})
  answers.each do |answer|
    Answer.create({:answer => answer, :question_id => })
  end
  erb(:survey_edit)
end

patch('/surveys/:id/edit') do
  survey_id = params.fetch(:id).to_i
  survey = params.fetch("survey")
  @survey = Survey.find(survey_id)
  @survey.update({:name => survey})
  @questions = Question.where(:survey_id => survey_id)
  erb(:survey_edit)
end

patch('/questions/:id/edit') do
  question_id = params.fetch(:id).to_i
  question_name = params.fetch("question")
  question = Question.find(question_id)
  question.update({:question => question})
  survey_id = question.survey_id
  @survey = Survey.find(survey_id)
  @questions = Question.where(:survey_id => survey_id)
  erb(:survey_edit)
end

post('/surveys/:id/add') do
  survey_id = params.fetch(:id).to_i
  @survey = Survey.find(survey_id)
  question_name = params.fetch("question_name")
  Question.create({:question => question_name, :survey_id => survey_id})
  @questions = Question.where(:survey_id => survey_id)
  erb(:survey_edit)
end

post('/questions/:id/add') do
  question_id = params.fetch(:id).to_i
  @question = Question.find(question_id)
  answers_input = params.fetch("answers")
  Answers.receive(answers_input)
  survey_id = question.survey_id
  @survey = Survey.find(survey_id)
  @questions = Question.where(:survey_id => survey_id)
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
  erb(:home)
end
