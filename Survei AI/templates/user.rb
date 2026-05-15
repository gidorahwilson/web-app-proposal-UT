require "mysql2"
$user = Mysql2::Client.new(
         :host=>'localhost',
         :username=>'root',
         :password=>'root',
         :database=>'survei'
)

class User
  def initialize(id='', nama='', password='')
    @kode = id
    @nama = nama
    @password = password
  end

  def id=(id)
    @id = id
  end

  def id()
    return @id
  end

  def nam=(nama)
    @nama = nama
  end

  def nama()
    return @nama
  end

  def password=(password)
    @password = password
  end

  def password()
    return @password
  end

  def login()
    return checkUser() == 1
  end

  private

  def checkUser()
    sql ="SELECT COUNT(*) as cnt FROM admin WHERE admin_id = #{@id} and admin_password = #{@password}"

    result = $user.query(sql)

    result.each() do |row|
      return row['cnt']
    end
  end
end
