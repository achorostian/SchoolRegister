require 'test_helper'

describe "Checking Database class initialization" do
  before{
    @database = Database.new
  }

  it "Returns not nil while created" do
    refute_nil @database
  end

  it "Returns instance of Database while created" do
    assert_instance_of Database, @database
  end

  after{
    @database = nil
  }
end
describe "Checking Database class functionality" do
  let(:tables)do[
      [:Grade,[:id, :grade, :comment, :date, :StudentSubject_id],[[:id, {:allow_null=>false, :default=>nil, :db_type=>"integer", :primary_key=>true, :auto_increment=>true, :type=>:integer, :ruby_default=>nil}], [:grade, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}], [:comment, {:allow_null=>false, :default=>nil, :db_type=>"varchar(500)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>500}], [:date, {:allow_null=>false, :default=>nil, :db_type=>"varchar(30)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>30}], [:StudentSubject_id, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}]]],
      [:Note,[:id, :description, :date, :Student_id, :Teacher_id],[[:id, {:allow_null=>false, :default=>nil, :db_type=>"integer", :primary_key=>true, :auto_increment=>true, :type=>:integer, :ruby_default=>nil}], [:description, {:allow_null=>false, :default=>nil, :db_type=>"varchar(500)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>500}], [:date, {:allow_null=>false, :default=>nil, :db_type=>"varchar(30)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>30}], [:Student_id, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}], [:Teacher_id, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}]]],
      [:Student, [:id, :name, :surname],[[:id, {:allow_null=>false, :default=>nil, :db_type=>"integer", :primary_key=>true, :auto_increment=>true, :type=>:integer, :ruby_default=>nil}], [:name, {:allow_null=>false, :default=>nil, :db_type=>"varchar(50)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>50}], [:surname, {:allow_null=>false, :default=>nil, :db_type=>"varchar(50)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>50}]]],
      [:StudentSubject, [:id, :Student_id, :Subject_id],[[:id, {:allow_null=>false, :default=>nil, :db_type=>"integer", :primary_key=>true, :auto_increment=>true, :type=>:integer, :ruby_default=>nil}], [:Student_id, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}], [:Subject_id, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}]]],
      [:Subject, [:id, :name, :Teacher_id],[[:id, {:allow_null=>false, :default=>nil, :db_type=>"integer", :primary_key=>true, :auto_increment=>true, :type=>:integer, :ruby_default=>nil}], [:name, {:allow_null=>false, :default=>nil, :db_type=>"varchar(50)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>50}], [:Teacher_id, {:allow_null=>true, :default=>nil, :db_type=>"integer", :primary_key=>false, :type=>:integer, :ruby_default=>nil}]]],
      [:Teacher, [:id, :name, :surname],[[:id, {:allow_null=>false, :default=>nil, :db_type=>"integer", :primary_key=>true, :auto_increment=>true, :type=>:integer, :ruby_default=>nil}], [:name, {:allow_null=>false, :default=>nil, :db_type=>"varchar(50)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>50}], [:surname, {:allow_null=>false, :default=>nil, :db_type=>"varchar(50)", :primary_key=>false, :type=>:string, :ruby_default=>nil, :max_length=>50}]]],
  ]
  end
  before do
    Database.init
  end

  it "Checking if tables were created correctly" do
    tables.each do |table|
      assert Database.db.table_exists?(table[0])
    end
  end

  it "Checking if tables contains columns" do
    tables.each do |table|
      column_names = []
      Database.db.schema(table[0]).each do |column|
        column.each do |value|
          if value.is_a? Symbol
            column_names << value
          end
        end
      end
      assert_equal(column_names,table[1])
    end
  end

  it "Checking if columns contains exact properties" do
    tables.each do |table|
      assert_equal(table[2],Database.db.schema(table[0]))
    end
  end

  after do
  end

end