# A sample Six configuration file. You can use this file as a starting point for your
# own.
#
# To use this file, copy it to your Packages/User folder.
#
# The unusual code layout is needed to detect whether Six is available before changing
# settings and loading plugins.

import logging

import sublime


IS_SIX_INSTALLED = False


try:
    import Six
except ImportError:
    pass
else:
    IS_SIX_INSTALLED = True


if IS_SIX_INSTALLED:
    # We are assuming that the Six Surround plugin is installed. Adjust as necessary.
    from User.six.surround import (
        _six_surround_change,
        _six_surround_delete,
        surround,
        )


    # Hook ourselves up to the Six logger.
    _logger = logging.getLogger("Six.user.%s" % __name__.rsplit(".")[1])
    _logger.info("loading Six configuration")


    def is_six_available():
        settings = sublime.load_settings("Preferences.sublime-settings")
        return 'Six' not in settings.get("ignored_packages")


    def load_plugins():
        try:
            surround()
        except ValueError as e:
            if str(e).startswith("cannot register keys"):
                # We have reloaded sixrc.py; ignore command registration error.
                pass
            else:
                raise
        except Exception as e:
            _logger.error("error while (re)loading %s", __name__)
            _logger.error(e)


    def define_mappings():
        from Six._init_ import editor
        from Six.lib.constants import Mode

        # Mappings -- optional.
        editor.mappings.add(Mode.Normal, ",pp", "a()<Esc>i")
        editor.mappings.add(Mode.Normal, "<CR>", "/")
        editor.mappings.add(Mode.Normal, "<Space>", ":")
        editor.mappings.add(Mode.Normal, "Y", "y$")


    def plugin_loaded():
        # Now the full Sublime Text API is available to us.
        if not is_six_available():
            return

        # Init plugins. We do this here because now we know that Six is definitely
        # available.
        load_plugins()
        define_mappings()
