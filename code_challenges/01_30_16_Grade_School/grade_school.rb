require 'pry'

class School
  attr_accessor :students

  def initialize
    @students = Hash.new { |students, grade| students[grade] = [] }
  end

  def add(name, grade)
    students[grade] << name
  end

  def grade(grade)
    students[grade]
  end

  def to_h
    students.each_value { |name| name.sort! }.sort.to_h
  end
end
