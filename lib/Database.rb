require 'sqlite3'

# NOTES
#
# sqlite available types: BLOB, TEXT, INTEGER, REAL, NUMERIC

class Database

    @@db = SQLite3::Database.open "database.db"

    def self.init

        @@db.execute "CREATE TABLE IF NOT EXISTS Student(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            surname TEXT NOT NULL
            )"
        @@db.execute "CREATE TABLE IF NOT EXISTS Teacher(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            surname TEXT NOT NULL
            )"
        @@db.execute "CREATE TABLE IF NOT EXISTS Subject(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            teacher_id INTEGER NOT NULL REFERENCES Teacher(id)
            )"
        @@db.execute "CREATE TABLE IF NOT EXISTS Note(
            id INTEGER PRIMARY KEY,
            description TEXT NOT NULL,
            date DATETIME NOT NULL DEFAULT (datetime('now','localtime')),
            student_id INTEGER NOT NULL REFERENCES Student(id),
            teacher_id INTEGER NOT NULL REFERENCES Teacher(id)
            )"

        @@db.execute "CREATE TABLE IF NOT EXISTS Grade(
            id INTEGER PRIMARY KEY,
            grade INTEGER NOT NULL,
            category TEXT,
            date DATETIME NOT NULL DEFAULT (datetime('now','localtime')),
            subject_id INTEGER NOT NULL REFERENCES Subject(id),
            student_id INTEGER NOT NULL REFERENCES Student(id)
            )"
        @@db.execute "CREATE TABLE IF NOT EXISTS StudentSubject(
            subject_id INTEGER NOT NULL REFERENCES Subject(id),
            student_id INTEGER NOT NULL REFERENCES Student(id),
            PRIMARY KEY(subject_id, student_id)
            )"
        @@db.execute "DELETE FROM StudentSubject"
        @@db.execute "DELETE FROM Grade"
        @@db.execute "DELETE FROM Note"
        @@db.execute "DELETE FROM Subject"
        @@db.execute "DELETE FROM Teacher"
        @@db.execute "DELETE FROM Student"
    end

    def self.db
        @@db
    end

    def self.add obj
        h = obj.gethash
        h.delete(:id)
        @@db.execute "INSERT INTO " + obj.class.to_s + "(" + h.keys.to_s.delete("[:]") + ")
                      VALUES (" + h.values.to_s.delete("[:]") + ")"
    end
    def self.update obj
        h = obj.gethash
        @@db.execute "UPDATE " + obj.class.to_s + " SET (" + h.keys.to_s.delete("[:]") + ")
                      = (" + h.values.to_s.delete("[:]") + ") WHERE id = "+obj.id.to_s
    end

    def self.delete obj
        @@db.execute "DELETE FROM " + obj.class.to_s + " WHERE id = " + obj.id.to_s
    end

    def self.findbyid(cl,id)
        data = @@db.execute "SELECT * FROM " + cl.to_s + " WHERE id = " + id.to_s
        obj = cl.new.sethash(data.next_hash)
        return obj
    end

    #returns array of hashes
    def self.findall(cl)
        res = []
        stmt = @@db.prepare("SELECT * FROM "+ cl.to_s)
        stmt.execute do |result|
            result.each_hash do |item|
                res.push(item)
            end
        end
        return res
    end

end



