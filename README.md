# Rails Polymorphic Select

[![Build Status](https://travis-ci.org/vigetlabs/rails_polymorphic_select.png?branch=master)](https://travis-ci.org/vigetlabs/rails_polymorphic_select) [![Code Climate](https://codeclimate.com/github/vigetlabs/rails_polymorphic_select.png)](https://codeclimate.com/github/vigetlabs/rails_polymorphic_select)

This is a simple Rails extension that allows you to create polymorphic select inputs for relationships that are polymorphic.

## Install

Just add this to your `Gemfile` and then `bundle install`:

```ruby
gem 'rails_polymorphic_select'
```

## Usage

When using any `ActionView::Helpers::FormBuilder` object (either from the `form_for` helper method or a custom `FormBuilder` object) you can now call the method `polymorphic_select` like so:

```
<%= form.polymorphic_select :association_name_global_id, [News, Event, Photo] %>
```

The first argument it accepts is a method name (like all `FormBuilder` input methods), except you'll notice it's a `*_global_id` method. This library will automatically add these methods on all polymorphic relationships you create in your app. So if I have a `Tagging` model and I have a polymorphic relationship named `taggable` like this:

```ruby
class Tagging
  belongs_to :tag
  belongs_to :taggable, :polymorphic => true
end
```

This will create a `taggable_global_id` method and a `taggable_global_id=` method for reading and setting the taggable item by it's Global ID. However, it will not add these methods for non-polymorphic relationships (like `tag` in this case). Rails added [`GlobalID`](https://github.com/rails/globalid) functionality in 4.2, so now all ActiveRecord models have a `to_global_id` method that will return a `GlobalID` object that can be used to find the record.

The second argument `polymorphic_select` takes is an `Array` of `ActiveRecord` model classes that are valid options for this polymorphic relationship.

The third argument is an `options` argument and this gets passed to the [`FormBuilder#select`](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select). Before that however there's one extra option that `polymorphic_select` accepts: `:label_method`. This is used as the method to call on individual records to get the value that users would see on the form select input for each record. By default it tries to find a good method (name, title, to_s, etc). If you prefer you can define a `to_label` or `display_name` method on the model(s), and these will be used.

The fourth argument is a `html_options` argument and this gets passed directly unaltered to [`FormBuilder#select`](http://api.rubyonrails.org/classes/ActionView/Helpers/FormOptionsHelper.html#method-i-select).

Worth noting is this greats a grouped selct input. So the records will be grouped by model class. The `polymorphic_select` method will use `ModelClass.model_name.human` to label the group. You can modify the name it supplies by manually editing the i18n value for the model.


### Advanced usage

Perhaps you have a `Tag` model with `taggings` but you want to access and set the individual `taggables`. In this case you could create your own `*_global_ids` methods and use this on with `polymorphic_select`. Say your `Tag` model looks like this:

```ruby
class Tag
  has_many :taggings

  def taggables
    taggings.map(&:taggable)
  end

  def taggable_global_ids
    taggables.map(&:to_global_id)
  end

  def taggalbe_global_ids=(global_ids)
    # your own code that at some point uses GlobalID::Locator.locate(global_id_value) to set the taggings
  end
end
```

Then in your form you could do:

```
<%= form.polymorphic_select :taggable_global_ids, [News, Event, Photo] %>
```

and it would just work!


## Contributing to RailsPolymorphicSelect

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2015 Brian Landau (Viget Labs). See MIT_LICENSE for further details.
