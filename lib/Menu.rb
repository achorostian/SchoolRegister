require_relative 'Add'
require_relative 'Edit'
require_relative 'Single'
require_relative 'List'
require_relative 'Stats'


class Menu

  def self.main
      top
      puts "1. Lista Uczniów"
      puts "2. Lista Przedmiotów"
      puts "3. Lista Nauczycieli"
      puts ""
      puts "4. Dodaj Ucznia"
      puts "5. Dodaj Przedmiot"
      puts "6. Dodaj Nauczyciela"
      puts ""
      puts "7. Eksportuj do CSV"
      puts "8. Importuj nową bazę z CSV"
      puts "0. Wyjscie"
      puts ""
      print "podaj nr: "

      case gets.to_i
          when 1 then List.Student
          when 2 then List.Subject
          when 3 then List.Teacher
          when 4 then Add.Student
          when 5 then Add.Subject
          when 6 then Add.Teacher
          when 7
              Register.export
          when 8
              Database.drops
              Database.init
              Register.init
          else exit
      end
  end

  def self.top
    system 'clear'
    puts "==================== DZIENNIK ===================="
  end

end
