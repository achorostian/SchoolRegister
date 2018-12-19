require_relative '../lib/Register.rb'

describe "Checking Note class initialization" do
  before{
    @note = Note.new
  }

  it "Returns not nil while created" do
    expect(@note).not_to be nil
  end

  it "Returns instance of Note while created" do
    expect(@note).to be_instance_of(Note)
  end

  it "Note is a subclass of Sequel::Model" do
    expect(@note).to be_a(Sequel::Model)
  end


  after{
    @note = nil
  }

end

describe "Checking Note Class functionality" do

  before {
    @test_student = Student.new
    @test_student[:name] = "Test"
    @test_student[:surname] = "Student"
    @test_student.save

    @test_teacher = Teacher.new
    @test_teacher[:name] = "Test"
    @test_teacher[:surname] = "Teacher"
    @test_teacher.save

    @pre_add_len = Note.dataset.count
    @note = Note.new
    @note[:description] = "Description of the note"
    @note[:date] = "01.01.2018"
    @note[:Student_id] = @test_student[:id]
    @note[:Teacher_id] = @test_teacher[:id]
    @note.save

    @post_add_len = Note.dataset.count
  }



  it "Inserting value should increase dataset length" do
    expect(Note.dataset.count).to eq(@pre_add_len+1)
  end

  it "Checking if value is inserted correctly" do
    expect(Note.last).to eq(@note)
  end


  it "Updating value shouldn't increase dataset length" do
    @updated_note = Note.last
    @updated_note[:description] = "Testing if Note is ok"
    @updated_note.save
    expect(Note.dataset.count).to eq(@post_add_len)
  end

  it "Checking if value is updated correctly" do
    @updated_note = Note.last
    @updated_note[:description] = "Testing if Note is ok"
    @updated_note.save
    expect(Note.last).to eq(@updated_note)
  end

  it "Deleting value should decrease dataset length" do
    # skip("no mocks implemented")
    @removed_note = Note.last
    @removed_note.delete
    expect(Note.dataset.count).to eq(@post_add_len-1)
  end

  it "Checking if value is removed correctly" do
    # skip("no mocks implemented")
    @removed_note = Note.last
    @removed_note.delete
    expect(Note.last).not_to eq(@removed_note)
  end


  after {
    @test_teacher = nil
    @test_student = nil
    @note = nil
  }

end

describe "Checking Note Class validation" do

  before {
    @test_student = Student.new
    @test_student[:name] = "Test"
    @test_student[:surname] = "Student"
    @test_student.save

    @test_teacher = Teacher.new
    @test_teacher[:name] = "Test"
    @test_teacher[:surname] = "Teacher"
    @test_teacher.save

    @note = Note.new

  }


  it "Checking error when description is nil" do
    @note[:description] = nil
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when description is too short" do
    @note[:description] = "D"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when description is not string" do
    @note[:description] = 1
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when date is in invalid format" do
    @note[:description] = "Description"
    @note[:date] = "2019.01.01"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when date is nil" do
    @note[:description] = "Description"
    @note[:date] = nil
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when teacher_id is nil" do
    @note[:description] = "Description"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = nil
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when teacher_id is not integer" do
    @note[:description] = "Description"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = "test"
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when teacher_id is negative integer" do
    @note[:description] = "Description"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = -1
    @note[:Student_id] = @test_student[:id]
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when student_id is nil" do
    @note[:description] = "Description"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = nil
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when teacher_id is not integer" do
    @note[:description] = "Description"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = "test"
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  it "Checking error when teacher_id is negative integer" do
    @note[:description] = "Description"
    @note[:date] = "01.01.2019"
    @note[:Teacher_id] = @test_teacher[:id]
    @note[:Student_id] = -1
    expect{@note.save}.to raise_error(Sequel::ValidationFailed)
  end

  after{
    @note = nil
    @test_teacher = nil
    @test_student = nil
  }

end