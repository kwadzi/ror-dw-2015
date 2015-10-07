Steps to make this
==================

1. Create the app
--------------

`rails new <name_of_your_app>`

Let's see if it works: `rails s`

Visit `http://localhost:3000`

Let's take a look at the file structure...

2. Scaffold: Our first model
------------------

We want to create a Product with a name, description, price per unit and unit, i.e. something like

```json
name: "Flour"
description: "Processed flour from our very best industrial machines of world conquest"
price: 200
unit: "kg"
```

Rails offer a very quick way to start building a web app:

```bash
rails generate scaffold product name description price:integer unit
```

This creates a __model__, a __controller__, a set of __views__ and a __migration__. Let's take a look...

```ruby
class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.integer :price
      t.string :unit

      t.timestamps
    end
  end
end
```

Before starting the server, you need to migrate the DB with the new table. This is called a Rake task.

```bash
rake db:migrate
```

Start the server and take a look around. Everything works like magic. You can CRUD products with 0 lines of code.

```bash
rails s
```

Take a look at:

* Model: `product.rb`
* Controller: `products_controller.rb`
* View: `app/views/products/...`
* `routes.rb` how does it work? Take a look also at `rake routes`


3. Assets: Adding some flavour
----------------

### Introducing Twitter Bootstrap

[http://getbootstrap.com/](http://getbootstrap.com/)

### Add Twitter Bootstrap to the Gemfile

Install Twitter Bootstrap. We use SASS because it's cool, but you can also use LESS or plain CSS. The first thing to do is __ALWAYS__ to look at the gem documentation on Github!! If you follow the steps you should be fine. If you don't, you screw up your application.

We are going to use the `bootstrap-sass` gem from [https://github.com/twbs/bootstrap-sass](https://github.com/twbs/bootstrap-sass)

```ruby
# Gemfile

# Twitter Bootstrap
gem "bootstrap-sass", "~> 3.3.1"
# ~> means anything greater or equal to 3.3.1 but less than 4

# useful for browser compatibility
gem "autoprefixer-rails"
```

In a command line run

```
bundle install
```

__What is the Gemfile?__ It's a file that contains all the gems that our project depends on.

__What is a gem?__ Kind of a small Rails application that we can embed in our project to add functionalities

__What does `bundle install` do?__ It downloads new gems into our project. You must always do it when you change the `Gemfile`.

### Add Twitter Bootstrap to our _assets_

__What are assets?__ In short, everything our app needs: CSS, Javascript, images, etc. Rails manages them through the asset pipeline as long as you put them in the right place! Assets are either written by you or included with gems.

This will compile Twitter Bootstrap into the CSS of our app.

#### `application.css.scss` (you might have to rename)

```sass
// "bootstrap-sprockets" must be imported before "bootstrap" and "bootstrap/variables"
@import "bootstrap-sprockets";
@import "bootstrap";
```

This will include jQuery and Bootrap into our JS.

#### `application.js`

```javascript
//= require jquery //this is probably there already
//= require bootstrap-sprockets
```

Restart the server. Things haven't changed too much... Time to look at layouts in `app/views/layouts/application.html.erb`

4. Focus on the views
------------------

### `application.html.erb`

We copy the basic template from Twitter Bootstrap's website

```rails
<nav class="navbar navbar-default navbar-fixed-top" role="navigation">
  <div class="container">
    <div class="navbar-header">
      <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
        <span class="sr-only">GasApp</span>
      </button>
      <a class="navbar-brand" href="#">GasApp</a>
    </div>
    <div id="navbar" class="collapse navbar-collapse">
      <ul class="nav navbar-nav">
        <li class="active"><a href="#">Home</a></li>
        <li><a href="#about">About</a></li>
        <li><a href="#contact">Contact</a></li>
      </ul>
    </div><!--/.nav-collapse -->
  </div>
</nav>

<div class="container" style="margin-top: 71px">
  <div class="row">
    <div class="col-md-12">
      <%= yield %>
    </div>
  </div>
</div><!-- /.container -->
```

Explain the purpose of layouts and how views work. What does `yield` do?

### `products/show.html.erb`

We look at `app/views/products/show.html.erb` (later we can look at the `.json.jbuilder`) and we change it a bit.

Important things to mention:

* where does `@product` come from? Show in controller the `before_action :set_product`
* what happens if I call `@pippo` in my view? Take a look at the error messages. What happens if I add it to the controller in the `show` method?
* helpers, for example `number_to_currency` (`number_to_currency @product.price, unit: 'R', delimiter: ' '`)
* `link_to` helper. We can add a "Buy" button for later

Moving stuff around we can get something like

```rails
<h1>
  <%= @product.name %>
  <small>
    <%= number_to_currency @product.price, unit: 'R', delimiter: ' ' %> / <%= @product.unit %>
  </small>
</h1>

<p>
  <%= @product.description %>
</p>

<p>
  <%= link_to 'Buy', '#', class: 'btn btn-success' %>
  <%= link_to 'Edit', edit_product_path(@product), class: 'btn btn-primary' %>
  <%= link_to 'Back', products_path, class: 'btn btn-info' %>
</p>
```

__Exercise!__ Try doing something interesting with `index.html.erb`. Notice the use of `@products.each`. A possible solution below (I created my own `price_tag_for` helper).

### `products_helper.rb`

```ruby
def price_tag_for product
  "#{number_to_currency product.price, unit: 'R', delimiter: ' '} / #{product.unit}"
end
```

### `index.html.erb`

```rails
<h1>Products</h1>

<% @products.each do |product| %>
  <div class="row">
    <div class="col-md-6">
      <h2><%= link_to product.name, product %> <small><%= price_tag_for product %></small></h2>
    </div>
    <div class="col-md-6">
      <p style="margin-top: 20px">
        <%= link_to 'Show', product, class: 'btn btn-info' %>
        <%= link_to 'Edit', edit_product_path(product), class: 'btn btn-primary' %>
        <%= link_to 'Destroy', product, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger' %>
      </p>
    </div>
  </div>
<% end %>

<br>

<div class="row">
  <div class="col-md-12">
    <%= link_to 'New Product', new_product_path, class: 'btn btn-lg btn-success' %>
  </div>
</div>
```

5. Relations! Adding Producers
-----------------------

We want our store to be producers-centered and not product-centered.

### Creating the producer model

First of all, we create Producers.

```
rails g scaffold Producer name address email phone
rake db:migrate
rails s
```

We take a look at producers... You can easily see that products and producers are not related... yet. What can we do? We create a migration with the folowing command

```
rails g migration AddRefToProducerToProducts producer:references
```

Notice how we use a (kind of) standard naming convention. This creates a `producer_id` in the products table, generating the following migration.

```ruby
class AddRefToProducerToProducts < ActiveRecord::Migration
  def change
    add_reference :products, :producer, index: true
  end
end
```

### Adding relations to the models

We still need to update our model

```ruby
class Producer < ActiveRecord::Base
  has_many :products
end

class Product < ActiveRecord::Base
  belongs_to :producer
end
```

We run the migration and now...? We can try with the console

```
rails c
```

Try the following (and explain)

```ruby
>> p = Producer.first
>> p.products
=> []
>> prod = Product.last
>> prod.producer
=> nil
>> prod.producer = p
>> prod.save
>> Product.last.producer
```

### Displaying all in our views

We want to display products in our `index` page, grouped by producers. To do this we need to:

* update our routes to nest products into producers (THIS WILL BREAK THINGS!)
* set the root route to `producers#index`
* modify the `producers/index` view to show the products for each producer
* update all the `link_to`s to reflect the new routes

#### `routes.rb`

```ruby
resources :producers do
  resources :products
end

root 'producers#index'
```

Remember to update the navbar!

#### `products/index.html.erb`

```rails
<h1>Producers</h1>

<% @producers.each do |producer| %>
  <div class="row">
    <div class="col-md-9">
      <h2><%= producer.name %></h2>
      <p><%= producer.address %></p>
      <p>Email: <%= mail_to producer.email %> Tel: <%= link_to producer.phone, "tel:#{producer.phone}" %><p>
    </div>
    <div class="col-md-3">
      <%= link_to 'Edit', edit_producer_path(producer), class: 'btn btn-info' %>
      <%= link_to 'Delete', producer, method: :delete, data: { confirm: 'Are you sure?' }, class: 'btn btn-danger' %>
    </div>
    <div class="col-md-10 col-sx-12">
      <% if producer.products.any? %>
        <p>
          <strong>Products:</strong>
        </p>
        <ul>
          <% producer.products.limit(3).each do |product| %>
            <li><%= product.name %> (<%= price_tag_for product %>)</li>
          <% end %>
          <li><%= link_to 'See all', producer_products_path(producer) %></li>
        </ul>
      <% else %>
        <p><strong>No products yet!</strong></p>
      <% end %>
    </div>
  </div>

  <hr>

<% end %>

<br>

<%= link_to 'New Producer', new_producer_path, class: 'btn btn-lg btn-success' %>
```

__Question:__ how can we create products associated to these producers? We add a new button linking to `new_producer_product_path(producer)`. How do we know? Check out `rake routes`.

```ruby
undefined method `products_path' for #<#<Class:0x007fc01a6e7ad0>:0x007fc019b54e70>
```

__WTF!__ When we click the link it doesn't work! That's because our `products_controller` and our views need to be updated with the new paths (i.e. because they expect to be alone and not nested under producers).

#### `controllers/products_controller.rb`

We need to add reference to the producer in the controller.

```ruby
before_action :set_producer

def set_producer
  @producer = Producer.find params[:producer_id]
end
```

And replace `Product.new` with `@producer.products.build`

Try visiting `/producers/1/products`. Wait! We still see all the products. We should not forget to change also the `index` method of the controller.

```ruby
def index
  @products = @producer.products
end
```

#### `products/new.html.erb`

Update the link here and in all the other views! (exercise)

```rails
<%= link_to 'Back', producer_products_path(@producer) %>
```

#### `products/_form.html_erb`

Hey! What's that underscore? That means that `_form` is a partial. More about them later.

Change `form_for @product` to `form_for [@producer, @product]`

When you try it, you will get another error because we haven't changed the path to which we are redirected after a successful action. Let's point all the `redirect_to`s to `root_url` to go back to producers.

6. Cleaning up the mess: introducing Partials
------------------

### `producers/_show.html.erb`

In our `producers/index.html.erb` we can improve the readability of our code by moving the content of the `each` block into a partial so that it becomes:

```rails
<% @producers.each do |producer| %>
  <div class="row">
    <%= render 'show', producer: producer %>
  </div>
  <hr>
<% end %>
```

Notice that we pass `producer` as _local_ object.

This is not particularly useful except for cleaning up our code. What about the buttons next to products in `products/index.html.erb`?

### `products/_commands.html.erb`

The buttons in `show` and in `index` are (more or less) the same as in `products/show.html.erb`. Let's put them in a partial.

#### `_commands.html.erb`

```rails
<%= link_to 'Buy', '#', class: 'btn btn-success' %>
<%= link_to 'Edit', edit_producer_product_path(@producer,product), class: 'btn btn-primary' %>
<%= link_to 'Back', producer_products_path(@producer), class: 'btn btn-info' %>
```

#### `show.html.erb`

```rails
<%= render 'commands', product: @product %>
```
#### `index.html.erb`

```rails
<%= render 'commands', product: product %>
```

### `_form.html.erb`

The place where it is very useful to use partials is in forms that you can use for both editing and creating. Take a look at `new.html.erb` and `edit.html.erb`. They both display the same form but they call different actions.

Notice that `form_for` is a Rails helper. There are more advanced ways to build forms like the `simple_form` gem but we're not going to see that now.

__Exercise:__ how can we add the form directly at the bottom of the products list so that the user does not need to click a button? (hint: use the `_form.html.erb` partial but notice how it is wrapped in the `new.html.erb` view)

7. Creating, Editing and Validating
------------------------

What happens when you create a product? Show how the POST parameters are turned into a new `Product` instance and then saved in the db. Show the `create` and `update` actions in `products_controller`.

__But what happens if you create an empty product?__ Quite unsurprisingly it works.

Luckily, Rails provides an easy way to validate parameters through model validations.

### `product.rb`

If we add

```ruby
validates :name, presence: true
```

and we try creating a product without a name we get an error that is nicely displayed above our form.

An example set of validations could be

```ruby
validates :name, presence: true
validates :description, presence: true, length: { minimum: 5 }
validates :price, presence: true, numericality: { minimum: 0 }
validates :unit, presence: true, inclusion: { in: %w{kg liter}, message: "%{value} is not a valid unit" }
```

Regarding that last one, we can change the form so that the user can't get it wrong.

```ruby
# change
f.input :unit
# with
f.select :unit, %w{kg liter}, {}, class: "form-control"
```

See the documentation to know why.

__Question:__ what happens if we want to add more units? What do you think is a best practice here?

### `producer.rb`

__Exercise:__ introduce some validations for producers

8. Deleting
-----------

What happens if I delete a producer with products? We have to change the `has_many` relationship as follows

```ruby
has_many :products, dependent: :destroy
```

9. Security and Authentication
------------------

You may be familiar with the idea of logging in a user. We are going to see that in a moment. Before that we look at how Rails protects the data on the DB by restricting the parameters that you can pass to `create` and `update`.

Look at the end of the `products_controller` for this method

```ruby
def product_params
  params.require(:product).permit(:name, :description, :price, :unit)
end
```

What happens if I add a new attribute to `product`, for example `quantity`?

### Authentication with `sorcery`

We want only producers to be able to create new products and not to be able to create products for other producers.

`sorcery` is a gem that lets you add a registration/login system to your application with little effort.

```ruby
# Gemfile
gem 'sorcery'
```

Remember to run `bundle install`! Then follow the documentation on Github.

```bash
rails g sorcery:install --model Producer
# and respond No when asked to overwrite
```

This will generate an _initializer_, a migration and will modify the `Producer` model.

```ruby
# producer.rb
class Producer < ActiveRecord::Base
  authenticates_with_sorcery! # added by sorcery
  has_many :products
end

#db/migrations/XXXXXXX_sorcery_core.rb
class SorceryCore < ActiveRecord::Migration
  def change
    create_table :producers do |t|
      t.string :email,            :null => false
      t.string :crypted_password, :null => false
      t.string :salt,             :null => false

      t.timestamps
    end

    add_index :producers, :email, unique: true
  end
end
```

Notice that the migration __creates__ a new table `:producers`. However, we already have it! Let's modify the migration so that it simply adds the attributes/columns we need. Do it __before__ running `rake db:migrate`!! (note how a migration is just another Ruby class)

```ruby
class SorceryCore < ActiveRecord::Migration
  def change
    add_column :producers, :crypted_password, :string
    add_column :producers, :salt, :string

    # this will automatically generate a find_by_email method!
    add_index :producers, :email, unique: true

    # set a default password to all existing producers
    Producer.find_each do |producer|
      producer.change_password!('password')
    end

    # add the NOT NULL constraint to crypted_password and salt (this is because of a SQLite3 quirk)
    change_column :producers, :crypted_password, :string, null: false
    change_column :producers, :salt, :string, null: false
  end
end
```

Now we can take a look at `config/initializers/sorcery.rb`. This is the config file for the gem that we can tweak. We leave it like this for now and we run `rake db:migrate` and restart our server.

#### Signing up a new producer

If we click the "New Producer" button we get a form that looks more or less like a sign up form. But hey! It's missing a password field!

Let's add a password and a password confirmation field.

```rails
<!-- Note that we are assuming that we are using bootstrap here -->
<div class="form-group">
  <%= f.label :password %>
  <%= f.password_field :password, class: 'form-control' %>
</div>
<div class="form-group">
  <%= f.label :password_confirmation %>
  <%= f.password_field :password_confirmation, class: 'form-control' %>
</div>
```

We need to validate that the two passwords match when the user submits the form. We achieve this by adding a new validation to producers.

```ruby
validates_confirmation_of :password, message: "Should match confirmation", if: :password
```

__Don't forget__ to add `:password` and `:password_confirmation` to the permitted parameters in the controller!

#### Are we logged in?

`sorcery` provides some useful methods to check if the user is logged in or not. Let's add to our navbar the name of the user

```rails
<% if logged_in? %>
  Hello, <%= current_user.email %>
<% else %>
  Hello, Guest
<% end %>

<!-- or alternatively -->
<p class="navbar-text navbar-right">Hello, <%= logged_in? ? current_user.name : 'Guest' %></p>
```

It says that we are logged out! This means that we need to introduce sessions!

#### Creating sessions

We generate a new controller for producer sessions

```
rails g controller ProducerSessions
```

We need only three methods:

* `new` to render the login page
* `create` to handle the POST from the login page
* `destroy` to handle the DELETE when the user clicks on the Logout link

```ruby
class ProducerSessionsController < ApplicationController

  def new
  end

  def create
    if login(params[:email],params[:password])
      redirect_to producer_path(current_user), notice: "Logged in successfully"
    else
      flash.now[:error] = "Login failed"
      render action: :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: "Logged out!"
  end

end
```

`new` is empty because Rails knows that it has to render `app/views/producer_sessions/new.html.erb` (convention over configuration). So let's create it.

```rails
<h1>Login</h1>

<%= form_tag producer_sessions_path, method: :post do %>

  <div class="form-group">
    <%= label_tag :email %>
    <%= text_field_tag :email, nil, class: 'form-control' %>
  </div>

  <div class="form-group">
    <%= label_tag :password %>
    <%= password_field_tag :password, nil, class: 'form-control' %>
  </div>

  <div class="actions">
    <%= submit_tag "Login", class: 'btn btn-success' %>
  </div>

<% end %>
```

Finally, we need to create the routes we need

```ruby
# routes.rb
resources :producer_sessions, only: [:new, :create, :destroy]

get 'login' => 'producer_sessions#new'
get 'logout' => 'producer_sessions#destroy'
```

`login` and `logout` are convenient aliases so that we have `login_path`, `login_url`, `logout_path` and `logout_url`. Let's update the navbar accordingly.

```rails
<ul class="nav navbar-nav navbar-right">
  <% if logged_in? %>
    <li><%= link_to "Logout", logout_path %></li>
  <% else %>
    <li><%= link_to "Login", login_path %></li>
  <% end %>
</ul>
```

#### Securing actions

We want certain actions to be available only to logged in users and some actions to be available only to non registered users (e.g. registering).

We can easily hide the registration button, right?

```ruby
link_to('New Producer', new_producer_path, class: 'btn btn-lg btn-success') unless logged_in?
```

But anyone can just go to `producers/new` and create a new producer. So we need to protect the action at controller level with a `before_filter`.

```ruby
before_action :not_logged_in, only: [:new, :create]

def not_logged_in
  if logged_in?
    redirect_to root_path
    return false
  end
end
```

We don't want guest users to be able to edit or destroy producers or create products, so we also add

```ruby
# producers_controller.rb
before_action :require_login, only: [:edit, :update, :destroy]

# products_controller.rb
before_action :require_login, except: [:index, :show]
```

This is provided by `sorcery` and we don't need to do anything else. Of course it's ugly and it doesn't take into account the user (everyone can modify everything when logged in). There are more sophisticated gems for that...

10. A load of gems
-------------------

Switch to the presentation. The important message to pass is that:

* If you want to do something, there is probably a gem for that.
* How do you find gems? Use google
* How to choose among gems that do the same thing? Use Ruby Toolbox

Some gems that we talk about

### Front-end

* **Fontawesome:** a lot of icons and a convenient helper method
* **Gmaps4Rails:** integrate Google Maps into your app (use Leaflet.js if you want something more advanced, but it will require much more javascript)
* **Paperclip:** add attachments to your models (e.g. product images or user avatars)
* **Gettext:** translate your app using `.po` files

### Back-end

* **CanCanCan:** authorization made simple
* **Geocoder:** address -> lat/lon -> address and more
* **Delayed Jobs:** run tasks at set times without interrupting execution
* **Capistrano:** deploy on remote servers (almost) painlessly

### Debug

* **Mailcatcher:** test your emails
* **Better errors:** understand your errors and get a Rails console where you need it