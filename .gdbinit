# svn checkout svn://gcc.gnu.org/svn/gcc/trunk/libstdc++-v3/python libstdc++-v3
python
import sys
sys.path.insert(0, '/Users/vinceb/src/libstdc++-v3')
from libstdcxx.v6.printers import register_libstdcxx_printers
register_libstdcxx_printers (None)
end
