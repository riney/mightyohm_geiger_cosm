# mightyohm_geiger_cosm.rb
# processes serial output from a mightyohm geiger kit and pushes to cosm

require 'bundler'
Bundler.require
Dir.glob('./models/*').each { |r| require r }

DBNAME 				= "geiger.db"
INSERT_QUERY 		= "INSERT INTO readings (created_at, cps, cpm, dose, mode) VALUES (?, ?, ?, ?, ?)"

# setup
begin
	@db = SQLite3::Database.new DBNAME

	# launch endpoint thread

	# now start processing

	while stdin.gets
		@data = $_.split(", ")
		@cps, @cpm, @dose, @mode = @data[1], @data[3], @data[5], @data[6]

		@db.execute(INSERT_QUERY, [Time.now, @cps, @cpm, @dose, @mode])
	end
rescue Exception
	puts "exception caught: #{$!}"
ensure
	# shutdown
	@db.close
end
