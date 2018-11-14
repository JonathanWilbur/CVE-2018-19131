# CVE-2018-19131 Demo

* Author: [Jonathan M. Wilbur](https://jonathan.wilbur.space) <[jonathan@wilbur.space](mailto:jonathan@wilbur.space)>
* Copyright Year: 2018
* License: [MIT License](https://mit-license.org/)

**Do not do anything illegal with this. This is not malware. This is just a proof of concept.**

This is a demo of [CVE-2018-19131](https://nvd.nist.gov/vuln/detail/CVE-2018-19131),
which runs in a Docker Compose app.

![](./assets/exploit.gif)

This library builds Squid version 3.5.27, which is vulnerable. Version 3.5.28
is _not_ vulnerable. The particular versions that are affected are listed
[here](http://www.squid-cache.org/Advisories/SQUID-2018_4.txt).

Testing has succeeded on both Windows 10 and Mac OS X Mojave.

## Proof-of-Concept Usage

Don't run this on the same host that you are configured to proxy from,
because the proxy will redirect all HTTP requests back to itself. The client
and server should be two separate machines.

### Server Setup

1. Clone this repository by running `git clone https://github.com/JonathanWilbur/CVE-2018-19131.git`.
2. Change into the directory by running `cd CVE-2018-19131`.
3. Build the application by running `docker-compose up`.
  - This will take a long time (about 20 minutes), because it has to compile Squid from scratch.

### Client Setup

Setting up an HTTPS proxy is a really standard thing. Windows and MacOS has it.
Linux has anything if you're creative. I will not document how to set up a
proxy here, because it is already documented extensively elsewhere. Just
configure your computer to point to the server on which you installed the
vulnerable Squid instance.

I will note, however, that you should be using an `HTTPS` proxy, not `HTTP`. On
MacOS, in the `Proxies` settings, this is called a `Secure Web Proxy`. Windows
makes no such distinction.

### Exploitation

Access the malicious site by connecting to `https://web`. Accept the first
certificate error, which is just caused from the proxy intercepting the
HTTPS traffic, then you'll be presented with the next page, which will run
the exploit. You should see a web browser alert that says `HACKED!`.

After you click `OK`, you will see the default Squid page for a failure to
securely connect. You will notice that the issuer/subject name displayed--which
are one and the same, because this uses a self-signed certificate--is missing
the `commonName` (`CN`) attribute. That's because its value was:

```html
<script>alert("HACKED!");</script>
```

which gets interpreted as raw HTML and hence, the script gets executed!

## See Also

- [The Squid Homepage](http://www.squid-cache.org)
- [The National Vulnerability Database (NVD) Entry for CVE-2018-19131](https://nvd.nist.gov/vuln/detail/CVE-2018-19131)

## Contact Me

If you would like to suggest fixes or improvements on this library, please just
[leave an issue on this GitHub page](https://github.com/JonathanWilbur/CVE-2018-19131/issues). If you would like to contact me for other reasons,
please email me at [jonathan@wilbur.space](mailto:jonathan@wilbur.space)
([My GPG Key](https://jonathan.wilbur.space/downloads/jonathan@wilbur.space.gpg.pub))
([My TLS Certificate](https://jonathan.wilbur.space/downloads/jonathan@wilbur.space.chain.pem)). :boar: