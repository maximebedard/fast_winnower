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

### Preprocessing

This gem can be used to compare similarity between 2 documents. This differ from a simple `diff` by providing
relationships between similar parts between 2 corpuses. To analyze both corpuses, the process is divided into 2
distinct operations: preprocessing, comparaison. This can allow the implementer to create an indexing strategy to
compare against multiple document at the same time.

```rb
blob_a = FastWinnower.preprocess("Hello my name is Maxime")
blob_b = FastWinnower.preprocess("Hello my name is Henry!")

result = FastWinnower.compare(blob_a, blob_b)
```

Preprocessing is done via a transformation chain that applies transformation to the data provided. A new transformation
can be added in the chain as such:

```rb
class PrependSomething
  def call(input)
    input[:data] = "something #{input[:data]}"
    yield(input)
  end
end

FastWinnower.transformation_chain do |m|
  m.add_at 0, PrependSomething
end
```

It's also possible to hijack the result of the current transformation to display it to the user. A good example for this
would be to display a text-only version of a PDF file. To do so, the `preprocess` method yields the `input` hash of each
transformations.

```rb
FastWinnower.preprocess("/usr/tmp/1990-12-19.pdf") do |result|
  next unless result[:class] == Transformations::Preprocessor

  puts result[:data]
end
```

Registering a custom preprocessor is also pretty easy.

```rb
class MyPreprocessor
  def call(input)
    input[:data] = "yolo"
    yield(input)
  end
end

FastWinnower::Transformations::Preprocessor.preprocessors << MyPreprocessor
```

Or via DSL? (because why not)

```rb
class MyNewPreprocessorTransformation < FastWinnower::Transformations::Preprocessor
  preprocessors do |list|
    list << Preprocessor1
    list << Preprocessor2
  end

  # other stuff
end

FastWinnower.transformation_chain.swap Transformations::Preprocessor, MyNewPreprocessorTransformation
```
### Comparaison

When comparing 2 documents, it is also a common practice to ignore specific information that can be shared across
many documents. A very common example would be to strip boilterplate information or license from the similarity
analysis. To do so, a custom comparator can be used to define which fingerprints are going to be used during the
comparaison process.

```rb
class BoilerplateComparator
  def initialize(boilerplate_windows)
    @b_indexes, @b_fingerprints = boilerplate_windows.transpose
  end

  def intersect(a, b)
    (a & b) - @b_fingerprints
  end

  def all
    (a | b) - @b_fingerprints
  end
end

blob_boilerplate = FastWinnower.preprocess("Awesome stuff™")
comparator = BoilerplateComparator.new(blob_boilerplate)

result = FastWinnower.compare(a, b, comparator)
```

## Benchmarks

Right now it's not very fast considering it's all written in pure ruby as a proof of concept. Further versions will
include a c implementation in an attempt to provide a faster implementation. Stay tuned.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/maximebedard/fast_winnower.

## References

- [A New Suffix Tree Similarity Measure for Document Clustering](http://www2007.org/papers/paper091.pdf)
- [Winnowing: Local Algorithms for Document Fingerprinting](http://igm.univ-mlv.fr/~mac/ENS/DOC/sigmod03-1.pdf)
- [Jaccard coefficient](http://matpalm.com/resemblance/jaccard_coeff/)
