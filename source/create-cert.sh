#!/bin/sh
openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days 10 -nodes