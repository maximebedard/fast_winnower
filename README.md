# FastWinnower

Native implementation of the [Winnowing](http://igm.univ-mlv.fr/~mac/ENS/DOC/sigmod03-1.pdf) algorithm for local
document fingerprinting. This gem also provides a naive implementation in ruby to compare performances.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'fast_winnower'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fast_winnower

## Usage

This gem can be used to compare similarity between 2 documents. This differ from a simple `diff` by providing
relationships between similar parts between 2 corpuses. Let's take the following 2 sentences:


```rb
# tokens = FastWinnower.tokenize("Hello my name is Maxime", "Hello, my name is henry")
# similarities = FastWinnower.compare(tokens)
```

A classic example would be to remove parts from a set of boilerplate documents. To do so, inhierithing from the base
class `Pair` would do the trick.

```rb
class PairWithoutBoilerplate < Pair
  def initialize(a, b, boilerplate)
    super(a, b)
    @boilerplate = boilerplate
  end

  def intersecting_fingerprints
    super - boilerplate.fingerprints
  end

  def all_fingerprints
    super - boilerplate.fingerprints
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maximebedard/fast_winnower.

## References

- [A New Suffix Tree Similarity Measure for Document Clustering](http://www2007.org/papers/paper091.pdf)
- [Winnowing: Local Algorithms for Document Fingerprinting](http://igm.univ-mlv.fr/~mac/ENS/DOC/sigmod03-1.pdf)
- [Jaccard coefficient](http://matpalm.com/resemblance/jaccard_coeff/)
