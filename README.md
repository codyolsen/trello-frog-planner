
# Trello Frog Planner
This is a script that interfaces with a trello board to create a short and long term task/goal planner. The cards will leap-frog based on their due date and list position. The script can be run each night or manually when ready to advance to the next day.

TODOS:
  - Make this readme
    - Explain system and include diagram
  - Add initialization script for setting up trello from scratch
  - Add nightly task with cron or other scheduler

IDEAS:
  - Reoccuring cards
    - Perhaps an additional board that stores template cards to be added every x days
  - End of period reports, such as nightly, weekly, monthly, etc.
    - Every night I want an email overview report for all my todos for the day that were completed and what needs to be done.    
    - Every morning I want an email overview report for all my todos for the day
    - Every week I want an overview.
    - etc.
    - Perhaps this is just a state report based on the columns.
