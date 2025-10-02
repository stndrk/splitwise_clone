# Rails Assignment - Splitwise

## Setup
- Clone the repository in your local machine.
- Run `rails db:setup`, this will also seed data in the `User` model
- Run `rails s` to start the server and `rails c` for rails console

## Requirements

- Ruby - 3.0.0
- Rails - 6.1.4
- Git (configured with your Github account)
- Node - 12.13.1


## Things available in the repo
- Webpacker configured and following packages are added and working.
  - Jquery
  - Bootstrap
  - Jgrowl
- Devise installed and `User` model is added. Sign in and Sign up pages have been setup.
- Routes and layouts for following page have been added.
  - Dashboard - This will be the root page.
  - Friend page - `/people/:id`


## Submission
- Make the improvements as specified in your technical assignment task.
- Commit all changes to the single PR.
- Deploy your app to Heroku or any other platform.
- Send us the link of the dpeloyed application and your PR.


## Contact us
If you need any help regarding this assignment or want to join [Commutatus](https://www.commutatus.com/), drop us an email at work@commutatus.com


## ====================================================================
## ⚙️ Complete Setup Guide

Follow these commands **in order**, all in one flow:

```bash
# 1. Install Ruby 3.0.0 using rbenv
rbenv install 3.0.0
rbenv global 3.0.0

# 2. Install Bundler and project dependencies
gem install bundler -v 2.2.33
bundle install

# 3. Install Node.js via nvm
nvm install 12.13.1
nvm use 12.13.1

# 4. Install Yarn dependencies and compile Webpacker
yarn install
rails webpacker:compile

# 5. Install Bootstrap & Popper.js
yarn add bootstrap @popperjs/core

# 6. Setup PostgreSQL
sudo apt install postgresql
sudo -u postgres psql

# 7. Databse Setup
CREATE DATABASE ai_splitwise_clone;
CREATE USER ai_splitwise_clone WITH PASSWORD 'your_password';
GRANT ALL PRIVILEGES ON SCHEMA public TO ai_splitwise_clone;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON TABLES TO ai_splitwise_clone;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT ALL PRIVILEGES ON SEQUENCES TO ai_splitwise_clone;
\q

# 8. Run database migrations
rails db:migrate

# 9. Start Rails server
bin/rails s

# Open your browser at:
👉 http://localhost:3000


## =======================================================================
## 📝 Project Overview

**AI Splitwise Clone** is a web application for managing personal and group expenses. Key features include:

- **User Authentication**: Users can sign up and log in securely.  
- **Expense Management**: Users can add expenses for a single friend, multiple friends, or within a group. Each expense can include description, amount, tax, tip, and custom splits.  
- **Groups**: Users can create groups, add members, and share expenses within the group.  
- **Dashboard**: Provides an overview of total balance, total you owe, total owed to you, friends list with their respective amounts, and recent friends’ expenses.  
- **Profile Section**: View expenses with friends wise, settle outstanding amounts, and manage groups.  

This app makes it easy to track and manage shared expenses efficiently, keeping balances and settlements transparent for all users.


### Login Page
![Login Page](https://raw.githubusercontent.com/stndrk/splitwise_clone/main/public/login_page.png)

### Signup Page
![Signup Page](https://raw.githubusercontent.com/stndrk/splitwise_clone/main/public/signup_page.png)

### Dashboard
![Dashboard](https://raw.githubusercontent.com/stndrk/splitwise_clone/main/public/dasdboard_page.png)

### Dashboard with Expense
![Dashboard with Expense](https://raw.githubusercontent.com/stndrk/splitwise_clone/main/public/dashboard_page_with_expense.png)

### Profile with Expense
![Profile Page](https://raw.githubusercontent.com/stndrk/splitwise_clone/main/public/profile_page_with_expense.png)
