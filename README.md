# The update script is designed to update your Django project hosted on a server from a cloud repository.
## Dependencies:
    - Virtualenv
    - Cloud Repository (github, bitbucket, etc.)
    - Initialization of your git on your server
    - Supervisord    

## Directions: 
    - Download or copy contents of the file onto server, run chmod +x update.sh, then ./update.sh


# The conf files are designed as a guide to how I got my Django project running on a ubuntu server Using Gunicorn, Nginx, Supervisord and Daphne.

## Directions
    - Change all variables and file paths to your variables and file paths. Here is an example of my file path structure:
        Django Project: /home/user/djangoproject/
            permissions: user:user
        VirtualEnv: /home/user/.virtualenvs/
            permissions: user:user
        Supervisor: /etc/supervisor/
            permissions: root:root
        Supervisor Config: /etc/supervisor/conf.d/
            permissions: root:root
        Supervisor Socks: /etc/supervisor/socks/
            permissions: user:user
        Nginx: /etc/nginx/
            permissions: root:root
        Nginx sites-enabled: /etc/nginx/sites-enabled/base.com (symlink to /etc/nginx/sites-available/base.com)
            permissions: root:root
        
# Here are a few of my django settings:
    STATIC_ROOT = join(os.path.dirname(BASE_DIR), "static")
    STATIC_URL = "/static/"
    STATICFILES_DIRS = ["djangoproject/static/templates"]
    STATICFILES_FINDERS = (
        "django.contrib.staticfiles.finders.FileSystemFinder",
        "django.contrib.staticfiles.finders.AppDirectoriesFinder",
    )
    MEDIA_ROOT = join(os.path.dirname(BASE_DIR), "media")
    MEDIA_URL = "/media/"
    TEMPLATES = [
        {
            "BACKEND": "django.template.backends.django.DjangoTemplates",
            "DIRS": STATICFILES_DIRS,
            "APP_DIRS": True,
            "OPTIONS": {
                "context_processors": [
                    "django.template.context_processors.debug",
                    "django.template.context_processors.request",
                    "django.contrib.auth.context_processors.auth",
                    "django.contrib.messages.context_processors.messages",
                ]
            },
        }
