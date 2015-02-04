Ruby FTW
========

Hacking instructions
--------------------

### Setup

Clone the repo and install the dependencies:

```bash
git clone https://github.com/rubyftw/rubyftw.github.com.git
cd rubyftw.github.com
bundle install
```

To run the jekyll server:

```bash
jekyll serve --watch
```

Then open <http://localhost:4000> in your browser.

### Organization

* Events are under `_upcoming_events`
* When an event is over, move it to `_archived_events`
* Feel free to add yourself to the members list in `includes/members.html` if you want to be on it
* It's not generally best practice to put PSDs and other types of source files in the same project
  as the source code, but it seemed fitting to put them here for easier group collaboration. They
  can be found under the `_source/` directory
* The directory `s/` is reserved for short links. (e.g. http://rubyftw.org/s/github =>
  https://github.com/rubyftw)


