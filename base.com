upstream django {
	server unix:/etc/supervisor/socks/gunicorn.sock;
}


upstream daphne {
	server unix:/etc/supervisor/socks/daphne.sock;
}

server {
    listen 80;
	return 301 https://$host$request_uri;	
	add_header X-debug-message "The non-ssl / location was served from django" always;
    
}


server {
	listen 443 ssl http2;
	server_name www.example.com;
	client_max_body_size 4G;
        add_header X-debug-message "The port 443 location was served from django" always;
	ssl_certificate /etc/nginx/ssl/example.crt;
        ssl_certificate_key /etc/nginx/ssl/example.key;
	add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
	proxy_set_header Host $host;
	proxy_set_header X-Forwarded-Proto $scheme;
	proxy_set_header X-Real-IP $remote_addr;
	proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
	proxy_headers_hash_max_size 1024;
	proxy_read_timeout 300s;
	proxy_connect_timeout 75s;

	access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log debug;
	
	location /media/ {
		autoindex off;
		alias /home/user/djangoproject/media/;
	}
	
	location /static/ {
		autoindex off;
		alias /home/user/djangoproject/static/;
    	}

	location / {
        	add_header X-debug-message "The ssl /api/v1/ location was served from django" always;
	    	proxy_pass https://django;
		proxy_ssl_server_name on;
	    	proxy_redirect off;
	}

	location /ws/socket/ {
        	add_header X-debug-message "The ssl /ws/ location was served from daphne" always;
        	proxy_pass https://daphne;
		proxy_ssl_certificate /etc/nginx/ssl/example.crt;
		proxy_ssl_certificate_key /etc/nginx/ssl/example.key;
        	proxy_redirect off;
        	proxy_http_version 1.1;
        	proxy_set_header Upgrade $http_upgrade;
        	proxy_set_header Connection "upgrade";
        	proxy_cache_bypass $http_upgrade;
		access_log /var/log/nginx/wsaccess.log;
		error_log /var/log/nginx/wserror.log debug;
        }
}

