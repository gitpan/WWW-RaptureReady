use 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'WWW::RaptureReady',
    VERSION_FROM      => 'RaptureReady.pm', 
    PREREQ_PM         => { LWP::UserAgent => 0 }, 
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'RaptureReady.pm', 
       AUTHOR         => 'blair christensen. <blair@devclue.com>') : ()),
);
