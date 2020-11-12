# Wip-CLI

A ruby CLI to interact with wip.co from your terminal.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wip-cli'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install wip-cli

## Usage

Define an ENV var named `WIP_API_KEY` with your [api key](https://wip.co/api).

### Adding a todo & completing it

* `wip todo "Grab a cup of ☕️"`
* `wip complete 123`
* `wip complete -u 123` to uncomplete a todo
* `wip delete 123`

And to log a completed todo:
* `wip done "Installed wip-cli gem"`

### Managing todos

You can list your todos (see `wip help todos` for all the options):
`wip todos -u sowenjub -f "#nomeattoday" -l 10`

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sowenjub/wip-cli.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
