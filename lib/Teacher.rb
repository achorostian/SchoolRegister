class Teacher < Sequel::Model(Database.db[:Teacher])

    plugin :validation_helpers
    one_to_many :Subject
    one_to_many :Note

    def validate
        super
        validates_presence [:name,:surname], message: 'Nie podano wszystkich niezbędnych danych.'
        validates_type String, :name, message: 'Nieprawidłowy typ danych dla imienia.'
        validates_type String, :surname, message: 'Nieprawidłowy typ danych dla nazwiska.'
        validates_length_range 3..50, :name, message: lambda{|s| "Imie powinno mieć więcej niż #{s} znaków"}
        validates_length_range 3..50, :surname, message: lambda{|s| "Nazwisko powinno mieć więcej niż #{s} znaków"}
        validates_format /^[A-ZĄĆĘŁŃÓŚŹŻ][a-ząćęłńóśźż]+(([-][A-ZĄĆĘŁŃÓŚŹŻ])[a-ząćęłńóśźż]+)?$/, :name, message: "Zły format imienia!"
        validates_format /^[A-ZĄĆĘŁŃÓŚŹŻ][a-ząćęłńóśźż]+(([-][A-ZĄĆĘŁŃÓŚŹŻ])[a-ząćęłńóśźż]+)?$/, :surname, message: "Zły format nazwiska!"
    end


    def self.printlabels
        puts " Nr |        Imię |     Nazwisko "
        puts "----+-------------+--------------"
    end

    def printline(nr)
        printf("%3d |%12s |%13s\n" , nr+1 , name , surname )
    end

    def count_subjects
        self.Subject.count
    end

    def count_grades
        if !self.Subject.empty?
            self.Subject.sum(&:count_grades)
        else
            return 0
        end
    end

    def count_notes
        self.Note.count
    end

    def average_average_subjects
        if self.Subject.count.to_f == 0
            return 0
        end
        self.Subject.sum(&:average_grades).to_f / self.Subject.count.to_f
    end

    def average_grades
        if self.Subject.empty?
            return 0
        end
        self.Subject.sum(&:sum_grades).to_f / self.Subject.sum(&:count_grades).to_f
    end
    def get_all_data
        result = Array.new
        result << self.count_subjects << self.count_grades << self.count_notes << self.average_average_subjects << self.average_grades
    end
end