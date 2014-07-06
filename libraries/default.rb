
def create_observium_db

  begin
    con = Mysql.new 'localhost', 'root', 'root'

    rs = con.query 'CREATE DATABASE observium;'
    rs = con.query "GRANT ALL PRIVILEGES ON observium.* TO 'observium'@'localhost' IDENTIFIED BY 'observium';"

  rescue Mysql::Error => e
    puts "Unable to create database"
    puts e.errno
    puts e.error

  ensure
    con.close if con
  end
end