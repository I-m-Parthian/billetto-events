# Billetto Events

A Ruby on Rails application that ingests public events from the
**Billetto API** and allows authenticated users to **upvote or downvote
events** using an **event‑driven architecture powered by Rails Event
Store**.

------------------------------------------------------------------------

## 🚀 Features

### Event Ingestion

-   Fetches public events from the **Billetto API**
-   Stores events locally in the database
-   Prevents duplicate events using `billetto_id`

### Event Listing

Displays upcoming events with:

-   Event title
-   Description
-   Image
-   Start and end dates
-   Upvote and downvote counts

### Voting System

Authenticated users can:

-   👍 Upvote events
-   👎 Downvote events

Voting is implemented using **Rails Event Store**.

Each vote produces an event:

    EventUpvoted
    EventDownvoted

Votes are processed through event handlers and projected into the event
model.

### Authentication

Authentication is handled using **Clerk**.

Features include:

-   Sign up
-   Sign in
-   Logout
-   Protected voting endpoints

Unauthenticated users attempting to vote are redirected to the **sign‑in
page**.

------------------------------------------------------------------------

# 🧱 Architecture

The voting system follows an **event‑driven architecture**.

Flow:

    User clicks Upvote
    ↓
    VotesController
    ↓
    CommandBus
    ↓
    UpvoteEventHandler
    ↓
    EventUpvoted event stored
    ↓
    VoteProjection updates counters
    ↓
    Event model updated

Benefits of this approach:

-   Event audit trail
-   Clear separation of concerns
-   Scalable architecture

------------------------------------------------------------------------

# 🛠 Tech Stack

  Technology          Purpose
  ------------------- ---------------------------
  Ruby on Rails 8     Web framework
  PostgreSQL          Database
  Rails Event Store   Event‑driven architecture
  Clerk               Authentication
  TailwindCSS         UI styling
  RSpec               Testing
  Capybara            Browser tests

------------------------------------------------------------------------

# 📦 Installation

## 1. Clone the repository

``` bash
git clone https://github.com/YOUR_USERNAME/billetto-events.git
cd billetto-events
```

## 2. Install dependencies

``` bash
bundle install
```

## 3. Setup database

``` bash
rails db:create
rails db:migrate
```

## 4. Environment Variables

Create a `.env` file in the root directory:

    BILLETTO_KEYPAIR=your_billetto_keypair
    CLERK_SECRET_KEY=your_clerk_secret_key
    CLERK_SIGN_IN_URL=https://your-clerk-instance.accounts.dev/sign-in

## 5. Start the server

``` bash
rails s
```

Open the app:

    http://localhost:3000

------------------------------------------------------------------------

# 📥 Fetch Events

Events can be ingested in two ways:

### UI

Click the **Fetch Events** button in the navigation bar.

### Rails Runner

``` bash
rails runner "Events::IngestFromBilletto.new.call"
```

------------------------------------------------------------------------

# 🧪 Testing

Run the test suite:

``` bash
bundle exec rspec
```

Test coverage includes:

-   Model tests
-   Service tests
-   Event store tests
-   Authentication tests
-   Request tests
-   Browser tests

------------------------------------------------------------------------

# 🔍 Event Store Browser

In development you can inspect stored events using:

    http://localhost:3000/res

This shows:

-   Event streams
-   Event metadata
-   Event payloads
-   Vote history

------------------------------------------------------------------------

# 📁 Project Structure

    app/
      controllers/
      models/
      services/
      handlers/
      projections/
      commands/
      events/

    spec/
      models/
      services/
      handlers/
      projections/
      requests/
      system/

------------------------------------------------------------------------