# mightyohm_geiger_cosm.rb
# processes serial output from a mightyohm geiger kit and pushes to cosm

require 'bundler'
Bundler.require

DBNAME 				= "geiger.db"
CREATE_QUERY 		= "CREATE TABLE IF NOT EXISTS readings (id INTEGER PRIMARY KEY ASC AUTOINCREMENT NOT NULL, created_at INTEGER, cps INTEGER, cpm INTEGER, dose REAL, mode TEXT)"
CREATE_INDEX_QUERY	= "CREATE INDEX IF NOT EXISTS readings_idx ON readings(created_at)"
INSERT_QUERY 		= "INSERT INTO readings (created_at, cps, cpm, dose, mode) VALUES (?, ?, ?, ?, ?)"

# setup
begin
	@db = SQLite3::Database.new DBNAME
	@db.execute(CREATE_QUERY)
	@db.execute(CREATE_INDEX_QUERY);


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
