#!/usr/env/ruby

# https://github.com/splunk/splunk-sdk-ruby/blob/master/examples/run_examples.rb

require 'optparse'
require 'cif-sdk'

def main(argv)
  conf = {
    :remote => 'https://localhost/api',
    :token  => '1234',
  }
  
  parser = OptionParser.new do |op|
    op.on("--remote REMOTE", String, "Set host (default: localhost)") do |s|
      conf[:remote] = s
    end

    op.on("--token TOKEN", String, "Set token for authentication (default: 1234)") do |s|
      conf[:token] = s
    end
  end

  parser.parse!(argv)

end

if __FILE__ == $0
  main(ARGV)
end