# MixedGauge
An ActiveRecord extension for database sharding.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mixed_gauge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mixed_gauge

## Usage

Add additional database connection config to `database.yml`.

```yaml
# database.yml
production_user_001:
  adapter: mysql2
  username: user_writable
  host: db-user-001
production_user_002:
  adapter: mysql2
  username: user_writable
  host: db-user-002
production_user_003:
  adapter: mysql2
  username: user_writable
  host: db-user-003
production_user_004:
  adapter: mysql2
  username: user_writable
  host: db-user-004
```

Configure slots (virtual node for cluster) then assign slots to real node.

```ruby
MixedGauge.configure do |config|
  config.define_cluster(:user) do |cluster|
    # When slots per node * max nodes per cluster = (2 ** 10) * (2 ** 10)
    cluster.define_slots(1..1048576)
    cluster.register(1..262144, :production_user_001)
    cluster.register(262145..524288, :production_user_002)
    cluster.register(524289..786432, :production_user_003)
    cluster.register(786433..1048576, :production_user_004)
  end
end
```

Include `MixedGauge::Model` to your model class, specify cluster name for the
model, specify distkey which determine nodes to store.

```ruby
class User < ActiveRecord::Base
  include MixedGauge::Model
  use_cluster :user
  def_distkey :email
end
```

Use `.get` to retrive single model class which is connected to proper
database node. Use `.put!` to create new record to proper database node.
`.all_shards` enables you to all model class which is connected to all
database nodes in the cluster.

```ruby
User.put!(email: 'alice@example.com', name: 'alice')

alice = User.get('alice@example.com')
alice.age = 1
alice.save!

User.all_shards.flat_map {|m| m.where(name: 'alice') }.compact
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/mixed_gauge/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
