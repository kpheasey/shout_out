# Shout Out

Shout Out allows for the abstraction of complex ActiveRecord callbacks.

## Installation

Add this line to your application's Gemfile:

gem 'shout_out'
And then execute:

    $ bundle

Or install it yourself as:

    $ gem install shout_out

Then run the install generator

    $ rails g shout_out:install

This will create ApplicationShout in /app/shouts/application_shout.rb

## Usage

To generate a shout class for a model, just use the generator.

    $ rails g shout_out:shout My::Model::Name

This will create the appropriate class in the /app/shouts directory, i.e. ```/app/shouts/my/model/name_shout.rb```.

Now you can define methods for any callback.

```
before_validation
validate
after_validation
before_save
after_save
before_create
after_create
after_commit
```

## Example

The below is an example of using shouts to handle cache invalidation on interdependent models.

```ruby
# /app/shouts/invoice_shout.rb
class InvoiceShout < ApplicationShout

  def after_save
    touch_project
    touch_report_ffa_efficiency
    touch_report_ffa_hour_tracker
  end

  private

  def touch_report_ffa_efficiency
    if record.total_ffa_changed? && calculable? && !record.report_ffa_efficiency.new_record?
      record.report_ffa_efficiency.shout
    end
  end

  def touch_report_ffa_hour_tracker
    changed = record.total_ffa_changed? || work_type_changed?(WorkType.codes[:ffa])

    if changed && calculable? && record.report_ffa_hour_tracker
      record.report_ffa_hour_tracker.shout
    end
  end

  def touch_project
    changed = record.product_comp_changed? || record.product_cost_changed? || record.labor_comp_changed?

    if changed && calculable? && record.project
      record.project.shout
    end
  end

end
```


You can define common methods in ApplicationShout.

```ruby
# /app/shouts/application_shout.rb
class ApplicationShout

  ...

  def calculable?
    record.calculable? || record.calculable_changed?
  end

  def work_type_changed?(codes)
    codes = [codes] unless code.is_a?(Array)
    record.work_type_code_changed? && ([record.work_type_code, record.work_type_code_was] & codes).any?
  end

end

## Contributing

Fork it ( https://github.com/kpheasey/shout_out/fork )
Create your feature branch (git checkout -b my-new-feature)
Commit your changes (git commit -am 'Add some feature')
Push to the branch (git push origin my-new-feature)
Create a new Pull Request