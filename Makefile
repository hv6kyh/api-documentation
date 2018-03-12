all:
	bundle install && bundle exec middleman server --bind-address 0.0.0.0 --port 8000
