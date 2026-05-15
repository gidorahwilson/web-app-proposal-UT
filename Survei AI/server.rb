
#!/usr/bin/ruby

###########################
# Nama file: hello/server.rb
###########################

require "sinatra"
require "mysql2"
#require_relative "templates/login"
set :views, "templates"
$user = Mysql2::Client.new(
        :host=>'',
        :username=>'',
        :password=>'',
        :database=>''
)

configure do
  enable :session
end

get '/' do
 erb :index
end

get '/survei' do
  erb :survei
end

post '/submit' do
 nama = params['nama']
 program_studi = params['program_studi']
 penggunaan_ai = params['penggunaan_ai']
 platform_ai = params['platform_ai']
 tujuan_penggunaan = params['tujuan_penggunaan']

 sql = "INSERT INTO hasil (nama, program_studi, penggunaan_ai, platform_ai, tujuan_penggunaan) VALUES('#{nama}', '#{program_studi}', '#{penggunaan_ai}', '#{platform_ai}', '#{tujuan_penggunaan}')"
 @ok = $user.query(sql)

 erb :survei
end

get '/data' do
  results = $user.query("SELECT * FROM hasil")

  @data = results.to_a
  @jumlah_responden = @data.size
  @jumlah_ai = @data.count { |r| r["penggunaan_ai"].downcase == "ya" }
  @jumlah_non_ai = @data.count { |r| r["penggunaan_ai"].downcase == "tidak" }

  # Analisis sederhana: platform AI yang paling sering disebut
  semua_platform = @data.map { |r| r["platform_ai"].downcase.split(/[ ,]+/) }.flatten
  platform_freq = semua_platform.tally
  @platform_populer = platform_freq.max_by { |_, v| v }&.first || "Belum ada data"

  erb :output
end

get '/admin' do
  erb :admin
end

post '/admin' do
  username = params['user_name']
  password = params['user_password']

  validasi = $user.query("SELECT * FROM admin WHERE user_name = '#{username}'")

 if validasi.count == 0
   @error = "username belum ada silahkan registrasi"
   return erb :registrasi
 else
   @succes = "berhasil login"
   return erb :admin
 end
end

get '/registrasi' do
 erb :registrasi
end

post '/admin/register' do
 username = params['user_name']
 password = params['user_password']
 nama     = params['nama']
 email    = params['email']

 data = "INSERT INTO admin (admin_id, user_name, user_password, nama, email ) VALUES ('', '#{username}', '#{password}', '#{nama}', '#{email}')"
 @ok  = $user.query(data)
 erb :registrasi
end

get '/dashboard' do
  erb :dashboard
end
