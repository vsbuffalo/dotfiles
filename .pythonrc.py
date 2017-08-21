import readline
import rlcompleter
if 'libedit' in readline.__doc__:
    readline.parse_and_bind("bind ^I rl_complete")
else:
    readline.parse_and_bind("tab: complete")
#
#import rlcompleter
#import readline
#readline.parse_and_bind("tab: complete")
