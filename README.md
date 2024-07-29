# **DATA WOW Take Home Assignment**

This is a Ruby on Rails application designed as part of the Datawow take-home exercise. It allows users to create, read, update, and delete (CRUD) posts. The application includes secure user authentication to manage user access.

## **Prerequisites**

Before you begin, ensure you have the following installed on your system:
- RVM (Ruby Version Manager): [How to install RVM](https://rvm.io/rvm/install)
- Ruby (version 3.1.2)
  
  ```
  $ rvm install 3.1.2
  
  $ rvm use 3.1.2
  ```
- Rails (version 7.1.3):
  
  ```
  $ gem install rails
  ```
- Bundler
  
  ```
  $ gem install bundler
  ``` 
- PostgreSQL (version 14): [Install postgreSQL for macOS](https://www.postgresql.org/download/macosx/) or [Windows](https://www.postgresql.org/download/windows/)
- Git: [Getting start with Git](https://docs.github.com/en/get-started/getting-started-with-git)

## **Setup Instructions**

To set up and run the application locally, follow these steps:
1. **Clone the repository**

  ```
    $ git clone https://github.com/sshutter/datawow-assignment.git

    $ cd datawow-assignment
  ```
2. **Install dependencies**
  
  ```
    $ bundle install
  ```
3. **Set Up the Database**
  
  ```
    $ rails db:create

    $ rails db:migrate
  ```
  Tips: I added seed data to initialize the database. Run: `rails db:seed`

4. **To start the Rails server on port 5001** 🚀
  
  ```
    $ rails s -p 5001
  ```

## **Running Tests**

To run the test suite, ensure you have [RSpec](https://github.com/rspec/rspec-rails) installed. Then execute:

  ```
    $ bundle exec rspec
  ```

## **How to interact with it**

You have two options to interact with the Ruby on Rails application:

1. **Using the Frontend**: Access the application through the frontend interface.
   - [Frontend Repository](https://github.com/sshutter/datawow-assignment-frontend)

2. **Using Postman**:
   - Install Postman: [Download Postman](https://www.postman.com/downloads/)
   - Refer to the API documentation in the Rails controllers to understand the available endpoints and their usage.

