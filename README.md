# Experimental Rails Architecture
- [TODO] Finish App

## Major Changes

### No Active Record
  - Active Record removed in favor of a lightway repository pattern (< 500 lines of boilerplate code).
  - Migrations replaced with methods that execute raw SQL.
  - Tests all run against SQLite in-memory db.

### ERB Out and React In
  - No views other than the default application layout.
  - Anything that will be displayed on the page will be rendered via React components.
    - All react components will be rendered server side to avoid some of the pitfalls of full JS apps.
    - No, this doesn't make the app a Single Page App. Page loads still occur.
      - Or as much as they can occur with Turbolinks still installed.

### Logic-less Controllers
  - All controller actions should be two lines or less.
  - Any of the logic that you'd normally find in a controller belongs in an `Interactor` or a `Service` object of some sort.
  
  
## Main Structure / Components
  - `Models` : Domain Logic and Business Rules.
  - `Repositories` : Database layer, used for querying and inserting.
  - `Serializers` : Translation layer between the model objects, the repository, and their JSON representation.
  - `Interactors` : Ruby objects that cover one or more usecases, these rarely corrispond 1-1 with controllers, but they can.
  - `Controller` : Landing point from the Router, points the right data to the correct interactor.
  - `Views` : Soon to be removed vestiage of the rails view later.
  - `Assets/Javascripts/Components` : Individual pages and sections of what is normally referrred to as the view layer of the app.
