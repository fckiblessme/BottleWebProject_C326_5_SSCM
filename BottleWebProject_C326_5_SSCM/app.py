"""
This script runs the application using a development server.
"""

import bottle
import os
import sys

PROJECT_ROOT = os.path.abspath(os.path.dirname(__file__))

bottle.TEMPLATE_PATH.insert(0, os.path.join(PROJECT_ROOT, 'views'))

import routes

if '--debug' in sys.argv[1:] or 'SERVER_DEBUG' in os.environ:
    bottle.debug(True)

def wsgi_app():
    """Returns the application to make available through wfastcgi. This is used
    when the site is published to Microsoft Azure."""
    return bottle.default_app()

if __name__ == '__main__':
    STATIC_ROOT = os.path.join(PROJECT_ROOT, 'static').replace('\\', '/')

    HOST = os.environ.get('SERVER_HOST', '127.0.0.1')
    try:
        PORT = int(os.environ.get('SERVER_PORT', '5555'))
    except ValueError:
        PORT = 5555

    @bottle.route('/static/<filepath:path>')
    def server_static(filepath):
        """Handler for static files, used with the development server.
        When running under a production server such as IIS or Apache,
        the server should be configured to serve the static files."""
        return bottle.static_file(filepath, root=STATIC_ROOT)


    bottle.run(server='wsgiref', host=HOST, port=PORT, debug=True, reloader=True)