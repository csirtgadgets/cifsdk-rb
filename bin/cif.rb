#!/usr/env/ruby

# https://github.com/splunk/splunk-sdk-ruby/blob/master/examples/run_examples.rb

require 'optparse'
require 'cif-sdk'
require 'pp'

def main(argv)
  conf = {
    :remote     => 'https://localhost:8443/api',
    :token      => '1234',
    :verify_ssl => true,
    :log        => true,
  }
  command = 'ping'

  parser = OptionParser.new do |op|
    op.on("--remote REMOTE", String, "Set host (default: https://localhost/api)") do |s|
      conf[:remote] = s
    end

    op.on('-T','--token TOKEN', String, "Set token for authentication (default: 1234)") do |s|
      conf[:token] = s
    end
    
    op.on('--[no-]verify-ssl','do not verify SSL') do |s|
      conf[:verify_ssl] = s
    end
    
    op.on('-p', '--ping', 'ping the remote') do |s|
      command = 'ping'
    end
    
    op.on('-q', '--query QUERY', String, 'search for something') do |s|
      command = 'query'
      conf[:query] = s
    end
    
    op.on('-n', '--[no-]log', 'do not log the search') do |s|
      conf[:log] = false
    end
    
    op.on('--submit JSON', String, 'submit a json encoded string') do |s|
      command = 'submit'
      conf[:submission] = s
    end
  end

  parser.parse!(argv)

  cli = CIF::SDK::Client.new(conf)
  case command
  when 'ping'
    cli.ping()
  when 'query'
    cli.search(conf)
  when 'submit'
    cli.submit(conf)
  end
end

if __FILE__ == $0
  main(ARGV)
end