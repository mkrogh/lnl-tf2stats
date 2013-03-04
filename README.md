Team fortress 2 stats
=====================

A little library capable of tracking player stats by scanning Team fortress 2 logfiles.

Features
--------

* Calculates player points according to [TF2 wiki](http://wiki.teamfortress.com/wiki/Scoreboard#Points)
    * no bonus points atm.
* Tracks custom events such as, damage dealt, healing etc.


CLI usage
---------
    Usage:
      ruby tf2_stats.rb parse <log_files> # will print the leaderboard
      ruby tf2_stats.rb leaderboard -o leaderboard.html <log_files> # generate html leaderboard
    Example:
      ruby tf2_stats.rb parse "spec/\*.log"

Alternative CLI
---------------

As ruby is an intepreted language the above cli suffers from requirering too many libraries. So for now I have created an alternative CLI
    Example
      ruby -I lib/ tf2_stats.rb spec/trial_run.log 

This version when run with the trial run file will drop the run time from 1.7 seconds to 0.05. It is however not able to generate a leaderboard atm.

History
-------

This lib was created to track a 7 hour marathon of Team Fortress 2 at [NanoLaug's](http://www.nanolaug.dk/) netparty Plugged #19.
