# shellclass

Collection of example shell scripts and small Vagrant demos used for teaching shell basics and simple multi-host tasks.

## Repository layout

- `local-users/`: scripts to create and manage local user accounts (Linux-focused).
- `multi-net/`: multi-host helpers and demos (SSH helpers, watchdogs, Apache install scripts).
- `multitest/`: Vagrant/test harnesses.
- `testbox01/`: single test machine Vagrant config.

## Usage examples

- Create a user (Linux guest):

  sudo ./local-users/add-local-user.sh

- Run a command on every host listed in `/vagrant/servers`:

  ./multi-net/run-everywhere.sh -v -n "uptime"