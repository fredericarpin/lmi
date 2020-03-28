#!/usr/bin/env ruby

$: << 'lib'

require 'timeserver'
require 'optimist'

options = Optimist::options do
  opt :port_number, "Port Number", :required => true, :type => :integer
end

ts = TimeServer.new('127.0.0.1', options[:port_number])
ts.run
