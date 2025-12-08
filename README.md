# Antique Analyzer

A rails project - Rails application for antique analysis.

## Requirements

- Ruby 3.4.4
- Rails 8.1.1
- SQLite3

## Installation

1. Install dependencies:
```bash
bundle install
```

2. Create database:
```bash
rails db:create
rails db:migrate
```

3. Load seed data:
```bash
rails db:seed
```

This will create sample data:
- 4 users (admin, 2 experts, 1 regular user)
- 5 categories (including hierarchical structure)
- 5 auctions with different verification statuses
- 4 opinions from experts and users
- Opinion votes
- AI analysis history

## Running the Application

Start the development server:
```bash
rails server
```

The application will be available at: http://localhost:3000

## Tests

Run tests:
```bash
rails test
```
