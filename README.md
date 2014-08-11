Sampl.rb
=========

Report tracking events from a Ruby on Rails server.

Sampl.rb is a thin wrapper around HTTParty that implements PSIORI's REST API. It tries to adapt and rely on the same concepts and principles that HTTParty uses, so users already familiar with HTTParty will have an easy start with Sampl.rb.


Usage
-----

Sampl's usage is very similar to that of HTTParty, you might already be familiar with. There are two options:

A) calling the static methods of the Sampl module:

```
Sampl.track('rb_test_event', 'test', { app_token: 'your-unique-app-token', debug: true })
```

B) inheriting the module (recommended) in a custom class and implementing instance methods

