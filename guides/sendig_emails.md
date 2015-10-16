## Sending emails

Rails' Action Mailer allows you to send emails from your application using mailer classes and views. Mailers work very similarly to controllers. They inherit from `ActionMailer::Base` and live in `app/mailers`, and they have associated views that appear in `app/views`.

We will do mainly two things:

1. Create the email message
2. Send the email in a specific moment (when the incident is created)

### IncidentMailer

Let's create the IncidentMailer that will be responsible of sending emails related to Incidents.

~~~bash
rails g mailer IncidentMailer
  create  app/mailers/incident_mailer.rb
  create  app/mailers/application_mailer.rb
  invoke  erb
  create    app/views/incident_mailer
  create    app/views/layouts/mailer.text.erb
  create    app/views/layouts/mailer.html.erb
  invoke  test_unit
  create    test/mailers/incident_mailer_test.rb
  create    test/mailers/previews/incident_mailer_preview.rb
~~~

Look at the most important files, `application_mailer.rb`, `mailer.html.erb`, and `incident_mailer.rb`. Notice that they are very similar to controllers!

~~~ruby
# app/mailers/incident_mailer.rb

default from: 'incident_reporter@example.com'

def new_incident(incident)
  @incident = incident
  mail(to: "police@example.com", subject: 'A new Incident just reported')
end
~~~

`mail` - The actual email message, we are passing the `:to` and `:subject` headers in.

Just like controllers, any instance variables we define in the method become available for use in the views.

#### Create the template view

Create the file `app/views/incident_mailer/new_incident.html.erb`. This will be the template used for the email, formatted in HTML:

~~~ruby
<h1>Hello Policeman!</h1>

<p>
  There is a new <%= @incident.category.name %>, please check it out <%= link_to "at this link", incident_url(@incident) %>.
</p>
<p>
	Bye!
</p>

<p>
	------
	<br>
	The Incident Reporter Rails App
</p>
~~~

To use the helper `incident_url` we must tell the mailer the host to which we make the request. Unlike controllers, mailers know nothing about the incoming requests.

Add this line to the `development.rb` initializer.

~~~ruby
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
~~~

### Create the Observer

What is an **Observer**? Observer classes respond to life cycle callbacks to implement trigger-like behavior outside the original class. This is a great way to reduce the clutter that normally comes when the model class is burdened with functionality that doesn’t pertain to the core responsibility of the class.

Add this line to the `Gemfile`

~~~ruby
gem 'rails-observers'
~~~

and `bundle install`.

Create the file `app/observers/incident_observer.rb` and write this code:

~~~ruby
class IncidentObserver < ActiveRecord::Observer

end
~~~

Tell your app that the observer exists: add this line to `application.rb`

~~~ruby
config.active_record.observers = :incident_observer
~~~

and restart the server.

#### Send the email

Add this method to the `IncidentObserver`:

~~~ruby
def after_create incident
	# Send the email to police@example.com
	IncidentMailer.new_incident(incident).deliver_later
end
~~~

### How do we test/preview the email?

Go on `localhost:3000/rails/mailers`. This is very useful to preview the email body.

Edit the file `test/mailers/previews/incident_mailer_preview.rb`

~~~ruby
def new_incident
	IncidentMailer.new_incident(Incident.first)
end
~~~

For testing the delivery of the message you could use a real email address for the recipient (but it will soon cause problems...) or you can *catch* the message before it is actually sent.

#### Mailcatcher

Install `gem install mailcatcher`, configure the app for using it and go to `localhost:1080` to see the emails.

Add this to the `development.rb`

~~~ruby
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { address: "localhost", port: 1025 }
~~~
