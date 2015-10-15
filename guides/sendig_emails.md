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

#### Create the template view


### Create the Observer

What is an Observer?

Create the file `app/observers/incident_observer.rb` and write this code:

~~~ruby
class IncidentObserver < ActiveRecord::Observer

	def after_create incident
		# Send the email to police@example.com
    
	end

end
~~~

Tell your app that the observer exists: add this line to `application.rb`

~~~ruby
config.active_record.observers = :user_observer
~~~

and restart the server.

#### Send the email



### How do we test/preview the email?

Go on `localhost:3000/rails/mailers`. This is very useful to preview the email body.

For testing the delivery of the message you could use a real email address for the recipient (but it will soon cause problems...) or you can *catch* the message before it is actually sent.

#### Mailcatcher

Install `gem install mailcatcher`, configure the app for using it and go to `localhost:1080` to see the emails.
