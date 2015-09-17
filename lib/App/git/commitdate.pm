use strict;
use warnings;
use 5.020;
use experimental qw( signatures postderef );

package App::git::commitdate {

  # ABSTRACT: Set the date on a commit
  # VERSION

  use Time::Local qw( timelocal );
  use namespace::autoclean;

  sub main($class, $date, @commit_args) {
    if(defined $date) {
      if($date =~ /^(?<year>[0-9]{4})-(?<month>[0-9]{1,2})-(?<day>[0-9]{1,2})$/) {
        my $sec  = int rand 60;
        my $min  = int rand 60;
        my $hour = 7 + int rand 10;
        #say "$hour:$min:$sec";
        $date = timelocal $sec, $min, $hour, $+{day}, $+{month}, $+{year};
      } else {
        say STDERR "does not look like a date: $date";
        return 2;
      }
    } else {
      say STDERR "usage: git commit-date yyyy-mm-dd [commit flags]";
      return 2;
    }

    say "% git commit --date=$date @commit_args";
    exec 'git', 'commit', "--date=$date", @commit_args;
  }

}

1;
