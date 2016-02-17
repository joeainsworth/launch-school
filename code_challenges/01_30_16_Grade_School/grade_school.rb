require 'pry'

class School
  attr_accessor :students

  def initialize
    @students = {}
  end

  def add(name, grade)
    if students.has_key?(grade)
      students[grade] << name
    else
      students[grade] = [name]
    end
  end

  def grade(grade)
    if students.has_key?(grade)
      students[grade]
    else
      []
    end
  end

  def to_h
    @students
  end
end
