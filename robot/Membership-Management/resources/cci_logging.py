"""Workaround for a logging loop between CumulusCI and Robot Framework.

``cci`` copies everything written to the console into its ``tempfile_logger``.
By default that logger also passes each message on to the root logger, where
Robot Framework picks it up and can write to the console again. In browser
tests this ended in ``RecursionError: maximum recursion depth exceeded``
(seen with CumulusCI 4.11.0 and Robot Framework 7.5.1).

Importing this library stops that hand-off for the rest of the run. It relies
on a CumulusCI internal logger name, so remove it once CumulusCI no longer
needs it.
"""

import logging

logging.getLogger("tempfile_logger").propagate = False
