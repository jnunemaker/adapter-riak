begin
  $test_server = Riak::TestServer.new({
    :bin_dir => File.dirname(`which riak`),
  })
  $test_server.prepare!
  $test_server.start
  at_exit { $test_server.cleanup }
rescue => e
  warn "Can't run Riak::TestServer!"
  warn e.inspect
  exit
end