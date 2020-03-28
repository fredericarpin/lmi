#!/usr/bin/env ruby

$: << 'lib'

require 'tcptimeclient'
require 'udptimeclient'
require 'timeserver'
require 'timers'

Thread.abort_on_exception = true
Thread.report_on_exception = false

def must_match(value, regexp)
  value.match?(regexp) || fail("'#{value.chomp}' does not match '#{regexp}'")
  return "OK"
end

def must_end_with(value, pattern)
  value.end_with?(pattern) || fail("'#{value.chomp}' does not end with '#{pattern}'")
  return "OK"
end

def must_timeout(timer, max_age_in_seconds)

  fail("Not implemented")
end

def fail(message)
  raise Exception.new(message)
end

ts = TimeServer.new('127.0.0.1', 1234)
Thread.start { ts.run }
sleep 1

ttc = TCPTimeClient.new('127.0.0.1', 1234)

puts "Testing TCP Server date command"
response = ttc.send_request("date\n")
puts "- date must be properly formatted: " + must_match(response, Regexp.new('^\d{4}-\d{2}-\d{2}'))
puts "- date must end with newline: " + must_end_with(response, "\n")
puts

puts "Testing TCP Server time command"
response = ttc.send_request("time\n")
puts "- time must be properly formatted: " + must_match(response, Regexp.new('^\d{2}:\d{2}:\d{2}[-+]\d{2}:\d{2}'))
puts "- time must end with newline: " + must_end_with(response, "\n")
puts

puts "Testing TCP Server datetime command"
response = ttc.send_request("datetime\n")
puts "- datetime must be properly formatted: " + must_match(response, Regexp.new('^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[-+]\d{2}:\d{2}'))
puts "- datetime must end with newline: " + must_end_with(response, "\n")
puts

puts "Testing TCP Server timeout"
timers = Timers::Group.new
timers.after(6) { fail("Did not timeout after 5 seconds") }
Thread.start do
  ttc.send_request("da")
  timers.cancel
end
timers.wait
puts "- connection must timeout after 5 seconds of inactivity: OK"
puts

utc = UDPTimeClient.new('127.0.0.1', 1234)

puts "Testing UDP Server date command"
response = utc.send_request("date\n")
puts "- date must be properly formatted: " + must_match(response, Regexp.new('^\d{4}-\d{2}-\d{2}'))
puts "- date must end with newline: " + must_end_with(response, "\n")
puts

puts "Testing UDP Server time command"
response = utc.send_request("time\n")
puts "- time must be properly formatted: " + must_match(response, Regexp.new('^\d{2}:\d{2}:\d{2}[-+]\d{2}:\d{2}'))
puts "- time must end with newline: " + must_end_with(response, "\n")
puts

puts "Testing UDP Server datetime command"
response = utc.send_request("datetime\n")
puts "- datetime must be properly formatted: " + must_match(response, Regexp.new('^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}[-+]\d{2}:\d{2}'))
puts "- datetime must end with newline: " + must_end_with(response, "\n")
puts
