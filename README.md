# CIF Software Development Kit for Ruby 

The CIF Software Development Kit (SDK) for Ruby contains library code and examples designed to enable developers to build applications using CIF.

# Installation

# Examples
## Client
```ruby
require 'cif-sdk'

config = {
  :token  => '1234',
  :remote => 'https://localhost/api'
}

cli = CIF::SDK::Client(config)
```
## Search
```ruby
r = cli.search(:query => 'example.com')
```

## Ping
```ruby
r = cli.ping()

puts "ping successful"
```
## Submit
```ruby
obs = {
  :observable => 'example.com',
  :tlp        => 'amber',
  :provider   => 'me@me.com',
  :group      => 'everyone',
}
r = cli.submit(obs)
```

# License and Copyright
Copyright (C) 2014 the CSIRT Gadgets Foundation

Free use of this software is granted under the terms of the GNU Lesser General Public License (LGPL v3.0). For details see the file LICENSE included with the distribution.
