# Pluckeroid [![Build Status](https://travis-ci.org/dimko/pluckeroid.png?branch=master)](https://travis-ci.org/dimko/pluckeroid)

Pluck for ActiveRecord on steroids

## Installation

Add this line to your application's Gemfile:

    gem 'pluckeroid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install pluckeroid

## Usage

```ruby
Person.pluck(:id)
# => [1, 2]

Person.pluck_attributes(:id)
# => [{ 'id' => 1 }, { 'id' => 2 }]

Person.pluck(:id, :name)
# => [[1, 'Obi-Wan'], [2, 'Luke']]

Person.pluck_attributes(:id, :name)
# => [{ 'id' => 1, 'name' => 'Obi-Wan' }, { 'id' => 2, 'name' => 'Luke' }]
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

Based on native `pluck` method and Ernie Miller's `valium` project.
