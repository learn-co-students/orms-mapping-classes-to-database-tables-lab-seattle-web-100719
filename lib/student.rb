class Student
  attr_reader :id
  attr_accessor :name, :grade

  def initialize(id = nil, name, grade)
        @id = id
        @name = name
        @grade = grade
    end

    def self.all
        sql = "SELECT * FROM students"
        students = DB[:conn].execute(sql)
        students.map do |student|
            Student.new(student)
        end
        
    end

    #CREATE
    def self.create_table
        DB[:conn].execute("CREATE TABLE students(id INTEGER PRIMARY KEY, name TEXT, grade TEXT)")
    end

    #CREATE 
    def save
      sql = "INSERT INTO students(name, grade) VALUES (?, ?)" #inserted the new student with the values of this student
      DB[:conn].execute(sql, @name, @grade) # execute the SQL command to do database stuff
      sql = "SELECT * FROM students ORDER BY id DESC LIMIT 1" # selected the newly added database student
      ret = DB[:conn].execute(sql)[0] # execute SQL command to grab the array that was the new student
      @id = ret[0] # grab the id of the student which was the 0th element of the array and set it as THIS student's id
      self # return the array (instance values) of the newly added student
    end

    #CREATE
    def self.create(name:, grade:)
      # create a new student instance
      # save that instance

      new_student = Student.new(name, grade)
      binding.pry
      new_student.save
    end

    #READ
    def self.find_by_id(id)
        sql = "SELECT * FROM students WHERE id = ?"
        student_obj = DB[:conn].execute(sql, id)[0]
        Student.new(student_obj)
    end

    #READ


    #UPDATE
    def self.update(id, value)
        sql = "UPDATE students SET name = ? WHERE id = ?"
        DB[:conn].execute(sql, name, id)
        potato_hash = find_by_id(id)
        Student.new(potato_hash)
    end

    #DELETE
    def self.drop_table
        DB[:conn].execute("DROP TABLE students")
    end
 
end
