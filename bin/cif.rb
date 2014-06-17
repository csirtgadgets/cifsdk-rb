#!ruby

# https://github.com/splunk/splunk-sdk-ruby/blob/master/examples/run_examples.rb

require 'optparse'
require 'cif-sdk'
require 'pp'
require 'logger'
require 'logger/colors'
require 'yaml'
require 'terminal-table'

REMOTE_DEFAULT = 'https://localhost/api'
COMMAND_DEFAULT = 'ping'
CONFIG_PATH_DEFAULT = ENV['HOME'] + '/.cif.yaml'

COLS_DEFAULT = ['id','provider','tlp','group','observable','confidence',
  'firsttime','lasttime','reporttime','altid','altid_tlp','tags']

def make_table(cols=COLS_DEFAULT,rows=[])
  table = Terminal::Table.new :headings => cols

  if rows.is_a?(Hash) # only got one
    rows = [rows]
  end

  for obs in rows.sort_by { |hsh| hsh['reporttime'] }
    rr = []
    for col in cols
      y = obs[col]
      if y.is_a?(Array)
        y = y.join(',')
      end
      rr << y
    end
    table << rr
  end
  return table
end

def main(argv)
  command = COMMAND_DEFAULT

  logger = Logger.new(STDERR)
  logger.level = Logger::FATAL

  conf = {}
  conf['remote']        = REMOTE_DEFAULT
  conf['logger']        = logger
  conf['columns']       = COLS_DEFAULT
  conf['config_path']   = CONFIG_PATH_DEFAULT

  parser = OptionParser.new do |op|
    op.on('-R', "--remote REMOTE", String, "Set host (default: https://localhost/api)") do |s|
      conf['remote'] = s
    end

    op.on('-T','--token TOKEN', String, "Set token for authentication (default: 1234)") do |s|
      conf['token'] = s
    end

    op.on('--[no-]verify-ssl','do not verify SSL') do |s|
      conf['verify_ssl'] = s
    end

    op.on('-p', '--ping', 'ping the remote') do |s|
      command = 'ping'
    end

    op.on('-q', '--query QUERY', String, 'search for something') do |s|
      command = 'query'
      conf['query'] = s
    end

    op.on('-n', '--[no-]log', 'do not log the search') do |s|
      conf['log'] = false
    end

    op.on('--submit JSON', String, 'submit a json encoded string') do |s|
      command = 'submit'
      conf['submission'] = s
    end

    op.on('-v','--verbose', 'turn up logging') do |s|
      logger.level = Logger::INFO
    end

    op.on('-d','--debug', 'set logging to debug') do |s|
      logger.level = Logger::DEBUG
    end

    op.on('-C','--conf CONFIG_PATH', String, "set config path, default #{CONFIG_PATH_DEFAULT}") do |s|
      conf['config_path'] = s
    end

    op.on('--cols COLUMNS', String, "Columns to output...") do |s|
      conf['columns'] = s
    end
  end

  parser.parse!(argv)
  if(File.exists?(conf['config_path']))
    localconf = YAML.load_file(conf['config_path'].to_s)
    conf.merge!(localconf['client']) if localconf['client']
    ## TODO - format
  end

  cli = CIF::SDK::Client.new(conf)
  case command
  when 'ping'
    for i in 0 ... 3
      ret = cli.ping()
      if(ret)
        logger.info("roundtrip: #{ret}ms...")
        select(nil,nil,nil,1)
      else
        break
      end
    end
  when 'query'
    r = cli.search(conf)
    table = make_table(cols=conf['columns'],rows=r)
    puts table
  when 'submit'
    r = cli.submit(data=conf['submission'])
    table = make_table(cols=conf['columns'],rows=r)
    puts table
  end
end

if __FILE__ == $0
  main(ARGV)
end