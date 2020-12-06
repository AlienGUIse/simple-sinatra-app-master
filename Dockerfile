FROM ruby:2.7
RUN apt-get update && apt-get install -y build-essential
RUN mkdir -p /var/www/simple-sinatra-app
WORKDIR /var/www/simple-sinatra-app
ADD Gemfile* /var/www/simple-sinatra-app
RUN bundle install
ADD . /var/www/simple-sinatra-app

EXPOSE 80
CMD ["bundle", "exec", "rackup","config.ru", "-p", "80", "-o", "0.0.0.0"]